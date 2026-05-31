import 'package:ovowpp/data/model/global/response_model/response_model.dart';

import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class ManageAgentRepo {
  Future<dynamic> loadAgentData(String pram) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.agentListEndPoint}$pram';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> loadConversationRepo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.createConversationDataEndPoint}$id';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> deleteAgent(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.deleteAgentEndPoint}/$id';
    final response = await ApiService.postRequest(url, {});
    return response;
  }
}
