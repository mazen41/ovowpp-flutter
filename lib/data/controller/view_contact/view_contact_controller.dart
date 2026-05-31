import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/all_contact/delete_contact_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/view_contact/view_contact_response_model.dart';
import 'package:ovowpp/data/repo/view_contact/view_contact_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class ViewContactController extends GetxController {
  ViewContactRepo repo;
  bool isLoading = true;

  ViewContactController({required this.repo});

  String? nextPageUrl;
  String? imageUrl;
  String? imagePath;
  List<ContactsData> allContactListdata = [];
  File? csvFile;
  int page = 0;
  String searchQuery = "";

  TextEditingController contactNameController = TextEditingController();

  void clearActiveNotificationInfo() {
    SharedPreferenceService.setBool(SharedPreferenceService.hasNewNotificationKey, false);
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;

      final extension = file.extension?.toLowerCase();
      if (extension != 'csv' && extension != 'xlsx') {
        CustomSnackBar.error(errorList: [MyStrings.invalidFile.tr]);
        return;
      }

      csvFile = File(file.path!);
      update();
    } else {}
  }

  Future<void> initData({bool initPage = false}) async {
    try {
      if (initPage) {
        page = 0;
        isLoading = true;
        update();
      }
      if (page == 0) {
        allContactListdata.clear();
      }

      page = page + 1;
      update();
      ResponseModel response = await repo.loadAllConatact(page, id, searchQuery);

      if (response.statusCode == 200) {
        ViewContactListUpdateesponseModel responseModel = ViewContactListUpdateesponseModel.fromJson(
          response.responseJson,
        );
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          List<ContactsData>? tempList = responseModel.data?.contacts?.data ?? [];
          if (tempList.isNotEmpty) {
            nextPageUrl = responseModel.data?.contacts?.nextPageUrl ?? "";
            allContactListdata.addAll(tempList);
            imagePath = responseModel.data?.profilePath ?? "";
          }
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  bool uploadCsv = false;

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl!.toLowerCase() != 'null' ? true : false;
  }

  bool isDeleting = false;
  String userId = "";
  void deleteMessage(int index) async {
    isDeleting = true;
    update();
    try {
      ResponseModel model = await repo.deleteContactRepo(userId);
      if (model.statusCode == 200) {
        DeleleContactResponseModel responseModel = DeleleContactResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == AppStatus.success) {
          allContactListdata.removeAt(index);
          Get.back();
          CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
        isDeleting = false;
        update();
      } else {
        isDeleting = false;
        update();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      isDeleting = false;
      update();
    }
  }

  String id = "";
  String name = "";

  Future<void> checkAndRedirect(String remark, String? tradeId) async {}
}
