import 'dart:io';
import 'package:ovowpp/data/model/global/formdata/dynamic_file_value_keeper_model.dart';

import '../../../core/utils/my_strings.dart';
import '../../../core/utils/url_container.dart';
import '../../model/withdraw/withdraw_request_response_model.dart';
import '../../services/api_service.dart';
import '../../model/authorization/authorization_response_model.dart';
import '../../model/global/response_model/response_model.dart';

class WithdrawRepo {
  Future<dynamic> getAllWithdrawMethod() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawMethodUrl}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<dynamic> getWithdrawConfirmScreenData(String trxId) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawConfirmScreenUrl}$trxId';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<dynamic> addWithdrawRequest(int methodCode, double amount, String? authMode) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.addWithdrawRequestUrl}';
    Map<String, dynamic> params = {'method_code': methodCode.toString(), 'amount': amount.toString()};

    if (authMode != null && authMode.isNotEmpty && authMode.toLowerCase() != MyStrings.selectOne.toLowerCase()) {
      params['auth_mode'] = authMode.toLowerCase();
    }
    ResponseModel responseModel = await ApiService.postRequest(url, params);
    return responseModel;
  }

  List<Map<String, String>> fieldValueList = [];
  List<DynamicFileValueKeeperModel> filesDataList = [];

  Future<dynamic> confirmWithdrawRequest(String trx, List<FormModel> list, String twoFactorCode) async {
    fieldValueList.clear();
    await modelToMap(list);
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawRequestConfirm}';

    //Field value map
    Map<String, String> finalFieldValueMap = {};
    finalFieldValueMap.addAll({'trx': trx});

    for (var element in fieldValueList) {
      finalFieldValueMap.addAll(element);
    }
    //Attachments file filesDataList
    Map<String, File> attachmentFiles = filesDataList.asMap().map((index, value) => MapEntry(value.key, value.value));

    ResponseModel response = await ApiService.postMultiPartRequest(url, finalFieldValueMap, attachmentFiles);

    AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(response.responseJson);

    return model;
  }

  Future<ResponseModel> getAllWithdrawHistory(int page, {String searchText = ""}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.withdrawHistoryUrl}?page=$page&search=$searchText";
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<dynamic> modelToMap(List<FormModel> list) async {
    for (var e in list) {
      if (e.type == 'checkbox') {
        if (e.cbSelected != null && e.cbSelected!.isNotEmpty) {
          for (int i = 0; i < e.cbSelected!.length; i++) {
            fieldValueList.add({'${e.label}[$i]': e.cbSelected![i]});
          }
        }
      } else if (e.type == 'file') {
        if (e.file != null) {
          filesDataList.add(DynamicFileValueKeeperModel(e.label!, e.file!));
        }
      } else if (e.type == 'select') {
        if (e.selectedValue != null && e.selectedValue.toString() != MyStrings.selectOne) {
          fieldValueList.add({e.label ?? '': e.selectedValue});
        }
      } else {
        if (e.selectedValue != null && e.selectedValue.toString().isNotEmpty) {
          fieldValueList.add({e.label ?? '': e.selectedValue});
        }
      }
    }
  }
}
