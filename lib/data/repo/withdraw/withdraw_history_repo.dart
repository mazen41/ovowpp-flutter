import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class WithdrawHistoryRepo {
  Future<ResponseModel> getWithdrawHistoryData(int page, {String searchText = ""}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.withdrawHistoryUrl}?page=$page&search=$searchText";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }
}
