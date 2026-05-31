import 'package:ovowpp/data/model/global/response_model/response_model.dart';

import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class AddNewContactRepo {
  Future<dynamic> loadAllUnlistedContact(int page, String search) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.viewContactUnlistedDataEndPoint}$search';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> addNewContactRepo(List<String> contactIds, String id) async {
    final map = {'contacts': contactIds};

    String url = '${UrlContainer.baseUrl}${UrlContainer.addNewGroupContactUrl}/$id';
    final response = await ApiService.postRequest(url, map);
    return response;
  }
}
