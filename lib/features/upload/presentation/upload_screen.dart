import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/core/router.dart';
import 'package:psold/features/upload/domain/upload_provider.dart';
import 'package:psold/flutter_gen/gen_l10n/app_localizations.dart';
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
          SnackBar(content: Text(AppLocalizations.of(context)!.uploadSuccess), backgroundColor: Colors.green),
        );
      } else if (next.status == UploadStatus.rejected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.uploadFailed(next.rejectionReason ?? '')), backgroundColor: Colors.red),
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
        title: Text(AppLocalizations.of(context)!.uploadTitle),
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

  Widget _buildImagePicker(BuildContext context, UploadState state, Upload notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.uploadPhotos, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: PsoldSpacing.sm),
        Row(
          children: [
            Expanded(child: _ImagePickerButton(icon: Icons.camera_alt_rounded, label: AppLocalizations.of(context)!.uploadCamera, onTap: notifier.pickSingleImage, isLoading: state.status == UploadStatus.picking)),
            const SizedBox(width: PsoldSpacing.sm),
            Expanded(child: _ImagePickerButton(icon: Icons.photo_library_rounded, label: AppLocalizations.of(context)!.uploadGallery, onTap: notifier.pickImages, isLoading: state.status == UploadStatus.picking)),
          ],
        ),
        const SizedBox(height: PsoldSpacing.md),
        Text(AppLocalizations.of(context)!.uploadVideo, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: PsoldSpacing.sm),
        if (state.videoFile != null)
          _buildVideoPreview(context, state, notifier)
        else
          _VideoPickerButton(onTap: notifier.pickVideo),
      ],
    );
  }

  Widget _buildVideoPreview(BuildContext context, UploadState state, Upload notifier) {
    return Container(
      padding: const EdgeInsets.all(PsoldSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(PsoldSpacing.sm),
            decoration: BoxDecoration(
              color: PsoldColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.videocam_rounded, color: PsoldColors.primary, size: 28),
          ),
          const SizedBox(width: PsoldSpacing.md),
          Expanded(
            child: Text(
              state.videoFile!.path.split('/').last,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: notifier.removeVideo,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(UploadState state, Upload notifier) {
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
                  child: Image.file(File(state.images[index].path), width: 100, height: 100, cacheWidth: 100, cacheHeight: 100, fit: BoxFit.cover),
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

  Widget _buildProductForm(BuildContext context, UploadState state, Upload notifier, WidgetRef ref, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormField(label: AppLocalizations.of(context)!.uploadProductTitle, hint: AppLocalizations.of(context)!.uploadTitleHint, onChanged: notifier.updateTitle, initialValue: state.title),
        const SizedBox(height: PsoldSpacing.md),
        _FormField(label: AppLocalizations.of(context)!.uploadDescription, hint: AppLocalizations.of(context)!.uploadDescriptionHint, onChanged: notifier.updateDescription, initialValue: state.description, maxLines: 3),
        const SizedBox(height: PsoldSpacing.md),
        Text(AppLocalizations.of(context)!.uploadCategory, style: Theme.of(context).textTheme.titleSmall),
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
            Expanded(child: _FormField(label: AppLocalizations.of(context)!.uploadOriginalPrice, hint: 'Ex: 2000', onChanged: (v) => notifier.updatePriceOriginal(double.tryParse(v)), keyboardType: TextInputType.number)),
            const SizedBox(width: PsoldSpacing.md),
            Expanded(child: _FormField(label: AppLocalizations.of(context)!.uploadPromoPrice, hint: 'Ex: 1000', onChanged: (v) => notifier.updatePricePromo(double.tryParse(v)), keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: PsoldSpacing.md),
        _FormField(
          label: AppLocalizations.of(context)!.uploadExpiryDate,
          hint: AppLocalizations.of(context)!.uploadSelectDate,
          readOnly: true,
          trailing: Icons.calendar_today,
          onTap: () async {
            final date = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 7)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (date != null) notifier.updateExpiryDate(date);
          },
          controller: state.expiryDate != null ? TextEditingController(text: '${state.expiryDate!.day}/${state.expiryDate!.month}/${state.expiryDate!.year}') : null,
        ),
        if (state.ocrFailed && state.expiryDate == null)
          Padding(
            padding: const EdgeInsets.only(top: PsoldSpacing.xs),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Colors.orange),
                const SizedBox(width: PsoldSpacing.xs),
                Text(
                  AppLocalizations.of(context)!.uploadOcrPrompt,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange),
                ),
              ],
            ),
          ),
        const SizedBox(height: PsoldSpacing.md),
        _FormField(label: AppLocalizations.of(context)!.uploadQuantity, hint: AppLocalizations.of(context)!.quantityHint, onChanged: (v) => notifier.updateQuantity(int.tryParse(v) ?? 1), keyboardType: TextInputType.number, initialValue: state.quantity.toString()),
        const SizedBox(height: PsoldSpacing.md),
        _FormField(label: AppLocalizations.of(context)!.uploadCity, hint: AppLocalizations.of(context)!.uploadCityHint, onChanged: notifier.updateCity, initialValue: state.city),
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
                : Text(AppLocalizations.of(context)!.uploadValidate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: PsoldSpacing.xl),
      ],
    );
  }

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref, UploadState state, Upload notifier) async {
    final l10n = AppLocalizations.of(context)!;
    if (state.title == null || state.pricePromo == null || state.expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.uploadRequired), backgroundColor: Colors.red));
      return;
    }

    if (state.images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.uploadAddImage), backgroundColor: Colors.red));
      return;
    }

    final profile = ref.read(currentUserProvider);
    if (profile == null) return;

    await ref.read(currentUserProvider.notifier).ensureUploadReset();

    final freshProfile = ref.read(currentUserProvider);
    if (freshProfile == null) return;

    if (!context.mounted) return;
    if (!freshProfile.canUploadImage) {
      context.push('/premium');
      return;
    }

    if (state.videoFile != null && !freshProfile.canUploadVideo) {
      context.push('/premium');
      return;
    }

    notifier.setUploading();

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      notifier.setError(l10n.uploadNotConnected);
      return;
    }

    final repository = UploadRepository();

    final imageUrls = <String>[];
    for (final image in state.images) {
      final url = await repository.uploadImage(image, userId);
      if (url != null) imageUrls.add(url);
    }

    if (imageUrls.isEmpty) {
      notifier.setError(l10n.uploadImageError);
      return;
    }

    String? videoUrl;
    if (state.videoFile != null) {
      videoUrl = await repository.uploadVideo(state.videoFile!, userId);
    }

    final validationResult = await repository.validateWithAI(
      title: state.title!,
      category: state.category,
      expiryDate: state.expiryDate!,
      imageUrls: imageUrls,
    );

    if (validationResult == null) {
      notifier.setError(l10n.uploadAIError);
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
      videoUrl: videoUrl,
      validated: isValid,
      aiScore: aiScore,
    );

    if (isValid) {
      notifier.setUploaded();
      final profileNotifier = ref.read(currentUserProvider.notifier);
      profileNotifier.incrementDailyImageCount();
      if (videoUrl != null) {
        profileNotifier.incrementDailyVideoCount();
      }
    } else {
      notifier.setRejected(validationResult['rejection_reason'] as String? ?? l10n.uploadNotValidated);
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

class _VideoPickerButton extends StatelessWidget {
  final VoidCallback onTap;

  const _VideoPickerButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(PsoldSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withValues(alpha: 0.03),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(PsoldSpacing.sm),
              decoration: BoxDecoration(
                color: PsoldColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.videocam_rounded, color: PsoldColors.primary, size: 24),
            ),
            const SizedBox(width: PsoldSpacing.md),
            Text(
              AppLocalizations.of(context)!.uploadAddVideo,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
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