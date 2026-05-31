import 'package:ovowpp/data/services/shared_pref_service.dart';

class HelpCenterRepo {
  Future<void> clearSharedPrefData() async {
    await SharedPreferenceService.setString(SharedPreferenceService.userNameKey, '');
    await SharedPreferenceService.setString(SharedPreferenceService.userEmailKey, '');
    await SharedPreferenceService.setAccessTokenType('');
    await SharedPreferenceService.setAccessToken('');
    await SharedPreferenceService.setBool(SharedPreferenceService.rememberMeKey, false);
    return Future.value();
  }
}
