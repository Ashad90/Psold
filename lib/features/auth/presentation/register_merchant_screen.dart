import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/shared/providers/auth_provider.dart';

class RegisterMerchantScreen extends ConsumerStatefulWidget {
  const RegisterMerchantScreen({super.key});

  @override
  ConsumerState<RegisterMerchantScreen> createState() => _RegisterMerchantScreenState();
}

class _RegisterMerchantScreenState extends ConsumerState<RegisterMerchantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _cityController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!), backgroundColor: Colors.red));
      }
      setState(() => _isLoading = next.isLoading);
    });

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
        title: const Text('Inscription Marchand'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PsoldSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Nom de la boutique *', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: PsoldSpacing.xs),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Ex: Supermarché Central', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: PsoldSpacing.md),
              Text('Email *', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: PsoldSpacing.xs),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'votre@email.com', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: PsoldSpacing.md),
              Text('Numéro WhatsApp * (format E.164)', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: PsoldSpacing.xs),
              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: 'Ex: +23600000000', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: PsoldSpacing.md),
              Text('Ville *', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: PsoldSpacing.xs),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(hintText: 'Ex: Bangui', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: PsoldSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      final notifier = ref.read(authProvider.notifier);
                      await notifier.signUpMerchant(
                        email: _emailController.text.trim(),
                        displayName: _nameController.text.trim(),
                        whatsapp: _whatsappController.text.trim(),
                        city: _cityController.text.trim(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PsoldColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                      : const Text('Créer mon compte Marchand', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}