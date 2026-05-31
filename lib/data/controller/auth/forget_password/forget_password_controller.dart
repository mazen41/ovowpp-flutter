import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/repo/auth/login_repo.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class ForgetPasswordController extends GetxController {
  LoginRepo loginRepo;
  ForgetPasswordController({required this.loginRepo});

  bool submitLoading = false;
  TextEditingController emailOrUsernameController = TextEditingController();

  void submitForgetPassCode() async {
    printX(" =============  FORGET PASSWORD METHOD {TO NAME}===");
    String input = emailOrUsernameController.text;

    if (input.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterYourEmail]);
      return;
    }

    submitLoading = true;
    update();

    String type = input.contains('@') ? 'email' : 'username';
    String responseEmail = await loginRepo.forgetPassword(type, input);

    if (responseEmail.isNotEmpty) {
      emailOrUsernameController.text = '';
      Get.offAndToNamed(RouteHelper.verifyPassCodeScreen, arguments: responseEmail);
    }

    submitLoading = false;
    update();
  }
}
