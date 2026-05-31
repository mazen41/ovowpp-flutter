import 'package:ovowpp/data/model/global/response_model/response_model.dart';

import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class DashboardRepo {
  Future<dynamic> loadDashboardData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.dashBoardEndPoint}';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> getGeneralSetting() async {
    String url = UrlContainer.generalSettingEndPoint;
    ResponseModel response = await ApiService.getRequest(url);
    return response;
  }
}
