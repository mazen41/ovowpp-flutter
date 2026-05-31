import 'dart:io';

import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class CustomerAccountRepo {
  Future<void> clearSharedPrefData() async {
    await SharedPreferenceService.setString(SharedPreferenceService.userNameKey, '');
    await SharedPreferenceService.setString(SharedPreferenceService.userEmailKey, '');
    await SharedPreferenceService.setAccessTokenType('');
    await SharedPreferenceService.setAccessToken('');
    await SharedPreferenceService.setBool(SharedPreferenceService.rememberMeKey, false);
    return Future.value();
  }

  Future<ResponseModel> getTagsDataRepo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.tagsDataEndPoint}/';
    ResponseModel responseModel = await ApiService.getRequest(url);

    return responseModel;
  }

  Future<ResponseModel> getContactDataRepo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.allTagsandCOntactDataEndPoint}';
    ResponseModel responseModel = await ApiService.getRequest(url);

    return responseModel;
  }

  Future<ResponseModel> saveContactRepo(Map<String, dynamic> data, String id) async {
    String url =
        "${id != "" ? UrlContainer.updateCustomerContactUrl : UrlContainer.saveCustomerContactUrl}${id != "" ? "/"
                  "$id" : ""}";

    Map<String, File> fileMap = {};
    if (data.containsKey('profile_image') && data['profile_image'] is File) {
      fileMap['profile_image'] = data['profile_image'];
    }

    // // Remove image from the main data so it’s only sent as file
    // data.remove('image');

    // Make multipart request
    ResponseModel responseModel = await ApiService.postMultiPartRequest(url, data, fileMap);
    return responseModel;
  }
}
