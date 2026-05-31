import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

import '../translations/localization_controller.dart';

// todo configure text family and size
class MyFonts {
  static String currentAppLanguageCode = SharedPreferenceService.getString(
    SharedPreferenceService.languageCode,
    defaultValue: 'en',
  );

  // return the right font depending on app language
  static TextStyle get getAppFontType =>
      LocalizationController.supportedLanguagesFontsFamilies.containsKey(currentAppLanguageCode)
      ? LocalizationController.supportedLanguagesFontsFamilies[currentAppLanguageCode]!
      : const TextStyle(); // Returns empty TextStyle if the language is not found

  // ========== TEXT STYLES SECTION ==========

  // headlines text font
  static TextStyle get displayTextStyle => getAppFontType;

  // body text font
  static TextStyle get bodyTextStyle => getAppFontType;

  // button text font
  static TextStyle get buttonTextStyle => getAppFontType;

  // app bar text font
  static TextStyle get appBarTextStyle => getAppFontType;

  // chips text font
  static TextStyle get chipTextStyle => getAppFontType;

  // ========== FONT SIZES SECTION ==========

  // appbar font size
  static double get appBarTittleSize => 22.sp;

  // body font size
  static double get bodySmallTextSize => 11.sp;
  static double get bodyMediumSize => 13.sp; // default font
  static double get bodyLargeSize => 16.sp;
  static double get bodyLargeSize2 => 17.sp;

  // display font size
  static double get displayLargeSize => 57.sp;
  static double get displayMediumSize => 45.sp;
  static double get displaySmallSize => 36.sp;

  // button font size
  static double get buttonTextSize => 16.sp;

  // chip font size
  static double get chipTextSize => 10.sp;

  // ========== HEADLINE TEXT SIZES SECTION ==========

  static double get headlineLargeSize => 24.sp;
  static double get headlineMediumSize => 20.sp;
  static double get headlineSmallSize => 17.sp;

  // ========== TITLE TEXT SIZES SECTION ==========

  static double get titleLargeSize => 22.sp;
  static double get titleMediumSize => 18.sp;
  static double get titleSmallSize => 14.sp;

  // ========== LABEL TEXT SIZES SECTION ==========

  static double get labelLargeSize => 16.sp;
  static double get labelMediumSize => 14.sp;
  static double get labelSmallSize => 12.sp;

  // ========== GENERAL BODY TEXT SIZE SECTION ==========

  static double get bodyTextSize => 14.sp;

  // list tile fonts sizes
  static double get listTileTitleSize => 13.sp;
  static double get listTileSubtitleSize => 12.sp;

  // custom themes (extensions)
}
