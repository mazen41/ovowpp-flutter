import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class FaqRepo {
  Future<dynamic> loadFaq() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.faqEndPoint}';
    final response = await ApiService.getRequest(url);
    return response;
  }
}
