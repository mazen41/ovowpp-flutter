import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class HomeRepo {
  Future<ResponseModel> getData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.dashBoardUrl}";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> getNumbersRepo() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.allNumbersUrl}";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> getchatListRepo(String tab, String page, String search) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.chatListUrl}/?status=$tab&page=$page&search=$search";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> newNewChat(int page, {int? status, searchQuery}) async {
    //int page,{int? status,searchQuery}
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.chatListUrl}/?status=${status ?? ''}&page=$page&search=${searchQuery ?? ''}";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> switchNumberRepo(String webId) async {
    Map<String, String> map = {};
    String url = '${UrlContainer.baseUrl}${UrlContainer.switchNumberUrl}/$webId';
    final response = await ApiService.postRequest(url, map);
    return response;
  }

  Future<dynamic> getGeneralSetting() async {
    String url = UrlContainer.generalSettingEndPoint;
    ResponseModel response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> getUserInfoData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }
}
