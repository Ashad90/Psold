import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: PsoldSpacing.md),
            Text(
              profile?.displayName ?? 'Utilisateur',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: PsoldSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md, vertical: PsoldSpacing.xs),
              decoration: BoxDecoration(
                color: profile?.isMerchant == true ? PsoldColors.primary : Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                profile?.isMerchant == true ? 'Marchand' : 'Client',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: PsoldSpacing.md),
            if (profile?.city != null) Text('${profile!.city}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}