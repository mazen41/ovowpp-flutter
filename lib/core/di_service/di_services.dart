import 'package:get/get.dart';

import 'package:ovowpp/data/controller/splash/splash_controller.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/data/repo/splash/splash_repo.dart';

Future<void> initDependency() async {
  Get.lazyPut(() => SplashRepo());
  Get.lazyPut(() => SplashController(repo: Get.find()));
  Get.lazyPut(() => GeneralSettingRepo());
}
