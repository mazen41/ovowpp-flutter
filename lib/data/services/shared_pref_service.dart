import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/model/general_setting/general_setting_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String onboardKey = 'onboardKey';

  // Define keys as constants
  static const String accessTokenKey = 'access_token';
  static const String accessTokenType = 'access_type';
  static const String resetPassTokenKey = 'reset_pass_token';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String mobile = 'mobile';
  static const String userPhoneNumberKey = 'user_phone_number';
  static const String rememberMeKey = 'remember me';
  static const String generalSettingKey = 'general-setting-key';
  static const String moduleSettingKey = 'module-setting-key';
  static const String fcmDeviceKey = 'device-key';
  static const String needTwoFactorVerification = 'need-tfa';
  static const String userIdKey = 'user_id';
  static const String theme = 'theme';
  static const String hasNewNotificationKey = 'new-notification-key';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String address = 'address';
  static const String country = 'country';
  static const String languageImagePath = 'language_image_path';
  static const String languageCode = 'language_code';
  static const String languageKey = 'language-key';
  static const String languageListKey = 'language-list-key';
  static const String countryJsonData = 'country_json_data';
  static const String profileImage = 'profile_image';
  static const String profileImagePath = 'profile_image_path';
  static const String fullProfileImage = 'full_profile_image';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String languageNameKey = 'language_name_key';
  static const String isAgent = 'is_agent';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Returns true if the persistent storage contains the given [key].
  static bool containsKey(String key, {bool defaultValue = false}) {
    return _prefs?.containsKey(key) ?? defaultValue;
  }

  /// Save a string value to SharedPreferences
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get a string value from SharedPreferences
  static String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  /// Save a boolean value to SharedPreferences
  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Get a boolean value from SharedPreferences
  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  /// Save an integer value to SharedPreferences
  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// Get an integer value from SharedPreferences
  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  /// Remove a key from SharedPreferences
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Store a JSON object (e.g., General Setting) to SharedPreferences
  static Future<void> setJsonObject(String key, Map<String, dynamic> jsonObject) async {
    String jsonString = jsonEncode(jsonObject);
    await _prefs?.setString(key, jsonString);
  }

  /// Retrieve a JSON object from SharedPreferences
  static Map<String, dynamic> getJsonObject(String key) {
    String? jsonString = _prefs?.getString(key);
    return jsonString != null ? jsonDecode(jsonString) : {};
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) => setBool(theme, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      getBool(theme, defaultValue: true); // todo set the default theme (true for light, false for dark)

  /// save current locale
  static Future<void> setCurrentLanguage(String value) => setString(languageCode, value);

  /// get current locale
  // static Locale getCurrentLocal() {
  //   String? langCode = _sharedPreferences.getString(_currentLocalKey);
  //   // default language is english
  //   if (langCode == null) {
  //     return LocalizationService.defaultLanguage;
  //   }
  //   return LocalizationService.supportedLanguages[langCode]!;
  // }

  /// Example methods to store and retrieve specific data using predefined keys
  static Future<void> setAccessToken(String token) async {
    if (token.isEmpty) {
      await _secureStorage.delete(key: accessTokenKey);
    } else {
      await _secureStorage.write(key: accessTokenKey, value: token);
    }
    await setString(accessTokenKey, token);
  }

  static String getAccessToken() {
    return getString(accessTokenKey);
  }

  static Future<String?> getAccessTokenSecure() async {
    return _secureStorage.read(key: accessTokenKey);
  }

  static Future<void> clearAccessTokenSecure() async {
    await _secureStorage.delete(key: accessTokenKey);
  }

  static Future<void> setAccessTokenType(String tokenType) async {
    await setString(accessTokenType, tokenType);
  }

  static String getAccessTokenType() {
    return getString(accessTokenType);
  }

  static Future<void> setUserEmail(String email) async {
    await setString(userEmailKey, email);
  }

  static String getUserEmail() {
    return getString(userEmailKey);
  }

  static Future<void> setUserName(String name) async {
    await setString(userNameKey, name);
  }

  static String getUserName() {
    return getString(userNameKey);
  }

  static Future<void> setOnBoardStatus(bool value) async {
    await setBool(onboardKey, value);
  }

  static Future<void> setRememberMe(bool rememberMe) async {
    await setBool(rememberMeKey, rememberMe);
  }

  static bool getRememberMe() {
    return getBool(rememberMeKey);
  }

  static Future<void> setGeneralSettingData(GeneralSettingResponseModel model) async {
    await setJsonObject(generalSettingKey, model.toJson());
  }

  static GeneralSettingResponseModel getGeneralSettingData() {
    try {
      var getGsData = getJsonObject(generalSettingKey);
      return GeneralSettingResponseModel.fromJson(getGsData);
    } catch (e) {
      return GeneralSettingResponseModel();
    }
  }

  static String getCurrencySymbol() {
    return getGeneralSettingData().data?.generalSetting?.curSym ?? "";
  }

  static String getCurrencyText() {
    return getGeneralSettingData().data?.generalSetting?.curText ?? "";
  }

  static Future<void> setCountryJsonDataData(CountryModel model) async {
    await setJsonObject(countryJsonData, model.toJson());
  }

  static CountryModel getCountryJsonDataData() {
    var getData = getJsonObject(countryJsonData);
    return CountryModel.fromJson(getData);
  }

  static SocialiteCredentials getSocialCredentialsConfig() {
    try {
      return getGeneralSettingData().data?.generalSetting?.socialiteCredentials ?? SocialiteCredentials();
    } catch (e) {
      return SocialiteCredentials();
    }
  }

  // You can add similar methods for other keys as needed.
}
