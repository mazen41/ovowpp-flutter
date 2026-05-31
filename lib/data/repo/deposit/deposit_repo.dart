import '../../../core/utils/url_container.dart';
import '../../model/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class DepositRepo {
  Future<ResponseModel> getDepositHistory({required int page, String searchText = ""}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.depositHistoryUrl}?page=$page&search=$searchText";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<dynamic> getDepositMethods() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.depositMethodUrl}';
    ResponseModel response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> insertDeposit({
    required String amount,
    required String methodCode,
    required String currency,
    Map<String, String>? extraData,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.depositInsertUrl}";
    Map<String, String> map = {'amount': amount, 'method_code': methodCode, 'currency': currency, ...?extraData};

    ResponseModel responseModel = await ApiService.postRequest(url, map);
    return responseModel;
  }

  Future<dynamic> getUserInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';
    ResponseModel response = await ApiService.getRequest(url);
    return response;
  }
}
