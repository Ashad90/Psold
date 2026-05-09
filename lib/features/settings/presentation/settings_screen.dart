import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/locale_provider.dart';
import 'package:psold/core/router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProvider);

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
              _SettingsTile(
                icon: Icons.dark_mode,
                title: 'Thème',
                subtitle: 'Système',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: PsoldSpacing.md),
          if (profile != null) ...[
            _buildSection(
              context,
              title: 'Compte',
              children: [
                _SettingsTile(
                  icon: Icons.person,
                  title: 'Profil',
                  subtitle: profile.displayName ?? 'Mon compte',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.logout,
                  title: 'Déconnexion',
                  subtitle: 'Se déconnecter de l\'application',
                  onTap: () async {
                    await ref.read(currentUserProvider.notifier).signOut();
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ],
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