import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/all_contact/create_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact/delete_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact/update_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact_list/all_contact_list_response_model.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/all_contact_list/all_contact_list_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';

class AllContactListController extends GetxController {
  AllContactListRepo repo;
  bool isLoading = true;

  AllContactListController({required this.repo});

  String? nextPageUrl;
  String? imageUrl;
  String? imagePath;
  List<AllContactData> allContactListdata = [];
  File? csvFile;
  int page = 0;
  String searchQuery = '';
  TextEditingController contactNameController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

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
        printX("Invalid file type selected: ${file.name}");
        CustomSnackBar.error(errorList: [MyStrings.invalidFile.tr]);
        return;
      }

      csvFile = File(file.path!);
      update();
    } else {
      printX('No file selected');
    }
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

      String pram = "";

      pram += "?page=$page";
      pram += "&search=${searchController.text}";

      ResponseModel response = await repo.loadAllConatact(pram);

      if (response.statusCode == 200) {
        AllContactListResponseModel responseModel = AllContactListResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          List<AllContactData>? tempList = responseModel.data?.contactLists?.data ?? [];
          if (tempList.isNotEmpty) {
            nextPageUrl = responseModel.data?.contactLists?.nextPageUrl ?? "";
            allContactListdata.addAll(tempList);
            imagePath = responseModel.data?.contactLists?.path ?? "";
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
          Get.toNamed(RouteHelper.chatScreen, arguments: [conversation?.id.toString() ?? ""]);
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
              AllContactData(
                name: responseModel.data?.data?.name ?? "",
                contact: [],
                id: responseModel.data?.data?.id,
                userId: responseModel.data?.data?.userId,
              ),
            );
          } else {
            int index = allContactListdata.indexWhere((c) => c.id == id);
            if (index != -1) {
              allContactListdata[index] = AllContactData(
                name: responseModel.data?.data?.name ?? "",
                contact: [],
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
}
