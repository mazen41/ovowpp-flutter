import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class AddNewAgentRepo {
  Future<ResponseModel> addAgent(Map<String, dynamic> data) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.addAgentListEndPoint}';
    ResponseModel responseModel = await ApiService.postRequest(url, data);
    return responseModel;
  }
}
