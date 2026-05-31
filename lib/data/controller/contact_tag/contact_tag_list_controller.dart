import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/all_contact/delete_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact/update_contact_response_model.dart';
import 'package:ovowpp/data/model/contact_tag/contact_tag_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/contact_tag/contact_tag_list_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class ContactTagListController extends GetxController {
  ContactTagListRepo repo;
  bool isLoading = true;

  ContactTagListController({required this.repo});

  String? nextPageUrl;
  String? imageUrl;
  String? imagePath;
  List<AllContactTagsList> allContactListdata = [];
  File? csvFile;
  int page = 0;

  TextEditingController contactNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

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

  String searchQuery = "";

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

      String pram = "";

      pram += "?page=$page";
      pram += "&search=${searchController.text}";

      ResponseModel response = await repo.loadAllConatact(pram);

      if (response.statusCode == 200) {
        ContactTagListResponseModel responseModel = ContactTagListResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          List<AllContactTagsList>? tempList = responseModel.data?.contactTags?.data ?? [];
          if (tempList.isNotEmpty) {
            nextPageUrl = responseModel.data?.contactTags?.nextPageUrl ?? "";
            allContactListdata.addAll(tempList);
            imagePath = responseModel.data?.contactTags?.path ?? "";
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

  bool isFile(String path) {
    if (path.contains('.csv')) {
      return true;
    }
    if (path.contains('.xlsx')) {
      return true;
    }

    return false;
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

  bool submitContact = false;
  String id = "";
  void submitContactData() async {
    submitContact = true;
    update();
    try {
      ResponseModel model = await repo.manageContactRepo(id, contactNameController.text);
      if (model.statusCode == 200) {
        ContactListUpdateesponseModel responseModel = ContactListUpdateesponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == AppStatus.success) {
          if (id == "") {
            allContactListdata.insert(
              0,
              AllContactTagsList(
                name: responseModel.data?.data?.name ?? "",
                id: responseModel.data?.data?.id,
                userId: responseModel.data?.data?.userId,
              ),
            );
          } else {
            int index = allContactListdata.indexWhere((c) => c.id == id);
            if (index != -1) {
              allContactListdata[index] = AllContactTagsList(
                name: responseModel.data?.data?.name ?? "",
                id: responseModel.data?.data?.id,
                userId: responseModel.data?.data?.userId,
              );
            }
          }

          contactNameController.clear();
          Get.back();
          CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
        submitContact = false;
        update();
      } else {
        submitContact = false;
        update();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      submitContact = false;
      update();
    }
  }

  Future<void> checkAndRedirect(String remark, String? tradeId) async {}
}
