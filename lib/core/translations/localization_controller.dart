import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/data/model/language/language_model.dart';

class LocalizationController {
  static final LocalizationController _instance = LocalizationController._internal();

  factory LocalizationController() => _instance;

  LocalizationController._internal() {
    loadCurrentLanguage();
  }

  static Map<String, TextStyle> supportedLanguagesFontsFamilies = {
    'en': const TextStyle(fontFamily: 'Nunito'),
    'ar': const TextStyle(fontFamily: 'Cairo'),
  };

  // IMPORTANT: countryCode must match keys in Messages: en_US and ar_SA
  static List<MyLanguageModel> myLanguages = [
    MyLanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
    MyLanguageModel(languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];

  Locale _locale = const Locale('en', 'US');
  bool _isLtr = true;
  final List<MyLanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<MyLanguageModel> get languages => _languages;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setLanguage(Locale locale, String? imageUrl) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = _locale.languageCode != 'ar';
    saveLanguage(_locale, imageUrl);
  }

  void loadCurrentLanguage() {
    String languageCode = SharedPreferenceService.getString(
      SharedPreferenceService.languageCode,
      defaultValue: 'en',
    );

    // Always derive countryCode from languageCode to guarantee it matches Messages keys
    String countryCode = languageCode == 'ar' ? 'SA' : 'US';

    _locale = Locale(languageCode, countryCode);
    _isLtr = languageCode != 'ar';
  }

  void saveLanguage(Locale locale, String? imageUrl) {
    SharedPreferenceService.setString(SharedPreferenceService.languageCode, locale.languageCode);
    SharedPreferenceService.setString(SharedPreferenceService.countryCode, locale.countryCode ?? '');
    SharedPreferenceService.setString(SharedPreferenceService.languageImagePath, imageUrl ?? '');
  }

  void setSelectIndex(int index) {
    _selectedIndex = index;
  }
}
