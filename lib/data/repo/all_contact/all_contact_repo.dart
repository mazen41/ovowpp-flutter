import 'dart:io';

import 'package:ovowpp/data/model/global/response_model/response_model.dart';

import '../../../core/utils/url_container.dart';
import '../../services/api_service.dart';

class AllContactRepo {
  Future<dynamic> loadAllContact(String pram) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.contactListDataEndPoint}$pram';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> newLoadAllContact(int page, {int? status, searchQuery}) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.contactListDataEndPoint}?page=$page&status=${status ?? ''}&search=${searchQuery ?? ''}';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> loadConversationRepo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.createConversationDataEndPoint}$id';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> uploadCsvRepo(File csvFile) async {
    Map<String, File> attachmentFile = {};

    attachmentFile = {'file': csvFile};
    String url = '${UrlContainer.baseUrl}${UrlContainer.importCsvEndPoint}';
    final response = await ApiService.postMultiPartRequest(url, {}, attachmentFile);
    return response;
  }

  Future<ResponseModel> deleteContactRepo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.deleteMessageUrl}$id';
    final response = await ApiService.postRequest(url, {});
    return response;
  }
}
