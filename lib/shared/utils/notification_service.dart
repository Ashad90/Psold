import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:psold/core/router.dart';

class NotificationService {
  final Ref _ref;
  bool _initialized = false;

  NotificationService(this._ref);

  Future<void> initialize() async {
    if (_initialized) return;

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _setupMessageHandlers();
      await _subscribeToTopics();
    }

    _initialized = true;
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
    _showLocalNotification(message);
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

  void _showLocalNotification(RemoteMessage message) {
    // Local notifications handled by system when app is in foreground
    // For custom handling, use flutter_local_notifications package
  }

  void _navigateToProduct(String productId) {
    // Navigation will be handled by the app's router
    // The notification payload contains the product ID
  }

  void _navigateToFeed() {
    // Navigation handled by app
  }

  Future<void> _subscribeToTopics() async {
    final messaging = FirebaseMessaging.instance;
    
    // Subscribe to general topic for all users
    await messaging.subscribeToTopic('new_products');
    
    // User-specific topics will be subscribed based on user role
    final profile = _ref.read(currentUserProvider);
    if (profile != null) {
      if (profile.isMerchant) {
        await messaging.subscribeToTopic('merchant_updates');
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