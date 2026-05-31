import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class MenuRepo {
  Future<ResponseModel> logout() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.logoutUrl}';
    ResponseModel responseModel = await ApiService.getRequest(url);

    await clearSharedPrefData();

    return responseModel;
  }

  Future<ResponseModel> removeAccount() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.accountDisable}';
    ResponseModel responseModel = await ApiService.postRequest(url, {});
    return responseModel;
  }

  Future<void> clearSharedPrefData() async {
    await SharedPreferenceService.setString(SharedPreferenceService.userNameKey, '');
    await SharedPreferenceService.setString(SharedPreferenceService.userEmailKey, '');
    await SharedPreferenceService.setAccessTokenType('');
    await SharedPreferenceService.setAccessToken('');
    await SharedPreferenceService.setBool(SharedPreferenceService.rememberMeKey, false);
    return Future.value();
  }
}
