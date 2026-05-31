import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/data/middleware/app_middleware.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';

class ProfileStatusMiddleware implements AppMiddleware {
  static bool isRedirecting = false;

  @override
  void handleResponse(response) {
    var responseData = response as dio.Response;

    if (responseData.data['remark'] == 'profile_incomplete') {
      Get.offNamed(RouteHelper.profileCompleteScreen);
    } else if (responseData.data['remark'] == "unverified") {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(response.data);
      RouteHelper.checkUserStatusAndGoToNextStep(model.data?.user);
    }
  }
}
