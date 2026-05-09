import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/features/upload/domain/upload_provider.dart';
import 'package:psold/features/upload/data/upload_repository.dart';
import 'package:go_router/go_router.dart';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);

    ref.listen(uploadProvider, (previous, next) {
      if (next.status == UploadStatus.uploaded) {
        notifier.reset();
        context.go('/feed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit publié avec succès !'), backgroundColor: Colors.green),
        );
      } else if (next.status == UploadStatus.rejected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produit refusé : ${next.rejectionReason}'), backgroundColor: Colors.red),
        );
      } else if (next.status == UploadStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: Colors.red),
        );
      }
    });

    final isLoading = uploadState.status == UploadStatus.uploading || uploadState.status == UploadStatus.validating;

    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Publier un produit'),
        backgroundColor: PsoldColors.backgroundLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PsoldSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePicker(context, uploadState, notifier),
            const SizedBox(height: PsoldSpacing.lg),
            if (uploadState.images.isNotEmpty) ...[
              _buildImageGallery(uploadState, notifier),
              const SizedBox(height: PsoldSpacing.lg),
              _buildProductForm(context, uploadState, notifier, ref, isLoading),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, UploadState state, UploadNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photos du produit', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: PsoldSpacing.sm),
        Row(
          children: [
            Expanded(child: _ImagePickerButton(icon: Icons.camera_alt_rounded, label: 'Caméra', onTap: notifier.pickSingleImage, isLoading: state.status == UploadStatus.picking)),
            const SizedBox(width: PsoldSpacing.sm),
            Expanded(child: _ImagePickerButton(icon: Icons.photo_library_rounded, label: 'Galerie', onTap: notifier.pickImages, isLoading: state.status == UploadStatus.picking)),
          ],
        ),
      ],
    );
  }

  Widget _buildImageGallery(UploadState state, UploadNotifier notifier) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: PsoldSpacing.sm),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(state.images[index].path), width: 100, height: 100, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => notifier.removeImage(index),
                    child: Container(width: 32, height: 32, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Icon(Icons.close, color: Colors.white, size: 18)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductForm(BuildContext context, UploadState state, UploadNotifier notifier, WidgetRef ref, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormField(label: 'Titre du produit *', hint: 'Ex: Yaourt nature expire bientôt', onChanged: notifier.updateTitle, initialValue: state.title),
        const SizedBox(height: PsoldSpacing.md),
        _FormField(label: 'Description (optionnel)', hint: 'Description supplémentaire...', onChanged: notifier.updateDescription, initialValue: state.description, maxLines: 3),
        const SizedBox(height: PsoldSpacing.md),
        Text('Catégorie *', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: PsoldSpacing.sm),
        Wrap(
          spacing: PsoldSpacing.sm,
          children: [
            _CategoryChip(label: 'Alimentaire', selected: state.category == 'alimentaire', onTap: () => notifier.updateCategory('alimentaire')),
            _CategoryChip(label: 'Cosmétique', selected: state.category == 'cosmetique', onTap: () => notifier.updateCategory('cosmetique')),
            _CategoryChip(label: 'Électronique', selected: state.category == 'electronique', onTap: () => notifier.updateCategory('electronique')),
            _CategoryChip(label: 'Autre', selected: state.category == 'autre', onTap: () => notifier.updateCategory('autre')),
          ],
        ),
        const SizedBox(height: PsoldSpacing.md),
        Row(
          children: [
            Expanded(child: _FormField(label: 'Prix original (FCFA)', hint: 'Ex: 2000', onChanged: (v) => notifier.updatePriceOriginal(double.tryParse(v)), keyboardType: TextInputType.number)),
            const SizedBox(width: PsoldSpacing.md),
            Expanded(child: _FormField(label: 'Prix promo * (FCFA)', hint: 'Ex: 1000', onChanged: (v) => notifier.updatePricePromo(double.tryParse(v)), keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: PsoldSpacing.md),
        _FormField(
          label: 'Date de péremption *',
          hint: 'Sélectionner une date',
          readOnly: true,
          trailing: Icons.calendar_today,
          onTap: () async {
            final date = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 7)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (date != null) notifier.updateExpiryDate(date);
          },
          controller: state.expiryDate != null ? TextEditingController(text: '${state.expiryDate!.day}/${state.expiryDate!.month}/${state.expiryDate!.year}') : null,
        ),
        const SizedBox(height: PsoldSpacing.md),
        _FormField(label: 'Quantité *', hint: 'Ex: 5', onChanged: (v) => notifier.updateQuantity(int.tryParse(v) ?? 1), keyboardType: TextInputType.number, initialValue: state.quantity.toString()),
        const SizedBox(height: PsoldSpacing.md),
        _FormField(label: 'Ville (optionnel)', hint: 'Ex: Bangui', onChanged: notifier.updateCity, initialValue: state.city),
        const SizedBox(height: PsoldSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _handleSubmit(context, ref, state, notifier),
            style: ElevatedButton.styleFrom(
              backgroundColor: PsoldColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                : const Text('Valider et publier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: PsoldSpacing.xl),
      ],
    );
  }

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref, UploadState state, UploadNotifier notifier) async {
    if (state.title == null || state.pricePromo == null || state.expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires'), backgroundColor: Colors.red));
      return;
    }

    if (state.images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez ajouter au moins une image'), backgroundColor: Colors.red));
      return;
    }

    notifier.setUploading();

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      notifier.setError('Utilisateur non connecté');
      return;
    }

    final repository = UploadRepository();

    final imageUrls = <String>[];
    for (final image in state.images) {
      final url = await repository.uploadImage(image, userId);
      if (url != null) imageUrls.add(url);
    }

    if (imageUrls.isEmpty) {
      notifier.setError('Erreur lors de l\'upload des images');
      return;
    }

    final validationResult = await repository.validateWithAI(
      title: state.title!,
      category: state.category,
      expiryDate: state.expiryDate!,
      imageUrls: imageUrls,
    );

    if (validationResult == null) {
      notifier.setError('Erreur de validation IA');
      return;
    }

    final isValid = validationResult['validated'] == true;
    final aiScore = (validationResult['ai_score'] as num?)?.toDouble();

    await repository.insertProduct(
      merchantId: userId,
      title: state.title!,
      description: state.description,
      category: state.category,
      priceOriginal: state.priceOriginal,
      pricePromo: state.pricePromo!,
      expiryDate: state.expiryDate!,
      quantity: state.quantity,
      images: imageUrls,
      city: state.city,
      validated: isValid,
      aiScore: aiScore,
    );

    if (isValid) {
      notifier.setUploaded();
    } else {
      notifier.setRejected(validationResult['rejection_reason'] as String? ?? 'Produit non validé');
    }
  }
}

class _ImagePickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _ImagePickerButton({required this.icon, required this.label, required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(PsoldSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: PsoldColors.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
          color: PsoldColors.primary.withValues(alpha: 0.05),
        ),
        child: Column(
          children: [
            isLoading ? const CircularProgressIndicator(strokeWidth: 2) : Icon(icon, color: PsoldColors.primary, size: 32),
            const SizedBox(height: PsoldSpacing.xs),
            Text(label, style: const TextStyle(color: PsoldColors.primary, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool readOnly;
  final IconData? trailing;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? initialValue;

  const _FormField({
    required this.label,
    required this.hint,
    this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
    this.readOnly = false,
    this.trailing,
    this.onTap,
    this.controller,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: PsoldSpacing.xs),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: PsoldColors.primary)),
            suffixIcon: trailing != null ? Icon(trailing) : null,
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: PsoldSpacing.md, vertical: PsoldSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? PsoldColors.primary : Colors.transparent,
          border: Border.all(color: selected ? PsoldColors.primary : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}