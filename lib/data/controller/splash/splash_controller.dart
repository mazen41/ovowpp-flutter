import 'dart:convert';
import 'package:ovowpp/core/translations/localization_controller.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/services/push_notification_service.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/messages.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/data/model/general_setting/general_setting_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class SplashController extends GetxController {
  GeneralSettingRepo repo;

  SplashController({required this.repo});
  LocalizationController localizationController = LocalizationController();
  bool isLoading = true;
  Future<void> gotoNextPage() async {
    bool isRemember = SharedPreferenceService.getBool(SharedPreferenceService.rememberMeKey);
    noInternet = false;
    bool isOnBoard = SharedPreferenceService.getBool(SharedPreferenceService.onboardKey, defaultValue: true);
    update();
    if (isRemember) {
      PushNotificationService().sendUserToken();
    }
    await loadLanguage();
    await storeLangDataInLocalStorage();
    loadCountryDataAndSaveToLocalStorage();
    await loadAndSaveGeneralSettingsData(isRemember, isOnBoard);
  }

  bool noInternet = false;
  Future<void> loadAndSaveGeneralSettingsData(bool isRemember, isOnBoard) async {
    ResponseModel response = await repo.getGeneralSetting();

    if (response.statusCode == 200) {
      GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(response.responseJson);
      if (model.status?.toLowerCase() == 'success') {
        await SharedPreferenceService.setGeneralSettingData(model);
      } else {
        List<String> message = [Strings.somethingWentWrong];
        CustomSnackBar.error(errorList: model.message ?? message);
      }
    } else {
      if (response.statusCode == 503) {
        noInternet = true;
        update();
      }
      // CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();

    if (isOnBoard) {
      Future.delayed(const Duration(seconds: 1)).then((_) {
        Get.offAndToNamed(RouteHelper.onboardScreen);
      });
    } else {
      if (isRemember) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAndToNamed(RouteHelper.bottomNavScreen);
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAndToNamed(RouteHelper.loginScreen);
        });
      }
    }
  }

  Future<void> storeLangDataInLocalStorage() async {
    String lan = SharedPreferenceService.getString(SharedPreferenceService.languageNameKey);
    if (lan.isEmpty) {
      await SharedPreferenceService.setString(
        SharedPreferenceService.languageNameKey,
        LocalizationController.myLanguages[0].languageName.toString(),
      );
    }
    if (!SharedPreferenceService.containsKey(SharedPreferenceService.countryCode)) {
      SharedPreferenceService.setString(
        SharedPreferenceService.countryCode,
        LocalizationController.myLanguages[0].countryCode,
      );
    }
    if (!SharedPreferenceService.containsKey(SharedPreferenceService.languageCode)) {
      SharedPreferenceService.setString(
        SharedPreferenceService.languageCode,
        LocalizationController.myLanguages[0].languageCode,
      );
    }
    Future.value(true);
  }

  Future<void> loadLanguage() async {
    localizationController.loadCurrentLanguage();
    String languageCode = localizationController.locale.languageCode;
    printX("===========  LANGUAGE CODE : $languageCode");

    ResponseModel response = await repo.getLanguage(languageCode);
    if (response.statusCode == 200) {
      try {
        saveLanguageList(jsonEncode(response.responseJson));
      } catch (e) {
        printX(e.toString());
      }
    }
    // Don't load backend translations - use static translations from Messages class
    // Backend translations are incomplete and overwrite static translations
  }

  Future<void> loadCountryDataAndSaveToLocalStorage() async {
    try {
      ResponseModel response = await repo.getCountryList();
      if (response.statusCode == 200) {
        CountryModel countryModel = CountryModel.fromJson(response.responseJson);

        await SharedPreferenceService.setCountryJsonDataData(countryModel);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [e.toString()]);
    }
  }

  void saveLanguageList(String languageJson) async {
    await SharedPreferenceService.setString(SharedPreferenceService.languageListKey, languageJson);
    return;
  }
}
