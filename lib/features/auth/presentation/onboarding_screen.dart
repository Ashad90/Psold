import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/locale_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:psold/flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/animations/psold_logo_animation.json',
                controller: _controller,
                repeat: false,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                  _controller.forward();
                },
              ),
            ),
            const SizedBox(height: PsoldSpacing.lg),
            Text(
              l10n.appName,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800, color: PsoldColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PsoldSpacing.sm),
            Text(
              l10n.tagline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: PsoldColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.lg),
              child: Column(
                children: [
                  _LanguageSelector(locale: locale),
                  const SizedBox(height: PsoldSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PsoldColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Commencer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PsoldSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _LanguageSelector extends ConsumerWidget {
  final Locale locale;

  const _LanguageSelector({required this.locale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LanguageChip(code: 'fr', label: 'FR', isSelected: locale.languageCode == 'fr', onTap: () => ref.read(localeProvider.notifier).setLocale('fr')),
        const SizedBox(width: PsoldSpacing.sm),
        _LanguageChip(code: 'en', label: 'EN', isSelected: locale.languageCode == 'en', onTap: () => ref.read(localeProvider.notifier).setLocale('en')),
        const SizedBox(width: PsoldSpacing.sm),
        _LanguageChip(code: 'ar', label: 'ع', isSelected: locale.languageCode == 'ar', onTap: () => ref.read(localeProvider.notifier).setLocale('ar')),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String code;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({required this.code, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md, vertical: PsoldSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? PsoldColors.primary : Colors.transparent,
          border: Border.all(color: isSelected ? PsoldColors.primary : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
