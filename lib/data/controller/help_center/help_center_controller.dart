import 'package:get/get.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/data/repo/help_center/help_center_repo.dart';

class HelpCenterController extends GetxController {
  HelpCenterRepo helpCenterRepo;
  HelpCenterController({required this.helpCenterRepo});

  bool logoutLoading = false;
  bool isLoading = false;
  bool noInternet = false;

  List<String> status = [Strings.selectOne, "avvv", "asdsad"];
}
