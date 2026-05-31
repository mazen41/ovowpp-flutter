import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/profile_complete/profile_complete_response_model.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/repo/account/profile_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

import '../../../environment.dart';
import '../../model/country_model/country_model.dart';
import '../../model/profile_complete/profile_complete_post_model.dart';
import '../../model/user/user.dart';

class ProfileCompleteController extends GetxController {
  ProfileRepo profileRepo;
  ProfileCompleteController({required this.profileRepo});

  TextEditingController countryController = TextEditingController(); // for filtering country in bottom sheet
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  FocusNode usernameFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();

  bool countryLoading = true;
  Countries countryData = Countries(
    countryCode: Environment.defaultCountryCode,
    country: Environment.defaultCountry,
    dialCode: Environment.defaultPhoneCode,
  );
  // String? countryName;
  // String? countryCode;
  // String? mobileCode;
  bool isLoading = false;
  bool submitLoading = false;
  Future<void> profileCompleteSubmit() async {
    String username = usernameController.text.toString().trim();
    String mobileNumber = mobileNoController.text.toString().trim();
    String address = addressController.text.toString();
    String city = cityController.text.toString().trim();
    String zip = zipCodeController.text.toString().trim();
    String state = stateController.text.toString().trim();

    submitLoading = true;
    update();

    List<String> errorMessages = [];

    // Validate the input as either a username or an email
    if (username.trim().isEmpty) {
      errorMessages.add('Username is required.');
    } else if (username.length < 6) {
      errorMessages.add('Username (at least 6 characters).');
    }
    if (mobileNumber.isEmpty) {
      errorMessages.add('Mobile is required.');
    }

    // If there are error messages, display them and stop the process
    if (errorMessages.isNotEmpty) {
      submitLoading = false;
      update();
      CustomSnackBar.error(errorList: errorMessages);
      return;
    }

    ProfileCompletePostModel model = ProfileCompletePostModel(
      username: username,
      countryName: countryData.country ?? Environment.defaultCountry,
      countryCode: countryData.countryCode ?? Environment.defaultCountryCode,
      mobileNumber: mobileNumber,
      mobileCode: countryData.dialCode ?? Environment.defaultPhoneCode,
      address: address,
      state: state,
      zip: zip,
      city: city,
      image: null,
    );

    ResponseModel responseModel = await profileRepo.completeProfile(model);
    print("this is model ${model.toMap()}");
    if (responseModel.statusCode == 200) {
      ProfileCompleteResponseModel model = ProfileCompleteResponseModel.fromJson(responseModel.responseJson);
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        countryController.clear();
        usernameController.clear();
        mobileNoController.clear();
        addressController.clear();
        stateController.clear();
        zipCodeController.clear();
        cityController.clear();
        checkAndGotoNextStep(model.data?.user);
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  void checkAndGotoNextStep(User? user) async {
    bool needEmailVerification = user?.ev == "1" ? false : true;
    bool needSmsVerification = user?.sv == '1' ? false : true;
    bool isTwoFactorEnable = user?.tv == '1' ? false : true;

    await SharedPreferenceService.setString(SharedPreferenceService.userIdKey, user?.id.toString() ?? '-1');
    await SharedPreferenceService.setString(SharedPreferenceService.userEmailKey, user?.email ?? '');
    await SharedPreferenceService.setString(SharedPreferenceService.userPhoneNumberKey, user?.mobile ?? '');
    await SharedPreferenceService.setString(SharedPreferenceService.userNameKey, user?.username ?? '');

    if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen);
    } else if (isTwoFactorEnable) {
      Get.offAndToNamed(RouteHelper.twoFactorScreen);
    } else {
      // await profileRepo.updateDeviceToken();
      Get.offAndToNamed(RouteHelper.bottomNavScreen);
    }
  }

  void selectACountry({required Countries countryDataValue}) {
    countryData = countryDataValue;
    update();
  }
}
