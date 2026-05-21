import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/locale_provider.dart';
import 'package:psold/core/router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(PsoldSpacing.md),
        children: [
          if (profile != null) ...[
            _buildProfileCard(context, profile),
            const SizedBox(height: PsoldSpacing.md),
          ],
          _buildSection(
            context,
            title: 'Apparence',
            children: [
              _SettingsTile(
                icon: Icons.language,
                title: 'Langue',
                subtitle: _getLanguageName(ref.watch(localeProvider).languageCode),
                onTap: () => _showLanguageSheet(context, ref),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.dark_mode,
                title: 'Thème',
                subtitle: _getThemeName(themeMode),
                onTap: () => _showThemeSheet(context, ref),
              ),
            ],
          ),
          const SizedBox(height: PsoldSpacing.md),
          _buildSection(
            context,
            title: 'Compte',
            children: [
              if (profile != null) ...[
                _SettingsTile(
                  icon: Icons.person,
                  title: 'Mon profil',
                  subtitle: profile.displayName ?? 'Voir mon profil',
                  onTap: () => context.push('/profile'),
                ),
                const Divider(height: 1),
              ],
              _SettingsTile(
                icon: Icons.logout,
                title: 'Déconnexion',
                subtitle: 'Se déconnecter de l\'application',
                onTap: () => _showLogoutDialog(context, ref),
                isDestructive: true,
              ),
            ],
          ),
          const SizedBox(height: PsoldSpacing.md),
          _buildSection(
            context,
            title: 'À propos',
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: 'Psold v1.0.0',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(PsoldSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: PsoldColors.primary.withValues(alpha: 0.1),
            child: Icon(
              profile.isMerchant ? Icons.storefront_rounded : Icons.person_rounded,
              color: PsoldColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: PsoldSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName ?? 'Utilisateur',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: profile.isMerchant ? PsoldColors.primary.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    profile.isMerchant ? 'Marchand' : 'Client',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: profile.isMerchant ? PsoldColors.primary : Colors.blue,
                    ),
                  ),
                ),
                if (profile.city != null) ...[
                  const SizedBox(height: 4),
                  Text(profile.city!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: PsoldSpacing.sm),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'fr': return 'Français';
      case 'en': return 'English';
      case 'ar': return 'العربية';
      default: return code;
    }
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'Clair';
      case ThemeMode.dark: return 'Sombre';
      case ThemeMode.system: return 'Système';
    }
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(PsoldSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choisir la langue', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: PsoldSpacing.md),
            _LanguageOption(label: 'Français', code: 'fr', current: ref.read(localeProvider).languageCode, onTap: (code) {
              ref.read(localeProvider.notifier).setLocale(code);
              Navigator.pop(context);
            }),
            _LanguageOption(label: 'English', code: 'en', current: ref.read(localeProvider).languageCode, onTap: (code) {
              ref.read(localeProvider.notifier).setLocale(code);
              Navigator.pop(context);
            }),
            _LanguageOption(label: 'العربية', code: 'ar', current: ref.read(localeProvider).languageCode, onTap: (code) {
              ref.read(localeProvider.notifier).setLocale(code);
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showThemeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(PsoldSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choisir le thème', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: PsoldSpacing.md),
            _ThemeOption(label: 'Clair', icon: Icons.light_mode, mode: ThemeMode.light, current: ref.read(themeModeProvider), onTap: (mode) {
              ref.read(themeModeProvider.notifier).setThemeMode(mode);
              Navigator.pop(context);
            }),
            _ThemeOption(label: 'Sombre', icon: Icons.dark_mode, mode: ThemeMode.dark, current: ref.read(themeModeProvider), onTap: (mode) {
              ref.read(themeModeProvider.notifier).setThemeMode(mode);
              Navigator.pop(context);
            }),
            _ThemeOption(label: 'Système', icon: Icons.settings_brightness, mode: ThemeMode.system, current: ref.read(themeModeProvider), onTap: (mode) {
              ref.read(themeModeProvider.notifier).setThemeMode(mode);
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(currentUserProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ThemeMode.system);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(super.initialTheme);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : null),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String code;
  final String current;
  final Function(String) onTap;

  const _LanguageOption({
    required this.label,
    required this.code,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = code == current;
    return ListTile(
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check, color: PsoldColors.primary) : null,
      onTap: () => onTap(code),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeMode mode;
  final ThemeMode current;
  final Function(ThemeMode) onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.mode,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == current;
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check, color: PsoldColors.primary) : null,
      onTap: () => onTap(mode),
    );
  }
}
