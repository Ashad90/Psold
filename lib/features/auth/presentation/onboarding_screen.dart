import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/locale_provider.dart';
import 'package:psold/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page - go to register
      if (mounted) {
        context.go('/register');
      }
    }
  }

  void _onSkipPressed() {
    if (mounted) {
      context.go('/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildOnboardingPage(
                    context,
                    l10n.onboardingSlide1Title,
                    l10n.onboardingSlide1Description,
                    'assets/images/psold_logo.png',
                  ),
                  _buildOnboardingPage(
                    context,
                    l10n.onboardingSlide2Title,
                    l10n.onboardingSlide2Description,
                    'assets/images/psold_logo.png',
                  ),
                  _buildOnboardingPage(
                    context,
                    l10n.onboardingSlide3Title,
                    l10n.onboardingSlide3Description,
                    'assets/images/psold_logo.png',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(PsoldSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onSkipPressed,
                    child: Text(
                      l10n.onboardingSkip,
                      style: TextStyle(
                        color: PsoldColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // Dots indicator
                      ...List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 12.0 : 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? PsoldColors.primary
                                : PsoldColors.textSecondary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: PsoldSpacing.md),
                      ElevatedButton(
                        onPressed: _onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PsoldColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: PsoldSpacing.lg,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage < 2
                              ? l10n.onboardingNext
                              : l10n.onboardingGetStarted,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(
      BuildContext context, String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(PsoldSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: PsoldSpacing.xl),
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: PsoldColors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PsoldSpacing.md),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: PsoldColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}