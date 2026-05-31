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

    var language = jsonDecode(languageString);
    MainLanguageResponseModel model = MainLanguageResponseModel.fromJson(language);
    languageImagePath = "${UrlContainer.domainUrl}/${model.data?.imagePath ?? ''}";
    if (model.data?.languages != null && model.data!.languages!.isNotEmpty) {
      for (var listItem in model.data!.languages!) {
        MyLanguageModel model = MyLanguageModel(
          languageCode: listItem.code ?? '',
          countryCode: listItem.name ?? '',
          languageName: listItem.name ?? '',
          imageUrl: listItem.image ?? '',
        );
        langList.add(model);
      }
    }

    String languageCode = SharedPreferenceService.getString(SharedPreferenceService.languageCode, defaultValue: 'en');

    if (kDebugMode) {
      printX('current lang code: $languageCode');
    }

    if (langList.isNotEmpty) {
      int index = langList.indexWhere((element) => element.languageCode.toLowerCase() == languageCode.toLowerCase());

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
    try {
      ResponseModel response = await repo.getLanguage(languageCode);

      if (response.statusCode == 200) {
        await SharedPreferenceService.setString(
          SharedPreferenceService.languageListKey,
          jsonEncode(response.responseJson),
        );
        await SharedPreferenceService.setString(
          SharedPreferenceService.languageNameKey,
          selectedLangModel.languageName,
        );
        await SharedPreferenceService.setString(SharedPreferenceService.countryCode, selectedLangModel.countryCode);
        await SharedPreferenceService.setString(SharedPreferenceService.languageCode, selectedLangModel.languageCode);

        Locale local = Locale(selectedLangModel.languageCode, 'US');
        localizationController.setLanguage(local, "$languageImagePath/${langList[index].imageUrl}");
        var resJson = (response.responseJson);
        Map<String, dynamic> value = resJson['data']['file'].toString() == '[]' ? {} : resJson['data']['file'];
        Map<String, String> json = {};
        value.forEach((key, value) {
          json[key] = value.toString();
        });

        Map<String, Map<String, String>> language = {};
        language['${selectedLangModel.languageCode}_${'US'}'] = json;

        Get.clearTranslations();
        Get.addTranslations(Messages(languages: language).keys);

        final MyMenuController menuController = Get.find<MyMenuController>();
        menuController.setSelectedLanguage(selectedLangModel.languageName);

        Get.back();
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printX(e.toString());
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
