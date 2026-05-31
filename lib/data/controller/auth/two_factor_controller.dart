import 'dart:convert';
import 'package:ovowpp/data/controller/account/profile_controller.dart';
import 'package:ovowpp/data/model/auth/two_factor/two_factor_data_model.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/auth/two_factor_repo.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class TwoFactorController extends GetxController {
  TwoFactorRepo repo;
  TwoFactorController({required this.repo});

  bool submitLoading = false;
  String currentText = '';

  void verify2FACode(String currentText) async {
    if (currentText.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.verify(currentText);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);

      if (model.status == MyStrings.success) {
        Get.offAndToNamed(RouteHelper.bottomNavScreen);
        CustomSnackBar.success(successList: model.message ?? [MyStrings.requestSuccess]);
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  void enable2fa(String key, String code) async {
    if (code.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.enable2fa(key, code);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);
      if (model.status.toString() == MyStrings.success.toString().toLowerCase()) {
        CustomSnackBar.success(successList: model.message ?? [MyStrings.requestSuccess]);
        await Get.find<ProfileController>().loadProfileInfo();
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    submitLoading = false;
    update();
  }

  void disable2fa(String code) async {
    if (code.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await repo.disable2fa(code);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);

      if (model.status.toString() == MyStrings.success.toString().toLowerCase()) {
        CustomSnackBar.success(successList: model.message ?? [MyStrings.requestSuccess]);
        await Get.find<ProfileController>().loadProfileInfo();
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    submitLoading = false;
    update();
  }

  bool isLoading = false;
  TwoFactorCodeModel twoFactorCodeModel = TwoFactorCodeModel();

  void get2FaCode() async {
    isLoading = true;
    update();

    ResponseModel responseModel = await repo.get2FaData();

    if (responseModel.statusCode == 200) {
      TwoFactorCodeModel model = twoFactorCodeModelFromJson(jsonEncode(responseModel.responseJson));

      if (model.status.toString() == MyStrings.success.toString().toLowerCase()) {
        twoFactorCodeModel = model;
        isLoading = false;
        update();
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }
}
