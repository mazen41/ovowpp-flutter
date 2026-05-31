import 'package:ovowpp/data/model/global/response_model/response_model.dart';

import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class CampaignRepo {
  Future<dynamic> loadCampaign(int page, {int? status, searchQuery}) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.getCampaign}/?page=$page&status=${status ?? ''}&search=${searchQuery ?? ''}';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> createCampaign() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.createCampaign}';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> saveCampaign({
    String? title,
    String? templateId,
    String? whatsAppAccountId,
    String? schedule,
    String? scheduleAt,
    List<String>? contactLists,
    List<String>? contactTags,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.saveCampaign}";

    Map<String, dynamic> body = {
      "title": title,
      "template_id": templateId,
      "whatsapp_account_id": whatsAppAccountId,
      "schedule_date": schedule,
      "schedule_time": scheduleAt,
      "contact_lists": contactLists,
      "contact_tags": contactTags,
    };

    final response = await ApiService.postRequest(url, body);
    return response;
  }
}
