import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/notification/notification_response_model.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';

import '../../model/authorization/authorization_response_model.dart' as auth_model;
import '../../repo/notification_repo/notification_repo.dart';

class NotificationsController extends GetxController {
  NotificationRepo repo;
  bool isLoading = true;
  bool pushNotificationValue = false;
  bool emailNotificationValue = false;
  bool promotionalOffer = false;

  void changePushNotification() {
    pushNotificationValue = !pushNotificationValue;
    update();
  }

  void changeEmailNotification() {
    emailNotificationValue = !emailNotificationValue;
    update();
  }

  void changePromotionalOffer() {
    promotionalOffer = !promotionalOffer;
    update();
  }

  NotificationsController({required this.repo});

  String? nextPageUrl;
  String? imageUrl;

  List<Data> notificationList = [];

  int page = 0;

  void clearActiveNotificationInfo() {
    SharedPreferenceService.setBool(SharedPreferenceService.hasNewNotificationKey, false);
  }

  Future<void> initData() async {
    page = page + 1;
    if (page == 1) {
      notificationList.clear();
      isLoading = true;
      update();
    }

    ResponseModel response = await repo.loadAllNotification(page);
    if (response.statusCode == 200) {
      NotificationResponseModel model = NotificationResponseModel.fromJson(response.responseJson);

      nextPageUrl = model.data?.notifications?.nextPageUrl;
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        List<Data>? tempList = model.data?.notifications?.data;
        if (tempList != null && tempList.isNotEmpty) {
          notificationList.addAll(tempList);
        }
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    if (page == 1) {
      isLoading = false;
    }
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl!.toLowerCase() != 'null' ? true : false;
  }

  Future<bool> markAsReadAndGotoThePage(int index) async {
    int? id = notificationList[index].id;
    ResponseModel response = await repo.readNotification(id ?? 0);
    if (response.statusCode == 200) {
      auth_model.AuthorizationResponseModel model = auth_model.AuthorizationResponseModel.fromJson(
        response.responseJson,
      );
      if (model.status!.toLowerCase() == MyStrings.success.toLowerCase()) {
        //checkAndRedirect(remark, clickValue);
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    return true;
  }

  Future<void> checkAndRedirect(String remark, String? tradeId) async {}
}
