import 'package:ovowpp/data/model/global/response_model/response_model.dart';

import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class ViewContactRepo {
  Future<dynamic> loadAllConatact(int page, String id, String search) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.viewContactListDataEndPoint}$id?page=$page&search=$search';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> loadAllUnlistedConatact(int page, String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.viewContactListDataEndPoint}$id?page=$page';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> loadConversationRepo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.createConversationDataEndPoint}$id';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> deleteContactRepo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.deleteContacListtUrl}$id';
    final response = await ApiService.postRequest(url, {});
    return response;
  }

  Future<ResponseModel> manageContactRepo(String id, String name) async {
    final map = {'name': name};

    String url =
        '${UrlContainer.baseUrl}${id != "" ? UrlContainer.updateContactUrl : UrlContainer.createContactUrl}$id';
    final response = await ApiService.postRequest(url, map);
    return response;
  }
}
