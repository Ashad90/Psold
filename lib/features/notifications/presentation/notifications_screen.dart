import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/notifications/domain/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
        actions: [
          notificationsAsync.when(
            data: (notifications) {
              final hasUnread = notifications.any((n) => !n.isRead);
              if (!hasUnread) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => ref.read(markAllNotificationsReadProvider)(),
                child: const Text('Tout marquer lu', style: TextStyle(fontSize: 13)),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: PsoldSpacing.md),
                  Text(
                    'Aucune notification',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: PsoldSpacing.sm),
                  Text(
                    'Vous recevrez des alertes sur les produits qui vous intéressent',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: PsoldSpacing.sm),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationTile(notification: notification);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: PsoldSpacing.md),
              Text('Erreur: $e'),
              const SizedBox(height: PsoldSpacing.md),
              ElevatedButton(
                onPressed: () => ref.invalidate(notificationsProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.grey[100] : PsoldColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          notification.icon,
          color: notification.isRead ? Colors.grey : PsoldColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w600,
        ),
      ),
      subtitle: notification.body != null
          ? Text(notification.body!, maxLines: 2, overflow: TextOverflow.ellipsis)
          : null,
      trailing: Text(
        notification.timeAgo,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
      onTap: () {
        if (!notification.isRead) {
          ref.read(markNotificationReadProvider(notification.id))();
        }
      },
    );
  }
}
