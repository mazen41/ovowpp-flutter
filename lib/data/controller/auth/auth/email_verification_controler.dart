import 'dart:async';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/auth/sms_email_verification_repo.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class EmailVerificationController extends GetxController {
  SmsEmailVerificationRepo repo;

  EmailVerificationController({required this.repo});

  String currentText = "";
  bool needTwoFactor = false;
  bool submitLoading = false;
  bool isLoading = true;
  bool resendLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    update();
    ResponseModel responseModel = await repo.sendAuthorizationRequest();

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);
      if (model.status == 'error') {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  Future<void> verifyEmail(String text) async {
    if (text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.verify(text);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);

      bool isSMSVerificationEnable = model.data?.user?.sv == "0" ? true : false;
      bool is2FAEnable = model.data?.user?.tv == "0" ? true : false;

      if (model.status == MyStrings.success) {
        CustomSnackBar.success(successList: model.message ?? [(MyStrings.emailVerificationSuccess)]);
        if (isSMSVerificationEnable) {
          Get.offAndToNamed(RouteHelper.smsVerificationScreen);
        } else if (is2FAEnable) {
          Get.offAndToNamed(RouteHelper.twoFactorScreen);
        } else {
          Get.offAndToNamed(RouteHelper.bottomNavScreen);
        }
      } else {
        CustomSnackBar.error(errorList: model.message ?? [(MyStrings.emailVerificationFailed)]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  Future<void> sendCodeAgain() async {
    resendLoading = true;
    update();

    await repo.resendVerifyCode(isEmail: true);

    resendLoading = false;
    update();
  }
}
