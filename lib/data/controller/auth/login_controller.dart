import 'package:flutter/cupertino.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/model/user/user.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/data/model/auth/login/login_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/auth/login_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class LoginController extends GetxController {
  LoginRepo loginRepo;
  LoginController({required this.loginRepo});

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  List<String> errors = [];
  bool remember = false;

  void forgetPassword() {
    Get.toNamed(RouteHelper.forgotPasswordScreen);
  }

  void checkAndGotoNextStep(LoginResponseModel responseModel) async {
    bool needEmailVerification = responseModel.data?.user?.ev == "1" ? false : true;
    bool needSmsVerification = responseModel.data?.user?.sv == '1' ? false : true;
    bool isTwoFactorEnable = responseModel.data?.user?.tv == '1' ? false : true;

    if (remember) {
      await SharedPreferenceService.setBool(SharedPreferenceService.rememberMeKey, true);
    } else {
      await SharedPreferenceService.setBool(SharedPreferenceService.rememberMeKey, false);
    }

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
      SharedPreferenceService.userPhoneNumberKey,
      responseModel.data?.user?.mobile ?? '',
    );
    await SharedPreferenceService.setString(
      SharedPreferenceService.userNameKey,
      responseModel.data?.user?.username ?? '',
    );

    await loginRepo.sendUserToken();
    bool isProfileCompleteEnable = responseModel.data?.user?.profileComplete == '0' ? true : false;

    if (isProfileCompleteEnable) {
      Get.offAndToNamed(RouteHelper.profileCompleteScreen);
    } else if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen);
    } else if (isTwoFactorEnable) {
      Get.offAndToNamed(RouteHelper.twoFactorScreen);
    } else {
      Get.offAndToNamed(RouteHelper.homeScreen);
    }
  }

  bool isSubmitLoading = false;
  void loginUser() async {
    try {
      isSubmitLoading = true;
      update();

      // Call the login API
      ResponseModel model = await loginRepo.loginUser(
        emailController.text.toString(),
        passwordController.text.toString(),
      );

      // Check if the response status code is 200 (success)
      if (model.statusCode == 200) {
        // Parse the response into the LoginResponseModel
        LoginResponseModel loginModel = LoginResponseModel.fromJson(model.responseJson);

        // Check if the login status is successful
        if (loginModel.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
          // Extract access token, token type, and user details
          String accessToken = loginModel.data?.accessToken ?? "";
          String tokenType = loginModel.data?.tokenType ?? "";
          User? user = loginModel.data?.user;

          // Handle the next steps based on user status
          await RouteHelper.checkUserStatusAndGoToNextStep(
            user,
            accessToken: accessToken,
            tokenType: tokenType,
            isRemember: remember,
          );
        } else {
          // Show an error if login failed
          CustomSnackBar.error(errorList: loginModel.message ?? [MyStrings.loginFailedTryAgain]);
        }
      } else {
        // Show an error if the status code is not 200
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      // Handle any unexpected errors that might occur
      printE('Error during login: $e');

      // Show a generic error message
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
    } finally {
      // Reset the loading state
      isSubmitLoading = false;
      update();
    }
  }

  Future<void> changeRememberMe() async {
    remember = !remember;
    await SharedPreferenceService.setRememberMe(remember);
    update();
  }

  void clearTextField() {
    passwordController.text = '';
    emailController.text = '';

    if (remember) {
      remember = false;
    }
    update();
  }
}
