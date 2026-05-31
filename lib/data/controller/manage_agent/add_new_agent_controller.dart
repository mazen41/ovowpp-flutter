import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/model/customer_account/customer_contact_save_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/manage_agent/add_new_agent_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import '../../../core/utils/util.dart';

class AddNewAgentController extends GetxController {
  AddNewAgentRepo repo;
  AddNewAgentController({required this.repo});

  bool isLoading = false;

  String imageUrl = '';

  File? imageFile;

  String? contryCode = "";
  Countries? countryData;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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

  String? agentId;

  Future<void> loadAgentInfo() async {
    selectACountry();
    update();
  }

  String image = "";
  String imagePath = "";
  String id = "";
  bool isUpdate = true;

  bool isUpdateAgentLoading = false;
  void addAgent() async {
    isUpdateAgentLoading = true;
    update();
    try {
      Map<String, dynamic> pram = {
        "firstname": firstNameController.text.trim(),
        "lastname": lastNameController.text.trim(),
        "username": userNameController.text.trim(),
        "email": emailController.text.trim(),
        "country_code": countryData?.countryCode ?? "",
        "country": countryData?.country ?? "",
        "mobile_code": countryData?.dialCode ?? "",
        "mobile": mobileNoController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "zip": zipCodeController.text.trim(),
        "address": addressController.text.trim(),
      };

      ResponseModel model = await repo.addAgent(pram);
      if (model.statusCode == 200) {
        CustomerContactSaveResponseModel responseModel = CustomerContactSaveResponseModel.fromJson(model.responseJson);
        if (responseModel.status.toLowerCase() == AppStatus.success) {
          Get.back();

          CustomSnackBar.success(successList: responseModel.message);
        } else {
          CustomSnackBar.error(errorList: responseModel.message);
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      printX("error : ${e.toString()}");
    }
    isUpdateAgentLoading = false;
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
}
