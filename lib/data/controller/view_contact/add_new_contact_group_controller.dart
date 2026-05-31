import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/all_contact/save_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact/search_contact_list_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/view_contact/add_new_contact_repo.dart';

class AddNewContactGroupController extends GetxController {
  AddNewContactRepo repo;
  bool isLoading = true;

  AddNewContactGroupController({required this.repo});

  String? nextPageUrl;
  String? imageUrl;
  String? imagePath;
  List<AllContactDataList> allContactListdata = [];
  File? csvFile;
  int page = 0;

  TextEditingController contactNameController = TextEditingController();

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
      ResponseModel response = await repo.loadAllUnlistedContact(page, contactNameController.text);

      if (response.statusCode == 200) {
        SearchContactListResponseModel responseModel = SearchContactListResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          List<AllContactDataList>? tempList = responseModel.data?.contacts?.data ?? [];
          if (tempList.isNotEmpty) {
            nextPageUrl = responseModel.data?.contacts?.nextPageUrl ?? "";
            allContactListdata.addAll(tempList);
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

  List<String> contactList = [];

  void toggleContactSelection(String id) {
    if (contactList.contains(id)) {
      contactList.remove(id);
    } else {
      contactList.add(id);
    }
  }

  bool savingContact = false;

  void addContact() async {
    savingContact = true;
    update();
    try {
      ResponseModel model = await repo.addNewContactRepo(contactList, id);
      if (model.statusCode == 200) {
        SaveContactListResponseModel responseModel = SaveContactListResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == AppStatus.success) {
          Get.back();
          CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
        savingContact = false;
        update();
      } else {
        savingContact = false;
        update();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      savingContact = false;
      update();
    }
  }

  bool uploadCsv = false;

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl!.toLowerCase() != 'null' ? true : false;
  }

  String id = "";

  Future<void> checkAndRedirect(String remark, String? tradeId) async {}
}
