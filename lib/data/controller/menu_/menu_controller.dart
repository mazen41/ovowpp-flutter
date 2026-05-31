import 'package:ovowpp/core/translations/localization_controller.dart';

import 'package:ovowpp/data/repo/menu_repo/menu_repo.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  MenuRepo repo;
  MenuController({required this.repo});
  LocalizationController localizationController = LocalizationController();
  bool isLoading = true;
}
