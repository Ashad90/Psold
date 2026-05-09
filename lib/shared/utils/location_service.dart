import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class LocationState {
  final double? latitude;
  final double? longitude;
  final bool isLoading;
  final String? error;
  final bool permissionDenied;

  const LocationState({
    this.latitude,
    this.longitude,
    this.isLoading = false,
    this.error,
    this.permissionDenied = false,
  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    bool? isLoading,
    String? error,
    bool? permissionDenied,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      permissionDenied: permissionDenied ?? this.permissionDenied,
    );
  }

  bool get hasLocation => latitude != null && longitude != null;
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(const LocationState());

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
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

final userLocationProvider = Provider<({double? lat, double? lng})>((ref) {
  final locationState = ref.watch(locationProvider);
  return (lat: locationState.latitude, lng: locationState.longitude);
});