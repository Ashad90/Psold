import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psold/core/router.dart';

const _settingsBox = 'settings';
const _notificationsAskedKey = 'notifications_asked';
const _notificationPermissionKey = 'notification_permission_granted';

enum NotificationSound {
  newProduct,
  like,
  comment,
  general,
}

class NotificationService {
  final Ref _ref;
  bool _initialized = false;

  NotificationService(this._ref);

  Future<bool> hasUserDecidedNotifications() async {
    final box = Hive.box(_settingsBox);
    return box.get(_notificationsAskedKey, defaultValue: false) as bool;
  }

  Future<void> markNotificationsAsked() async {
    final box = Hive.box(_settingsBox);
    await box.put(_notificationsAskedKey, true);
  }

  Future<void> initialize() async {
    if (_initialized) return;

    final hasDecided = await hasUserDecidedNotifications();

    if (hasDecided) {
      await _setupMessageHandlers();
      await _subscribeToTopics();
    }

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (granted) {
      await markNotificationsAsked();
      await _setupMessageHandlers();
      await _subscribeToTopics();

      final box = Hive.box(_settingsBox);
      await box.put(_notificationPermissionKey, true);
    }

    return granted;
  }

  Future<bool> isPermissionGranted() async {
    final box = Hive.box(_settingsBox);
    return box.get(_notificationPermissionKey, defaultValue: false) as bool;
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final soundType = message.data['sound'] as String?;
    _showLocalNotification(message, soundType);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    _handleMessage(message);
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;

    switch (type) {
      case 'product':
        final productId = data['product_id'] as String?;
        if (productId != null) {
          _navigateToProduct(productId);
        }
        break;
      case 'new_product':
        _navigateToFeed();
        break;
      default:
        _navigateToFeed();
    }
  }

  void _showLocalNotification(RemoteMessage message, String? soundType) {
    // For custom ringtones, use flutter_local_notifications with audio files
    // Place custom sounds in: assets/sounds/
    // Files: new_product.mp3, like.mp3, comment.mp3, notification.mp3
  }

  void _navigateToProduct(String productId) {
    // Navigation will be handled by the app's router
  }

  void _navigateToFeed() {
    // Navigation handled by app
  }

  Future<void> _subscribeToTopics() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.subscribeToTopic('new_products');

    final profile = _ref.read(currentUserProvider);
    if (profile != null) {
      if (profile.isMerchant) {
        await messaging.subscribeToTopic('merchant_updates');
        await messaging.subscribeToTopic('merchant_comments');
        await messaging.subscribeToTopic('merchant_likes');
      } else {
        await messaging.subscribeToTopic('client_notifications');
      }
    }
  }

  Future<void> subscribeToMerchantTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('merchant_updates');
  }

  Future<void> subscribeToClientTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('client_notifications');
  }

  Future<void> unsubscribeFromMerchantTopic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic('merchant_updates');
  }

  Future<void> unsubscribeFromClientTopic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic('client_notifications');
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> saveTokenToDatabase(String token) async {
    try {
      final supabase = _ref.read(supabaseClientProvider);
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        await supabase.from('profiles').update({'fcm_token': token}).eq('id', userId);
      }
    } catch (_) {}
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getToken();
});