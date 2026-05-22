import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleProfileSetupScreen extends ConsumerStatefulWidget {
  const GoogleProfileSetupScreen({super.key});

  @override
  ConsumerState<GoogleProfileSetupScreen> createState() => _GoogleProfileSetupScreenState();
}

class _GoogleProfileSetupScreenState extends ConsumerState<GoogleProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _cityController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'client';

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId != null) {
        await supabase.from('profiles').upsert({
          'id': userId,
          'role': _selectedRole,
          'display_name': _nameController.text.trim(),
          'whatsapp': _whatsappController.text.trim(),
          'city': _cityController.text.trim(),
        });

        if (mounted) {
          context.go('/feed');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProvider);
    if (profile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/feed'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
        title: const Text('Finaliser votre compte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: PsoldColors.textPrimary),
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
                  if (context.mounted) context.go('/login');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PsoldSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: PsoldSpacing.md),
              Text(
                'Complétez votre profil pour continuer',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: PsoldSpacing.xl),
              Text(
                'Je suis un:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: PsoldSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedRole = 'client'),
                      child: Container(
                        padding: const EdgeInsets.all(PsoldSpacing.md),
                        decoration: BoxDecoration(
                          color: _selectedRole == 'client' ? PsoldColors.primary.withValues(alpha: 0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedRole == 'client' ? PsoldColors.primary : Colors.grey.shade300,
                            width: _selectedRole == 'client' ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag_rounded,
                              color: _selectedRole == 'client' ? PsoldColors.primary : Colors.grey,
                              size: 32,
                            ),
                            const SizedBox(height: PsoldSpacing.xs),
                            Text(
                              'Client',
                              style: TextStyle(
                                fontWeight: _selectedRole == 'client' ? FontWeight.w700 : FontWeight.w400,
                                color: _selectedRole == 'client' ? PsoldColors.primary : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: PsoldSpacing.md),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedRole = 'merchant'),
                      child: Container(
                        padding: const EdgeInsets.all(PsoldSpacing.md),
                        decoration: BoxDecoration(
                          color: _selectedRole == 'merchant' ? PsoldColors.primary.withValues(alpha: 0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedRole == 'merchant' ? PsoldColors.primary : Colors.grey.shade300,
                            width: _selectedRole == 'merchant' ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.storefront_rounded,
                              color: _selectedRole == 'merchant' ? PsoldColors.primary : Colors.grey,
                              size: 32,
                            ),
                            const SizedBox(height: PsoldSpacing.xs),
                            Text(
                              'Marchand',
                              style: TextStyle(
                                fontWeight: _selectedRole == 'merchant' ? FontWeight.w700 : FontWeight.w400,
                                color: _selectedRole == 'merchant' ? PsoldColors.primary : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PsoldSpacing.lg),
              Text(
                _selectedRole == 'merchant' ? 'Nom de la boutique *' : 'Prénom ou pseudo *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: PsoldSpacing.xs),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: _selectedRole == 'merchant' ? 'Ex: Supermarché Central' : 'Votre prénom ou pseudo',
                  prefixIcon: Icon(
                    _selectedRole == 'merchant' ? Icons.storefront_outlined : Icons.person_outline,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: PsoldSpacing.md),
              Text(
                'Numéro WhatsApp * (format E.164)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: PsoldSpacing.xs),
              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+23600000000',
                  prefixIcon: const Icon(Icons.chat_bubble_outline, color: PsoldColors.whatsapp),
                  helperText: _selectedRole == 'merchant' ? 'Obligatoire pour contact avec les clients' : 'Pour être contacté par les marchands',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Le numéro WhatsApp est requis' : null,
              ),
              const SizedBox(height: PsoldSpacing.md),
              Text(
                'Ville ou quartier *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: PsoldSpacing.xs),
              TextFormField(
                controller: _cityController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Ex: Bangui, PK5',
                  prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v == null || v.isEmpty ? 'La ville est requise' : null,
              ),
              const SizedBox(height: PsoldSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completeProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PsoldColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                        )
                      : const Text('Continuer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: PsoldSpacing.md),
              TextButton(
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();
            if (context.mounted) context.go('/login');
                },
                child: const Text('Se déconnecter et utiliser un autre compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}