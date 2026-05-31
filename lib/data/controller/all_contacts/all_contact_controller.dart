import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/all_contact/all_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact/create_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact/delete_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact/upload_csv_response_model.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/all_contact/all_contact_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class AllContactController extends GetxController {
  AllContactRepo repo;
  bool isContactLoading = true;

  AllContactController({required this.repo});
  late TabController tabController;
  int currentIndex = 0;
  String? nextPageUrl;
  String? imageUrl;
  String? imagePath;
  List<Contact> allContactsData = [];
  List<Contact> newAllContactsData = [];
  File? csvFile;
  int page = 0;

  int selectedSearchItemIndex = 1;
  void changeSearchItem(int index) {
    selectedSearchItemIndex = index;
    update();
  }

  List<Map<String, dynamic>> get contactSearchItemList => [
    {
      'title': 'All',
      'onTap': () => changeSearchItem(0),
      'isSelected': selectedSearchItemIndex == 0, // সহজ করুন
    },
    {'title': 'Active', 'onTap': () => changeSearchItem(1), 'isSelected': selectedSearchItemIndex == 1},
    {'title': 'Inactive', 'onTap': () => changeSearchItem(2), 'isSelected': selectedSearchItemIndex == 2},
  ];

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
    } else {
      printX('No file selected');
    }
  }

  int? status;
  void selectStatus(int tabBarStatus) {
    switch (tabBarStatus) {
      case 0:
        status = null;
        break;
      case 1:
        status = 1;
        break;
      case 2:
        status = 0;
        break;
      default:
        status = null;
    }
    isContactLoading = true;
    // 🔥 Reset pagination on tab change
    page = 1;
    nextPageUrl = null;
    newAllContactsData.clear();

    // 🔥 Call API with new status
    newGetContact(status: status);

    update();
  }

  bool isLoadingMore = false;

  Future<void> newGetContact({bool loadMore = false, String? searchQuery, int? status}) async {
    try {
      if (loadMore) {
        isLoadingMore = true;
        page++;
      } else {
        page = 1;
        isContactLoading = true;
        newAllContactsData.clear();
      }

      update();

      final responseModel = await repo.newLoadAllContact(page, searchQuery: searchQuery, status: status);

      if (responseModel.statusCode == 200) {
        final newAllContactModel = AllContactResponseModel.fromJson(responseModel.responseJson);

        if (newAllContactModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          final tempList = newAllContactModel.data?.contacts?.data;

          nextPageUrl = newAllContactModel.data?.contacts?.nextPageUrl ?? "";

          if (tempList != null && tempList.isNotEmpty) {
            newAllContactsData.addAll(tempList);
          }
        }
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isContactLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  String searchQuery = "";
  Future<void> initData({bool initPage = false}) async {
    try {
      if (initPage) {
        page = 0;
        isContactLoading = true;
        allContactsData.clear();
        update();
      }
      if (page == 0) {
        allContactsData.clear();
      }

      page = page + 1;

      String pram = "";

      pram += "?page=$page";
      pram += "&search=${searchController.text}";

      ResponseModel response = await repo.loadAllContact(pram);

      if (response.statusCode == 200) {
        AllContactResponseModel responseModel = AllContactResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          List<Contact>? tempList = responseModel.data?.contacts?.data;

          if (tempList != null && tempList.isNotEmpty) {
            nextPageUrl = responseModel.data?.contacts?.nextPageUrl ?? "";

            allContactsData.addAll(tempList);
            imagePath = responseModel.data?.profilePath ?? "";
          }
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isContactLoading = false;
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

  Conversation? conversation;
  bool chatLoading = false;
  String contactId = "";
  Future<void> createConversation() async {
    try {
      chatLoading = true;
      update();
      page = page + 1;
      update();
      ResponseModel response = await repo.loadConversationRepo(contactId);
      if (response.statusCode == 200) {
        CreateContactResponseModel responseModel = CreateContactResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          conversation = responseModel.data?.conversation;
          Get.toNamed(
            RouteHelper.chatScreen,
            arguments: [conversation?.id.toString() ?? "", conversation?.lastMessageAt.toString() ?? ""],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      chatLoading = false;
      update();
    }
  }

  bool uploadCsv = false;

  Future<void> uploadCsvFile() async {
    if (csvFile == null) {
      CustomSnackBar.error(errorList: [MyStrings.noCsvFileSelected.tr]);
      return;
    }
    try {
      uploadCsv = false;
      update();
      ResponseModel response = await repo.uploadCsvRepo(csvFile!);
      if (response.statusCode == 200) {
        UploadCsvResponseModel responseModel = UploadCsvResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          initData();
          Get.back();
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      chatLoading = false;
      update();
    }
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl!.toLowerCase() != 'null' ? true : false;
  }

  bool isDeleteLoading = false;
  String userId = "";
  Future<void> deleteMessage(int index) async {
    try {
      isDeleteLoading = true;
      update();

      ResponseModel model = await repo.deleteContactRepo(userId);
      if (model.statusCode == 200) {
        DeleleContactResponseModel responseModel = DeleleContactResponseModel.fromJson(model.responseJson);

        if (responseModel.status?.toLowerCase() == AppStatus.success) {
          newAllContactsData.removeAt(index);
          Get.back();

          CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          Get.back();
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
      } else {
        Get.back();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: ["Something went wrong"]);
      Get.back();
    } finally {
      isDeleteLoading = false;
      update();
    }
  }
}
