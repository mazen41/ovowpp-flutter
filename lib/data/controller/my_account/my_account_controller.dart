import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/screens/contact/widgets/contact_item.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/controller/home/home_controller.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/model/customer_account/contact_response_model.dart';
import 'package:ovowpp/data/model/customer_account/customer_contact_save_response_model.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/all_contact/all_contact_repo.dart';
import 'package:ovowpp/data/repo/customer_account/customer_account_repo.dart';
import 'package:ovowpp/data/repo/home/home_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/environment.dart';
import '../all_contacts/all_contact_controller.dart';

class MyAccountController extends GetxController {
  CustomerAccountRepo myAccountRepo;
  MyAccountController({required this.myAccountRepo});

  bool logoutLoading = false;
  bool isLoading = false;
  bool noInternet = false;

  String imageUrl = '';

  File? imageFile;
  Contact? contact;
  List<AllContacts> tags = [];
  List<AllContacts> contactList = [];
  List<String> selectedTags = [];
  List<String> selectedContactList = [];
  Map<String, dynamic>? details;
  String? contryCode = "";
  int? editIndex;

  Countries? countryData;

  List<Map<String, TextEditingController>> customAttributeControllers = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  Future<void> loadProfileInfo({bool forceLoad = true}) async {
    if (forceLoad) {
      isLoading = true;
      update();
    }
    await loadData(contact);
    isLoading = false;
    update();
  }

  String image = "";
  String imagePath = "";
  String id = "";
  bool isUpdate = true;

  Future loadData(Contact? model) async {
    firstNameController.text = model?.firstname ?? '';
    lastNameController.text = model?.lastname ?? '';
    mobileNoController.text = model?.mobile ?? '';
    details = model?.details;
    id = model?.id.toString() ?? '';

    customAttributeControllers.clear();
    if (details != null && details!.isNotEmpty) {
      details!.forEach((key, value) {
        customAttributeControllers.add({
          'key': TextEditingController(text: key),
          'value': TextEditingController(text: value?.toString() ?? ''),
        });
      });
    } else {
      customAttributeControllers.add({'key': TextEditingController(), 'value': TextEditingController()});
    }

    if (model?.tags != null) {
      tags = List<AllContacts>.from(model?.tags ?? []);
      selectedTags
        ..clear()
        ..addAll(tags.map((e) => e.id.toString()));
    }

    if (model?.lists != null) {
      contactList = List<AllContacts>.from(model?.lists ?? []);
      selectedContactList
        ..clear()
        ..addAll(contactList.map((e) => e.id.toString()));
    }

    imageUrl = "${UrlContainer.domainUrl}/$imagePath/${model?.image}";

    if (isUpdate) {
      final allCountries = SharedPreferenceService.getCountryJsonDataData().data?.countries ?? [];

      final extractedCode = extractDialCode(model?.mobileCode ?? '', allCountries);

      contryCode = extractedCode.isNotEmpty ? extractedCode : Environment.defaultPhoneCode;

      countryData = allCountries.firstWhere(
        (v) => v.dialCode?.replaceAll("+", "") == contryCode,
        orElse: () => Countries(country: "Unknown", dialCode: contryCode),
      );

      countryController.text = countryData?.country ?? '';
    } else {
      selectACountry();
    }

    await allContactList();
    isLoading = false;

    selectACountry(countryDataValue: countryData);

    update();
  }

  String extractDialCode(String mobileCode, List<Countries> countries) {
    if (mobileCode.isEmpty) return '';

    final dialCode = mobileCode.replaceAll('+', '').trim();

    final match = countries.firstWhere(
      (c) => c.dialCode?.replaceAll('+', '') == dialCode,
      orElse: () => Countries(dialCode: ''),
    );

    return match.dialCode?.replaceAll('+', '') ?? '';
  }

  void selectACountry({Countries? countryDataValue}) {
    final allCountries = SharedPreferenceService.getCountryJsonDataData().data?.countries ?? [];

    if (countryDataValue != null) {
      countryData = countryDataValue;
    } else {
      countryData = allCountries.firstWhere(
        (v) => v.dialCode?.replaceAll("+", "") == contryCode,
        orElse: () => allCountries.isNotEmpty ? allCountries.first : Countries(country: "", dialCode: ""),
      );
    }

    countryController.text = countryData?.country ?? '';

    if (countryData?.dialCode == null || countryData!.dialCode!.isEmpty) {
      countryData = allCountries.isNotEmpty ? allCountries.first : Countries(country: "", dialCode: "");
    }

    contryCode = countryData?.dialCode ?? '';

    update();
  }

  List<AllContacts> contactTags = [];

  Future<void> allContactList() async {
    try {
      ResponseModel model = await myAccountRepo.getContactDataRepo();

      if (model.statusCode == 200) {
        CustomerContactResponseModel responseModel = CustomerContactResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          tags = responseModel.data?.contactTags ?? [];
          contactTags = responseModel.data?.contactLists ?? [];
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
  }

  bool saving = false;
  void saveContact(int index, bool isChtEdit) async {
    saving = true;
    update();

    try {
      Map<String, dynamic> messageModel = {
        "firstname": firstNameController.text.trim(),
        "lastname": lastNameController.text.trim(),
        "mobile_code": contryCode ?? "",
        "mobile": mobileNoController.text.trim(),
      };
      for (int i = 0; i < customAttributeControllers.length; i++) {
        messageModel['custom_attributes[name][$i]'] = customAttributeControllers[i]['key']!.text.trim();
        messageModel['custom_attributes[value][$i]'] = customAttributeControllers[i]['value']!.text.trim();
      }
      for (int i = 0; i < selectedContactList.length; i++) {
        messageModel['lists[$i]'] = selectedContactList[i];
      }
      for (int i = 0; i < selectedTags.length; i++) {
        messageModel['tags[$i]'] = selectedTags[i];
      }
      if (imageFile != null) {
        messageModel['profile_image'] = imageFile;
      }
      printE(messageModel);

      ResponseModel model = await myAccountRepo.saveContactRepo(messageModel, isUpdate ? id : "");
      if (model.statusCode == 200) {
        CustomerContactSaveResponseModel responseModel = CustomerContactSaveResponseModel.fromJson(model.responseJson);
        if (responseModel.status.toLowerCase() == AppStatus.success) {
          Get.put(AllContactRepo());
          Get.put(HomeRepo());
          final contactController = Get.put(AllContactController(repo: Get.find()));
          final chatController = Get.put(HomeController(homeRepo: Get.find()));

          if (isContactFromChat) {
            if (index >= 0 && index < contactController.newAllContactsData.length) {
              contactController.newAllContactsData[index].firstname = firstNameController.text;
              contactController.newAllContactsData[index].lastname = lastNameController.text;
              contactController.newAllContactsData[index].mobile = mobileNoController.text;
            }
          } else {
            if (index >= 0 && index < chatController.newChatData.length) {
              chatController.newChatData[chatController.currentChatIndex].contact?.firstname = firstNameController.text;
              chatController.newChatData[chatController.currentChatIndex].contact?.lastname = lastNameController.text;
              chatController.newChatData[chatController.currentChatIndex].contact?.mobile = mobileNoController.text;
            }
          }

          chatController.update();
          contactController.update();

          Get.back();
          CustomSnackBar.success(successList: responseModel.message);
        } else {
          CustomSnackBar.error(errorList: responseModel.message);
        }
        saving = false;
        update();
      } else {
        saving = false;
        update();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      saving = false;
      update();
    }
  }
}
