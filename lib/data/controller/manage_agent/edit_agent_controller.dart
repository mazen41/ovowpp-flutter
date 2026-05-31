import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/model/customer_account/customer_contact_save_response_model.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/manage_agent/agent_list_response_model.dart';
import 'package:ovowpp/data/repo/manage_agent/edit_agent_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

import '../../../core/utils/util.dart';

class EditAgentController extends GetxController {
  EditAgentRepo myAccountRepo;
  EditAgentController({required this.myAccountRepo});

  bool logoutLoading = false;
  bool isLoading = false;
  bool noInternet = false;

  String imageUrl = '';

  File? imageFile;
  List<AllContacts> tags = [];
  List<AllContacts> contactList = [];
  List<String> selectedTags = [];
  List<String> selectedContactList = [];
  Map<String, dynamic>? details;
  String? contryCode = "";

  Countries? countryData;

  List<Map<String, TextEditingController>> customAttributeControllers = [];

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

  Future<void> loadAgentInfo({bool forceLoad = true, AgentData? agentData}) async {
    if (forceLoad) {
      isLoading = true;
      update();
    }
    loadData(agentData);
    isLoading = false;
    update();
  }

  String image = "";
  String imagePath = "";
  String id = "";
  bool isUpdate = true;

  void loadData(AgentData? agent) async {
    agentId = agent?.id.toString() ?? "-1";

    firstNameController.text = agent?.firstname ?? '';
    lastNameController.text = agent?.lastname ?? '';
    mobileNoController.text = agent?.mobile ?? '';
    userNameController.text = agent?.username ?? '';
    emailController.text = agent?.email ?? '';
    cityController.text = agent?.city ?? '';
    stateController.text = agent?.state ?? '';
    zipCodeController.text = agent?.zip ?? '';
    addressController.text = agent?.address ?? '';
    imageUrl = "${UrlContainer.domainUrl}/$imagePath/${agent?.image}";
    isLoading = false;

    final allCountries = SharedPreferenceService.getCountryJsonDataData().data?.countries ?? [];
    final extractedCode = extractDialCode(agent?.dialCode ?? '', allCountries);
    contryCode = extractedCode;
    // selectACountry();
    countryData = Countries(
      countryCode: agent?.countryCode ?? "",
      country: agent?.countryName ?? "",
      dialCode: agent?.dialCode ?? "",
    );
    update();
  }

  List<AllContacts> contactTags = [];

  bool isUpdateAgentLoading = false;
  void updateAgent() async {
    isUpdateAgentLoading = true;
    update();
    try {
      Map<String, dynamic> pram = {
        "firstname": firstNameController.text.trim(),
        "lastname": lastNameController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "zip": zipCodeController.text.trim(),
        "address": addressController.text.trim(),
      };

      ResponseModel model = await myAccountRepo.updateAgent(pram, agentId ?? "-1");
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

  String extractDialCode(String mobile, List<Countries> countries) {
    for (final country in countries) {
      final dial = country.dialCode?.replaceAll('+', '') ?? '';
      if (dial.isNotEmpty && mobile.startsWith(dial)) {
        return dial;
      }
    }
    return "";
  }

  void selectACountry({Countries? countryDataValue}) {
    countryData = countryDataValue;

    if (countryData != null) {
      countryController.text = countryData!.country!;
    } else {
      final allCountries = SharedPreferenceService.getCountryJsonDataData().data?.countries ?? [];

      countryData = allCountries.firstWhere(
        (v) => v.dialCode?.replaceAll("+", "") == contryCode,
        orElse: () => Countries(country: "", dialCode: ""),
      );

      countryController.text = countryData?.country ?? "";
    }
    update();
  }
}
