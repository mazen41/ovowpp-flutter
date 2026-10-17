import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/core/translations/localization_controller.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/language/language_model.dart';
import 'package:ovowpp/data/model/language/main_language_response_model.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';
import '../../../core/utils/util_exporter.dart';
import '../menu/my_menu_controller.dart';

class MyLanguageController extends GetxController {
  GeneralSettingRepo repo;
  MyLanguageController({required this.repo});
  LocalizationController localizationController = LocalizationController();
  bool isLoading = true;
  String languageImagePath = "";
  List<MyLanguageModel> langList = [];

  void loadLanguage() {
    langList.clear();
    isLoading = true;

    String languageString = SharedPreferenceService.getString(SharedPreferenceService.languageListKey);

    try {
      var language = jsonDecode(languageString);
      MainLanguageResponseModel model = MainLanguageResponseModel.fromJson(language);
      languageImagePath = "${UrlContainer.domainUrl}/${model.data?.imagePath ?? ''}";
      if (model.data?.languages != null && model.data!.languages!.isNotEmpty) {
        for (var listItem in model.data!.languages!) {
          MyLanguageModel item = MyLanguageModel(
            languageCode: listItem.code ?? '',
            countryCode: listItem.name ?? '',
            languageName: listItem.name ?? '',
            imageUrl: listItem.image ?? '',
          );
          langList.add(item);
        }
      }
    } catch (e) {
      // Stored list missing or unreadable (e.g. fresh install with no internet)
      printX('language list not usable: $e');
      langList.clear();
    }

    // Built-in fallback: used when the backend list is empty, unreadable, or has no Arabic
    for (final local in LocalizationController.myLanguages) {
      final bool exists = langList.any((l) => l.languageCode.toLowerCase() == local.languageCode.toLowerCase());
      if (!exists && (langList.isEmpty || local.languageCode == 'ar')) {
        langList.add(local);
      }
    }

    String languageCode = SharedPreferenceService.getString(SharedPreferenceService.languageCode, defaultValue: localizationController.locale.languageCode);

    if (kDebugMode) {
      printX('current lang code: $languageCode');
    }

    if (langList.isNotEmpty) {
      int index = langList.indexWhere((element) => element.languageCode.toLowerCase() == languageCode.toLowerCase());
      // Saved language not in the list: select Arabic, never leave the index at -1
      if (index < 0) index = langList.indexWhere((element) => element.languageCode.toLowerCase() == 'ar');
      if (index < 0) index = 0;

      changeSelectedIndex(index);
    }

    isLoading = false;
    update();
  }

  String selectedLangCode = 'en';

  bool isChangeLangLoading = false;
  void changeLanguage(int index) async {
    isChangeLangLoading = true;
    update();

    MyLanguageModel selectedLangModel = langList[index];
    String languageCode = selectedLangModel.languageCode;
    printX("======== LANGUAGE CODE : ${selectedLangModel.languageCode}");
    // Built-in languages (en, ar) use the app's static translations, so they can be applied without the backend
    final bool isBuiltIn = LocalizationController.myLanguages.any((l) => l.languageCode == languageCode);
    bool canApply = isBuiltIn;
    try {
      ResponseModel response = await repo.getLanguage(languageCode);

      if (response.statusCode == 200) {
        canApply = true;
        await SharedPreferenceService.setString(
          SharedPreferenceService.languageListKey,
          jsonEncode(response.responseJson),
        );
      } else if (!isBuiltIn) {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printX(e.toString());
    }

    if (canApply) {
      await SharedPreferenceService.setString(
        SharedPreferenceService.languageNameKey,
        selectedLangModel.languageName,
      );
      await SharedPreferenceService.setString(SharedPreferenceService.countryCode, selectedLangModel.countryCode);
      await SharedPreferenceService.setString(SharedPreferenceService.languageCode, selectedLangModel.languageCode);

      Locale local = Locale(selectedLangModel.languageCode, selectedLangModel.languageCode == 'ar' ? 'SA' : 'US');
      localizationController.setLanguage(local, "$languageImagePath/${selectedLangModel.imageUrl ?? ''}");

      // Don't load backend translations - use static translations instead
      // Backend translations are incomplete and overwrite static translations

      try {
        final MyMenuController menuController = Get.find<MyMenuController>();
        menuController.setSelectedLanguage(selectedLangModel.languageName);
      } catch (e) {
        printX(e.toString());
      }

      Get.back();
    }

    isChangeLangLoading = false;
    update();
  }

  int selectedIndex = 0;
  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }
}
