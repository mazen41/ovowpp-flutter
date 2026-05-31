import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class NotificationRepo {
  Future<dynamic> loadAllNotification(int page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.notificationEndPoint}?page=$page';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> readNotification(int notificationId) async {
    /* String url='${UrlContainer.baseUrl}${UrlContainer.readNotificationEndPoint}$notificationId';
    final response=await apiClient.request(url,Method.getMethod,null,passHeader: true);
    return response;*/
  }
}
