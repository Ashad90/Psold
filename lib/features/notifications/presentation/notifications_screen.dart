import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
            const SizedBox(height: PsoldSpacing.md),
            Text(
              'Aucune notification',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}