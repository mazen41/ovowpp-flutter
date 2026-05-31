import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class ContactTagListRepo {
  Future<dynamic> loadAllConatact(String pram) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.allContactTagListDataEndPoint}$pram';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> loadConversationRepo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.createConversationDataEndPoint}$id';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> deleteContactRepo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.deleteContactTagUrl}$id';
    final response = await ApiService.postRequest(url, {});
    return response;
  }

  Future<ResponseModel> manageContactRepo(String id, String name) async {
    final map = {'name': name};

    String url =
        '${UrlContainer.baseUrl}${id != "" ? UrlContainer.updateContactTagUrl : UrlContainer.createContactTagUrl}$id';
    final response = await ApiService.postRequest(url, map);
    return response;
  }
}
