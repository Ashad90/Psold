import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';
import 'package:psold/flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _cityController = TextEditingController();
  File? _avatarFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(currentUserProvider);
      if (profile != null) {
        _nameController.text = profile.displayName ?? '';
        _whatsappController.text = profile.whatsapp ?? '';
        _cityController.text = profile.city ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 400);
    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));
    }
  }

  Future<String?> _uploadAvatar(String userId) async {
    if (_avatarFile == null) return null;
    final bytes = await _avatarFile!.readAsBytes();
    final fileName = 'avatars/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await Supabase.instance.client.storage.from('products').uploadBinary(fileName, bytes);
    return Supabase.instance.client.storage.from('products').getPublicUrl(fileName);
  }

  Future<void> _save() async {
    final profile = ref.read(currentUserProvider);
    if (profile == null) return;

    setState(() => _isSaving = true);

    try {
      String? avatarUrl;
      if (_avatarFile != null) {
        avatarUrl = await _uploadAvatar(profile.id);
      }

      final updates = <String, dynamic>{
        'display_name': _nameController.text.trim(),
        'city': _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
        if (profile.isMerchant)
          'whatsapp': _whatsappController.text.trim().isEmpty ? null : _whatsappController.text.trim(),
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };

      if (updates.isNotEmpty) {
        await Supabase.instance.client
            .from('profiles')
            .update(updates)
            .eq('id', profile.id);
      }

      ref.read(currentUserProvider.notifier).ensureUploadReset();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PsoldSpacing.md),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarFile != null
                        ? FileImage(_avatarFile!)
                        : (profile?.avatarUrl != null
                            ? NetworkImage(profile!.avatarUrl!)
                            : null),
                    child: (_avatarFile == null && profile?.avatarUrl == null)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: PsoldColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PsoldSpacing.lg),
            _buildField(label: 'Nom / Pseudo', controller: _nameController),
            const SizedBox(height: PsoldSpacing.md),
            if (profile?.isMerchant == true) ...[
              _buildField(label: 'WhatsApp', controller: _whatsappController, hint: '+236XXXXXXXXX'),
              const SizedBox(height: PsoldSpacing.md),
            ],
            _buildField(label: 'Ville', controller: _cityController, hint: 'Ex: Bangui'),
            const SizedBox(height: PsoldSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PsoldColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                    : const Text('Enregistrer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({required String label, required TextEditingController controller, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: PsoldSpacing.xs),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: PsoldColors.primary)),
          ),
        ),
      ],
    );
  }
}
