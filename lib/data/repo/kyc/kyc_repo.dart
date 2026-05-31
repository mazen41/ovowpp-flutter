import 'dart:io';

import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/global/formdata/dynamic_file_value_keeper_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/kyc/kyc_response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class KycRepo extends ApiService {
  Future<KycResponseModel> getKycData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.kycFormUrl}';
    ResponseModel responseModel = await ApiService.getRequest(url);

    if (responseModel.statusCode == 200) {
      KycResponseModel model = KycResponseModel.fromJson(responseModel.responseJson);

      if (model.status == 'success') {
        return model;
      } else {
        if (model.remark?.toLowerCase() != 'already_verified' && model.remark?.toLowerCase() != 'under_review') {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }

        return model;
      }
    } else {
      return KycResponseModel();
    }
  }

  List<Map<String, String>> fieldValueList = [];
  List<DynamicFileValueKeeperModel> filesDataList = [];

  Future<AuthorizationResponseModel> submitKycData(List<KycFormModel> list) async {
    fieldValueList.clear();
    await modelToMap(list);
    String url = '${UrlContainer.baseUrl}${UrlContainer.kycSubmitUrl}';

    //Field value map
    Map<String, String> finalFieldValueMap = {};

    for (var element in fieldValueList) {
      finalFieldValueMap.addAll(element);
    }
    //Attachments file list
    Map<String, File> attachmentFiles = filesDataList.asMap().map((index, value) => MapEntry(value.key, value.value));

    ResponseModel response = await ApiService.postMultiPartRequest(url, finalFieldValueMap, attachmentFiles);

    AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(response.responseJson);

    return model;
  }

  Future<dynamic> modelToMap(List<KycFormModel> list) async {
    for (var e in list) {
      if (e.type == 'checkbox') {
        if (e.cbSelected != null && e.cbSelected!.isNotEmpty) {
          for (int i = 0; i < e.cbSelected!.length; i++) {
            fieldValueList.add({'${e.label}[$i]': e.cbSelected![i]});
          }
        }
      } else if (e.type == 'file') {
        if (e.imageFile != null) {
          filesDataList.add(DynamicFileValueKeeperModel(e.label!, e.imageFile!));
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
