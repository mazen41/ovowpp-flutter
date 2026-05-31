import 'dart:convert';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/repo/menu_repo/menu_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import '../../model/authorization/authorization_response_model.dart';

class MyMenuController extends GetxController {
  MenuRepo menuRepo;
  MyMenuController({required this.menuRepo});

  bool logoutLoading = false;
  bool isLoading = false;
  bool noInternet = false;

  bool balTransferEnable = true;
  bool langSwitchEnable = true;

  String image = "";
  String imagePath = "";
  String mobile = "";
  String username = "";
  String? fullProfileUrl;
  String? firstName;
  String? lastName;
  String? country;
  String? address;
  String? selectedLanguage;
  bool isAgent = false;

  void setSelectedLanguage(String lang) {
    selectedLanguage = lang;
    update();
  }

  void loadData() async {
    isLoading = true;
    update();
    username = SharedPreferenceService.getString(SharedPreferenceService.userNameKey);
    image = SharedPreferenceService.getString(SharedPreferenceService.profileImage);

    fullProfileUrl = SharedPreferenceService.getString(SharedPreferenceService.fullProfileImage);
    mobile = "+${SharedPreferenceService.getString(SharedPreferenceService.mobile)}";
    firstName = SharedPreferenceService.getString(SharedPreferenceService.firstName);
    lastName = SharedPreferenceService.getString(SharedPreferenceService.lastName);
    country = SharedPreferenceService.getString(SharedPreferenceService.countryCode);
    country = SharedPreferenceService.getString(SharedPreferenceService.address);
    selectedLanguage = SharedPreferenceService.getString(SharedPreferenceService.languageNameKey);
    isAgent = SharedPreferenceService.getBool(SharedPreferenceService.isAgent);
    isLoading = false;
    update();
  }

  bool removeLoading = false;
  Future<void> removeAccount() async {
    removeLoading = true;
    update();

    final responseModal = await menuRepo.removeAccount();
    if (responseModal.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(jsonDecode(responseModal.responseJson));
      if (model.status?.toLowerCase() == MyStrings.success) {
        await menuRepo.clearSharedPrefData();
        Get.offAllNamed(RouteHelper.loginScreen);
        CustomSnackBar.success(successList: model.message ?? [MyStrings.accountDeletedSuccessfully]);
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModal.message]);
    }

    removeLoading = false;
    update();
  }

  Future<void> logout() async {
    logoutLoading = true;
    update();

    await menuRepo.logout();
    CustomSnackBar.success(successList: [MyStrings.logoutSuccessMsg]);

    logoutLoading = false;
    update();
    Get.offAllNamed(RouteHelper.loginScreen);
  }

  bool isTransferEnable = true;
  bool isWithdrawEnable = true;
  bool isInvoiceEnable = true;
}
