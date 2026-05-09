import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

enum UploadStatus {
  initial, picking, picked, validating, validated, rejected, uploading, uploaded, error
}

class UploadState {
  final UploadStatus status;
  final List<File> images;
  final String? title;
  final String? description;
  final String category;
  final double? priceOriginal;
  final double? pricePromo;
  final DateTime? expiryDate;
  final int quantity;
  final String? city;
  final String? rejectionReason;
  final String? errorMessage;
  final DateTime? extractedExpiry;
  final double ocrConfidence;

  const UploadState({
    this.status = UploadStatus.initial,
    this.images = const [],
    this.title,
    this.description,
    this.category = 'alimentaire',
    this.priceOriginal,
    this.pricePromo,
    this.expiryDate,
    this.quantity = 1,
    this.city,
    this.rejectionReason,
    this.errorMessage,
    this.extractedExpiry,
    this.ocrConfidence = 0,
  });

  UploadState copyWith({
    UploadStatus? status,
    List<File>? images,
    String? title,
    String? description,
    String? category,
    double? priceOriginal,
    double? pricePromo,
    DateTime? expiryDate,
    int? quantity,
    String? city,
    String? rejectionReason,
    String? errorMessage,
    DateTime? extractedExpiry,
    double? ocrConfidence,
  }) {
    return UploadState(
      status: status ?? this.status,
      images: images ?? this.images,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priceOriginal: priceOriginal ?? this.priceOriginal,
      pricePromo: pricePromo ?? this.pricePromo,
      expiryDate: expiryDate ?? this.expiryDate,
      quantity: quantity ?? this.quantity,
      city: city ?? this.city,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      errorMessage: errorMessage ?? this.errorMessage,
      extractedExpiry: extractedExpiry ?? this.extractedExpiry,
      ocrConfidence: ocrConfidence ?? this.ocrConfidence,
    );
  }
}

class UploadNotifier extends StateNotifier<UploadState> {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  final List<RegExp> _datePatterns = [
    RegExp(r'(?:EXP|DLC|BBE|BEST\s*BEFORE)[:\s]*(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{2,4})', caseSensitive: false),
    RegExp(r'(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{2,4})'),
    RegExp(r'(\d{4})[/\-.](\d{1,2})[/\-.](\d{1,2})'),
  ];

  UploadNotifier() : super(const UploadState());

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> pickImages() async {
    state = state.copyWith(status: UploadStatus.picking);
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(imageQuality: 80, maxWidth: 1200);
      final files = pickedFiles.map((f) => File(f.path)).toList();
      state = state.copyWith(status: UploadStatus.picked, images: files);
      if (files.isNotEmpty) await _runOCR(files.first);
    } catch (e) {
      state = state.copyWith(status: UploadStatus.error, errorMessage: 'Erreur lors de la sélection des images');
    }
  }

  Future<void> pickSingleImage() async {
    state = state.copyWith(status: UploadStatus.picking);
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80, maxWidth: 1200);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final files = [...state.images, file];
        state = state.copyWith(status: UploadStatus.picked, images: files);
        await _runOCR(file);
      } else {
        state = state.copyWith(status: UploadStatus.initial);
      }
    } catch (e) {
      state = state.copyWith(status: UploadStatus.error, errorMessage: 'Erreur lors de la capture');
    }
  }

  Future<void> _runOCR(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final text = recognizedText.text;
      final confidence = recognizedText.blocks.isNotEmpty
          ? 0.85
          : 0.0;

      for (final pattern in _datePatterns) {
        final match = pattern.firstMatch(text);
        if (match != null) {
          final date = _parseDateMatch(match);
          if (date != null) {
            state = state.copyWith(extractedExpiry: date, ocrConfidence: confidence);
            return;
          }
        }
      }
    } catch (_) {}
  }

  DateTime? _parseDateMatch(RegExpMatch match) {
    try {
      if (match.groupCount >= 3) {
        final g1 = int.parse(match.group(1)!);
        final g2 = int.parse(match.group(2)!);
        final g3Str = match.group(3)!;
        final g3 = int.parse(g3Str);
        int year, month, day;
        if (g1 > 31) {
          year = g1; month = g2; day = g3;
        } else if (g3Str.length == 4) {
          year = g3; month = g1; day = g2;
        } else {
          year = g3 > 50 ? 1900 + g3 : 2000 + g3;
          month = g1; day = g2;
        }
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return null;
  }

  void useExtractedDate() {
    if (state.extractedExpiry != null) {
      state = state.copyWith(expiryDate: state.extractedExpiry);
    }
  }

  void removeImage(int index) {
    final images = [...state.images];
    images.removeAt(index);
    state = state.copyWith(images: images);
  }

  void updateTitle(String title) => state = state.copyWith(title: title);
  void updateDescription(String description) => state = state.copyWith(description: description);
  void updateCategory(String category) => state = state.copyWith(category: category);
  void updatePriceOriginal(double? price) => state = state.copyWith(priceOriginal: price);
  void updatePricePromo(double? price) => state = state.copyWith(pricePromo: price);
  void updateExpiryDate(DateTime? date) => state = state.copyWith(expiryDate: date);
  void updateQuantity(int qty) => state = state.copyWith(quantity: qty);
  void updateCity(String? city) => state = state.copyWith(city: city);

  void setRejected(String reason) => state = state.copyWith(status: UploadStatus.rejected, rejectionReason: reason);
  void setError(String message) => state = state.copyWith(status: UploadStatus.error, errorMessage: message);
  void setUploading() => state = state.copyWith(status: UploadStatus.uploading);
  void setUploaded() => state = state.copyWith(status: UploadStatus.uploaded);
  void reset() => state = const UploadState();
}

final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier();
});
