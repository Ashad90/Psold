import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/router.dart';

class AppNotification {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String? body;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      body: map['body'] as String?,
      isRead: map['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  IconData get icon {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'new_product':
        return Icons.shopping_bag;
      case 'product_expiry':
        return Icons.warning_amber;
      default:
        return Icons.notifications;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'il y a ${diff.inDays}j';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return [];

  final response = await supabase
      .from('notifications')
      .select()
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .limit(50);

  return (response as List).map((row) => AppNotification.fromMap(Map<String, dynamic>.from(row))).toList();
});

final unreadNotificationsCountProvider = FutureProvider<int>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return 0;

  final response = await supabase
      .from('notifications')
      .select()
      .eq('user_id', userId)
      .eq('is_read', false);

  return (response as List).length;
});

final markNotificationReadProvider = Provider.family<Future<void> Function(), String>((ref, notificationId) {
  return () async {
    final supabase = ref.watch(supabaseClientProvider);
    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationsCountProvider);
  };
});

final markAllNotificationsReadProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final supabase = ref.watch(supabaseClientProvider);
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);

    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationsCountProvider);
  };
});
