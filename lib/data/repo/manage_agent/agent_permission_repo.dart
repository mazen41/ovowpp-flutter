import 'package:ovowpp/data/model/global/response_model/response_model.dart';

import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class AgentPermissionRepo {
  Future<dynamic> loadAgentData(int page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.agentListEndPoint}?page=$page';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> getPermissionData(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.agentPermissionEndPoint}/$id';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> deleteContactRepo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.deleteMessageUrl}$id';
    final response = await ApiService.postRequest(url, {});
    return response;
  }

  Future<dynamic> updatePermission(String id, Map<String, dynamic> map) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.updatePermissionEndPoint}/$id';
    ResponseModel response = await ApiService.postMultiPartRequest(url, map, {});
    return response;
  }
}
