import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/repo/help_center/help_center_repo.dart';

class HelpCenterController extends GetxController {
  HelpCenterRepo helpCenterRepo;
  HelpCenterController({required this.helpCenterRepo});

  bool logoutLoading = false;
  bool isLoading = false;
  bool noInternet = false;

  List<String> status = [MyStrings.selectOne, "avvv", "asdsad"];
}
