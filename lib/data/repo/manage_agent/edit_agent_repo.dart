import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class EditAgentRepo {
  Future<ResponseModel> getTagsDataRepo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.tagsDataEndPoint}/';
    ResponseModel responseModel = await ApiService.getRequest(url);

    return responseModel;
  }

  Future<ResponseModel> updateAgent(Map<String, dynamic> data, String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.updateAgentListEndPoint}/$id';
    ResponseModel responseModel = await ApiService.postRequest(url, data);
    return responseModel;
  }
}
