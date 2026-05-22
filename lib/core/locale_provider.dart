import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'locale_provider.g.dart';

const _localeBoxKey = 'settings';
const _localeKey = 'locale';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    final box = Hive.box(_localeBoxKey);
    final saved = box.get(_localeKey, defaultValue: 'fr') as String;
    return Locale(saved);
  }

  Future<void> setLocale(String languageCode) async {
    final box = Hive.box(_localeBoxKey);
    await box.put(_localeKey, languageCode);
    state = Locale(languageCode);
  }
}
