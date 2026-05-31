import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class SubscriptionRepo {
  Future<ResponseModel> getPricingPlans() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.subscriptionIndexEndPoint}';
    ResponseModel response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> getPurchaseHistory(int page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.subscriptionPurchaseHistoryEndPoint}?page=$page';
    ResponseModel response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> downloadInvoiceRepo(String invoiceId, String filePath) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.subscriptionInvoiceDownloadEndPoint}$invoiceId';
    ResponseModel response = await ApiService.downloadFile(url, filePath);
    return response;
  }

  Future<ResponseModel> purchasePlan({required String planId, required Map<String, dynamic> data}) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.subscriptionPlanPurchaseEndPoint}$planId';
    ResponseModel response = await ApiService.postRequest(url, data);
    return response;
  }
}
