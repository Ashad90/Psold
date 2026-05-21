import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:psold/core/router.dart';

class LocationState {
  final double? latitude;
  final double? longitude;
  final bool isLoading;
  final String? error;
  final bool permissionDenied;
  final bool isBackgroundMode;

  const LocationState({
    this.latitude,
    this.longitude,
    this.isLoading = false,
    this.error,
    this.permissionDenied = false,
    this.isBackgroundMode = false,
  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    bool? isLoading,
    String? error,
    bool? permissionDenied,
    bool? isBackgroundMode,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      permissionDenied: permissionDenied ?? this.permissionDenied,
      isBackgroundMode: isBackgroundMode ?? this.isBackgroundMode,
    );
  }

  bool get hasLocation => latitude != null && longitude != null;
}

class LocationNotifier extends StateNotifier<LocationState> {
  StreamSubscription<Position>? _positionStreamSubscription;
  Ref? _ref;
  Timer? _backgroundSyncTimer;

  LocationNotifier() : super(const LocationState());

  void setRef(Ref ref) {
    _ref = ref;
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          error: 'Location services are disabled',
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLoading: false,
            error: 'Location permission denied',
            permissionDenied: true,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoading: false,
          error: 'Location permissions are permanently denied',
          permissionDenied: true,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      state = LocationState(
        latitude: position.latitude,
        longitude: position.longitude,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> startBackgroundTracking() async {
    if (!state.hasLocation) await getCurrentLocation();

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      ),
    ).listen((Position position) {
      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        isBackgroundMode: true,
      );
      _saveLocationToDatabase(position.latitude, position.longitude);
    });

    _backgroundSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (state.hasLocation) {
        _saveLocationToDatabase(state.latitude!, state.longitude!);
      }
    });

    state = state.copyWith(isBackgroundMode: true);
  }

  Future<void> stopBackgroundTracking() async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _backgroundSyncTimer?.cancel();
    _backgroundSyncTimer = null;
    state = state.copyWith(isBackgroundMode: false);
  }

  Future<void> _saveLocationToDatabase(double lat, double lng) async {
    if (_ref == null) return;
    try {
      final profile = _ref!.read(currentUserProvider);
      if (profile == null || !profile.isMerchant) return;

      final supabase = _ref!.read(supabaseClientProvider);
      await supabase.from('profiles').update({
        'location': 'POINT($lng $lat)',
      }).eq('id', profile.id);
    } catch (_) {}
  }

  double? distanceTo(double lat, double lng) {
    if (!state.hasLocation) return null;
    return Geolocator.distanceBetween(
      state.latitude!,
      state.longitude!,
      lat,
      lng,
    );
  }

  double? distanceInKmTo(double lat, double lng) {
    final distanceMeters = distanceTo(lat, lng);
    if (distanceMeters == null) return null;
    return distanceMeters / 1000;
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _backgroundSyncTimer?.cancel();
    super.dispose();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  final notifier = LocationNotifier();
  notifier.setRef(ref);
  return notifier;
});

final userLocationProvider = Provider<({double? lat, double? lng})>((ref) {
  final locationState = ref.watch(locationProvider);
  return (lat: locationState.latitude, lng: locationState.longitude);
});

final isBackgroundLocationEnabledProvider = Provider<bool>((ref) {
  final locationState = ref.watch(locationProvider);
  return locationState.isBackgroundMode;
});