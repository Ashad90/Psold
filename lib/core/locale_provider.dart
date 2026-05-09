import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _localeBoxKey = 'settings';
const _localeKey = 'locale';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final box = Hive.box(_localeBoxKey);
  final saved = box.get(_localeKey, defaultValue: 'fr') as String;
  return LocaleNotifier(Locale(saved));
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(super.initialLocale);

  Future<void> setLocale(String languageCode) async {
    final box = Hive.box(_localeBoxKey);
    await box.put(_localeKey, languageCode);
    state = Locale(languageCode);
  }
}