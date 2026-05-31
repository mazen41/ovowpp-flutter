import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class CustomerDetailsRepo {
  Future<ResponseModel> getCustomerDetailsRepo(String id) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.customerDetailsUrl}$id";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> changeStatusRepo(String webId, String status) async {
    final map = {'status': status};
    String url = '${UrlContainer.baseUrl}${UrlContainer.customerDetailsStatusUrl}$webId';
    final response = await ApiService.postRequest(url, map);
    return response;
  }

  Future<ResponseModel> addNotesRepo(String id, String note) async {
    final map = {'conversation_id': id, 'note': note};
    String url = '${UrlContainer.baseUrl}${UrlContainer.customerDetailsNoteUrl}';
    final response = await ApiService.postRequest(url, map);
    return response;
  }

  Future<ResponseModel> deleteNoteRepo(String id) async {
    final Map<String, dynamic> map = {};
    String url = '${UrlContainer.baseUrl}${UrlContainer.deleteNoteUrl}$id';
    final response = await ApiService.postRequest(url, map);
    return response;
  }
}
