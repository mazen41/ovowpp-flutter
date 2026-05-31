import 'dart:io';

import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

import '../../model/profile/profile_post_model.dart';
import '../../model/profile_complete/profile_complete_post_model.dart';

class ProfileRepo {
  Future<ResponseModel> updateProfile(ProfilePostModel model) async {
    String url = UrlContainer.updateProfileEndPoint;
    Map<String, File> attachmentFile = {};
    Map<String, String> finalMap = {
      'firstname': model.firstname,
      'lastname': model.lastName,
      'address': model.address ?? '',
      'zip': model.zip ?? '',
      'state': model.state ?? "",
      'city': model.city ?? '',
    };
    if (model.image != null) {
      attachmentFile = {'profile_image': model.image!};
    }
    ResponseModel responseModel = await ApiService.postMultiPartRequest(url, finalMap, attachmentFile);
    return responseModel;
  }

  Future<ResponseModel> completeProfile(ProfileCompletePostModel model) async {
    dynamic params = model.toMap();
    String url = '${UrlContainer.baseUrl}${UrlContainer.profileCompleteEndPoint}';
    ResponseModel responseModel = await ApiService.postRequest(url, params);
    return responseModel;
  }

  Future<ResponseModel> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<dynamic> getCountryList() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.countryEndPoint}';
    ResponseModel model = await ApiService.getRequest(url);
    return model;
  }
}
