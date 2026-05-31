import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/data/middleware/app_middleware.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class AuthMiddleware implements AppMiddleware {
  static bool isRedirecting = false;

  @override
  void handleResponse(response) {
    SharedPreferenceService.setRememberMe(false);
    SharedPreferenceService.setAccessToken("");
    if (Get.currentRoute != RouteHelper.loginScreen) {
      Get.offAllNamed(RouteHelper.loginScreen);
    }
  }
}
