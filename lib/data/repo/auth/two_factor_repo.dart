import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class TwoFactorRepo {
  Future<ResponseModel> verify(String code) async {
    final map = {'code': code};

    String url = '${UrlContainer.baseUrl}${UrlContainer.verify2FAUrl}';
    ResponseModel responseModel = await ApiService.postRequest(url, map);

    return responseModel;
  }

  Future<ResponseModel> enable2fa(String key, String code) async {
    final map = {'secret': key, 'code': code};

    String url = '${UrlContainer.baseUrl}${UrlContainer.twoFactorEnable}';
    ResponseModel responseModel = await ApiService.postRequest(url, map);

    return responseModel;
  }

  Future<ResponseModel> disable2fa(String code) async {
    final map = {'code': code};

    String url = '${UrlContainer.baseUrl}${UrlContainer.twoFactorDisable}';
    ResponseModel responseModel = await ApiService.postRequest(url, map);

    return responseModel;
  }

  Future<ResponseModel> get2FaData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.twoFactor}';
    ResponseModel responseModel = await ApiService.getRequest(url);

    return responseModel;
  }
}
