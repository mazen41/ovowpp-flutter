import 'package:flutter/material.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/model/auth/sign_up_model/registration_response_model.dart';
import 'package:ovowpp/data/model/auth/sign_up_model/sign_up_model.dart';
import 'package:ovowpp/data/model/general_setting/general_setting_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/model/error_model.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/data/repo/auth/signup_repo.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class RegistrationController extends GetxController {
  RegistrationRepo registrationRepo;
  GeneralSettingRepo generalSettingRepo;

  RegistrationController({required this.registrationRepo, required this.generalSettingRepo});

  bool isLoading = true;
  bool agreeTC = false;

  GeneralSettingResponseModel generalSettingMainModel = GeneralSettingResponseModel();

  bool checkPasswordStrength = false;
  bool needAgree = true;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode countryNameFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode companyNameFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();

  String? email;
  String? password;
  String? confirmPassword;
  String? countryName;
  String? countryCode;
  String? mobileCode;
  String? userName;
  String? phoneNo;
  String? firstName;
  String? lastName;

  RegExp regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  bool submitLoading = false;

  Future<void> signUpUser() async {
    if (needAgree && !agreeTC) {
      CustomSnackBar.error(errorList: [MyStrings.agreePolicyMessage]);
      return;
    }

    submitLoading = true;
    update();

    SignUpModel model = getUserData();
    ResponseModel responseModel = await registrationRepo.registerUser(model);

    if (responseModel.statusCode == 200) {
      RegistrationResponseModel model = RegistrationResponseModel.fromJson(responseModel.responseJson);
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        CustomSnackBar.success(successList: model.message ?? [MyStrings.success.tr]);
        emailController.clear();
        passwordController.clear();
        cPasswordController.clear();
        fNameController.clear();
        lNameController.clear();
        checkAndGotoNextStep(model);
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong.tr]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  void setCountryNameAndCode(String cName, String countryCode, String mobileCode) {
    countryName = cName;
    this.countryCode = countryCode;
    this.mobileCode = mobileCode;
    update();
  }

  void updateAgreeTC() {
    agreeTC = !agreeTC;
    update();
  }

  SignUpModel getUserData() {
    SignUpModel model = SignUpModel(
      firstName: fNameController.text.toString(),
      lastName: lNameController.text.toString(),
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
      agree: agreeTC ? true : false,
    );

    return model;
  }

  void checkAndGotoNextStep(RegistrationResponseModel responseModel) async {
    await SharedPreferenceService.setString(
      SharedPreferenceService.userIdKey,
      responseModel.data?.user?.id.toString() ?? '-1',
    );
    await SharedPreferenceService.setAccessToken(responseModel.data?.accessToken ?? '');
    await SharedPreferenceService.setAccessTokenType(responseModel.data?.tokenType ?? '');
    await SharedPreferenceService.setString(
      SharedPreferenceService.userEmailKey,
      responseModel.data?.user?.email ?? '',
    );
    await SharedPreferenceService.setString(
      SharedPreferenceService.userNameKey,
      responseModel.data?.user?.username ?? '',
    );
    await SharedPreferenceService.setString(
      SharedPreferenceService.userPhoneNumberKey,
      responseModel.data?.user?.mobile ?? '',
    );

    Get.toNamed(RouteHelper.profileCompleteScreen);
  }

  void closeAllController() {
    isLoading = false;
    emailController.text = '';
    passwordController.text = '';
    cPasswordController.text = '';
    fNameController.text = '';
    lNameController.text = '';
  }

  void clearAllData() {
    closeAllController();
  }

  List<ErrorModel> passwordValidationRules = [
    ErrorModel(text: MyStrings.hasUpperLetter.tr, hasError: true),
    ErrorModel(text: MyStrings.hasLowerLetter.tr, hasError: true),
    ErrorModel(text: MyStrings.hasDigit.tr, hasError: true),
    ErrorModel(text: MyStrings.hasSpecialChar.tr, hasError: true),
    ErrorModel(text: MyStrings.minSixChar.tr, hasError: true),
  ];

  bool isCountryLoading = true;
  void initData() async {
    isLoading = true;
    update();

    ResponseModel response = await generalSettingRepo.getGeneralSetting();
    if (response.statusCode == 200) {
      GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(response.responseJson);
      if (model.status?.toLowerCase() == 'success') {
        generalSettingMainModel = model;
        SharedPreferenceService.setGeneralSettingData(model);
      } else {
        List<String> message = [MyStrings.somethingWentWrong.tr];
        CustomSnackBar.error(errorList: model.message ?? message);
        return;
      }
    } else {
      if (response.statusCode == 503) {
        noInternet = true;
        update();
      }
      CustomSnackBar.error(errorList: [response.message]);
      return;
    }

    needAgree = generalSettingMainModel.data?.generalSetting?.agree.toString() == '0' ? false : true;
    checkPasswordStrength = generalSettingMainModel.data?.generalSetting?.securePassword.toString() == '0'
        ? false
        : true;

    isLoading = false;
    update();
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return MyStrings.enterYourPassword_.tr;
    } else {
      if (checkPasswordStrength) {
        if (!regex.hasMatch(value)) {
          return MyStrings.invalidPassMsg.tr;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  bool noInternet = false;
  void changeInternet(bool hasInternet) {
    noInternet = false;
    initData();
    update();
  }

  void updateValidationList(String value) {
    passwordValidationRules[0].hasError = value.contains(RegExp(r'[A-Z]')) ? false : true;
    passwordValidationRules[1].hasError = value.contains(RegExp(r'[a-z]')) ? false : true;
    passwordValidationRules[2].hasError = value.contains(RegExp(r'[0-9]')) ? false : true;
    passwordValidationRules[3].hasError = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ? false : true;
    passwordValidationRules[4].hasError = value.length >= 6 ? false : true;

    update();
  }

  bool hasPasswordFocus = false;
  void changePasswordFocus(bool hasFocus) {
    hasPasswordFocus = hasFocus;
    update();
  }
}
