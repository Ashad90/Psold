import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumUpsellScreen extends ConsumerStatefulWidget {
  const PremiumUpsellScreen({super.key});

  @override
  ConsumerState<PremiumUpsellScreen> createState() => _PremiumUpsellScreenState();
}

class _PremiumUpsellScreenState extends ConsumerState<PremiumUpsellScreen> {
  bool _isLoading = false;

  Future<void> _activatePremium() async {
    final userProfile = ref.read(currentUserProvider);
    if (userProfile == null) return;

    if (userProfile.isPremium) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vous êtes déjà premium.')),
        );
        context.pop();
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Non connecté.');

      final response = await Supabase.instance.client.functions.invoke(
        'create-checkout',
        body: {'user_id': userId},
      );

      final data = response.data as Map<String, dynamic>?;
      final url = data?['url'] as String?;

      if (url == null) throw Exception('Impossible de créer la session de paiement.');

      final uri = Uri.parse(url);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!launched) throw Exception('Impossible d\'ouvrir le navigateur.');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(PsoldSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(PsoldSpacing.lg),
                decoration: BoxDecoration(
                  color: PsoldColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, size: 64, color: PsoldColors.primary),
              ),
              const SizedBox(height: PsoldSpacing.lg),
              Text(
                'Limite quotidienne atteinte',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: PsoldSpacing.md),
              Text(
                'Vous avez atteint votre limite gratuite de ${UserProfile.freeImageLimit} images et ${UserProfile.freeVideoLimit} vidéos par jour.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: PsoldColors.textSecondary),
              ),
              const SizedBox(height: PsoldSpacing.sm),
              Text(
                'Passez au Premium pour publier sans limite.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: PsoldColors.textSecondary),
              ),
              const SizedBox(height: PsoldSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _activatePremium,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PsoldColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: PsoldColors.primary.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Passer au Premium',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: PsoldSpacing.md),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Plus tard', style: TextStyle(color: PsoldColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
