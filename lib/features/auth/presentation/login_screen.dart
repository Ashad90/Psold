import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/shared/utils/google_auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _usePhone = false;
  bool _otpSent = false;
  final _countryCode = '+236';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer email et mot de passe'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null && mounted) {
        context.go('/feed');
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

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await GoogleAuthService.instance.signIn();
    } catch (e) {
      debugPrint('Google sign in error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur Google: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer votre numéro de téléphone'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final fullPhone = '$_countryCode$phone';

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithOtp(phone: fullPhone);

      if (mounted) {
        setState(() => _otpSent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Code envoyé au $fullPhone'),
            backgroundColor: Colors.green,
          ),
        );
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

  Future<void> _verifyOtp() async {
    final code = _codeController.text.trim();
    final phone = _phoneController.text.trim();

    if (code.isEmpty || code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer le code à 6 chiffres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final fullPhone = '$_countryCode$phone';

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.verifyOTP(
        phone: fullPhone,
        token: code,
        type: OtpType.sms,
      );

      if (response.user != null && mounted) {
        context.go('/feed');
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
    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(PsoldSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: PsoldSpacing.xxxl),
              Image.asset(
                'assets/images/psold_logo.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: PsoldSpacing.sm),
              Text(
                'Les Produits en Solde',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PsoldSpacing.xxxl),
              Text(
                'Connexion',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: PsoldSpacing.lg),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('E-mail')),
                  ButtonSegment(value: true, label: Text('Téléphone')),
                ],
                selected: {_usePhone},
                showSelectedIcon: false,
                onSelectionChanged: (selected) => setState(() {
                  _usePhone = selected.first;
                  _otpSent = false;
                  _codeController.clear();
                }),
              ),
              const SizedBox(height: PsoldSpacing.lg),
              if (_usePhone) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    hintText: 'XX XX XX XX',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                if (!_otpSent) ...[
                  const SizedBox(height: PsoldSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PsoldColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                            )
                          : const Text('Envoyer le code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: PsoldSpacing.lg),
                  Text(
                    'Un code a été envoyé au $_countryCode${_phoneController.text.trim()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PsoldSpacing.md),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Code à 6 chiffres',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: PsoldSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PsoldColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                            )
                          : const Text('Vérifier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ] else ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Adresse e-mail',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: PsoldSpacing.md),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: PsoldSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signInWithEmailPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PsoldColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                          )
                        : const Text('Se connecter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
              const SizedBox(height: PsoldSpacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md),
                    child: Text('ou', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: PsoldSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.network(
                      'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24),
                    ),
                  ),
                  label: const Text('Continuer avec Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: PsoldSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Pas de compte ? ", style: Theme.of(context).textTheme.bodyMedium),
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: Text(
                      'Créer un compte',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PsoldColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
