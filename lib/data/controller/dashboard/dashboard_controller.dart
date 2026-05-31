import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/dashboard/dashboard_response_model.dart';
import 'package:ovowpp/data/model/general_setting/general_setting_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/data/repo/dashboard/dashboard_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import '../../model/user/user.dart';

class DashboardController extends GetxController {
  DashboardRepo repo;
  bool isLoading = true;

  DashboardController({required this.repo});

  List<String> permissionList = [];
  User? user;
  DashboardExtraData? dashboardData;

  String isKycVerified = '1';
  bool checkAgent = false;

  Future<void> refreshGeneralSettings() async {
    try {
      ResponseModel response = await repo.getGeneralSetting();
      if (response.statusCode == 200) {
        final model = GeneralSettingResponseModel.fromJson(response.responseJson);
        if (model.status?.toLowerCase() == 'success') {
          await SharedPreferenceService.setGeneralSettingData(model);
        }
      }
    } catch (e) {
      printE(e.toString());
    }
  }

  Future<void> loadData() async {
    printX("============ LOAD DATA");
    try {
      if (dashboardData == null) {
        isLoading = true;
        update();
      }
      ResponseModel response = await repo.loadDashboardData();

      if (response.statusCode == 200) {
        DashboardResponseModel responseModel = DashboardResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          permissionList = responseModel.data?.widget?.permissions ?? [];
          // printX("=== permission List ${permissionList}");
          user = responseModel.data?.user;
          dashboardData = responseModel.data?.widget;

          isKycVerified = responseModel.data?.user?.kv.toString() ?? '';
          String? firstName = user?.firstname;
          String? lastName = user?.lastname;
          String? image = user?.image;
          String? country = user?.countryName;
          String address = user?.address ?? "";
          bool isAgent = (user?.isAgent?.toString() ?? '0') == '1';
          checkAgent = isAgent;

          await SharedPreferenceService.setString(SharedPreferenceService.firstName, firstName ?? '');
          await SharedPreferenceService.setString(SharedPreferenceService.lastName, lastName ?? '');
          await SharedPreferenceService.setString(
            "${user?.firstname}${user?.lastname}",
            SharedPreferenceService.userNameKey,
          );
          await SharedPreferenceService.setString(
            "${responseModel.data?.profilePath}",
            SharedPreferenceService.profileImagePath,
          );
          await SharedPreferenceService.setString(SharedPreferenceService.country, country ?? '');
          await SharedPreferenceService.setString(SharedPreferenceService.address, address);
          await SharedPreferenceService.setBool(SharedPreferenceService.isAgent, isAgent);

          SharedPreferenceService.setString(SharedPreferenceService.profileImage, image ?? '');
          final profileFullImage = "${UrlContainer.domainUrl}/${responseModel.data?.profilePath}/${user?.image}";
          await SharedPreferenceService.setString(
            SharedPreferenceService.fullProfileImage, // KEY
            profileFullImage, // VALUE
          );
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      printX("======= plan name : ${dashboardData?.subscription?.plan?.name}");
      isLoading = false;
      update();
    }

    update();
  }
}
