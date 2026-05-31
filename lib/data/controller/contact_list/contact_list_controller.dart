import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/translations/localization_controller.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/model/chat/chat_data_response_model.dart';
import 'package:ovowpp/data/model/chat/message_model.dart';
import 'package:ovowpp/data/model/chat/send_message_response_model.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/contact_list/contact_list_repo.dart';

import '../../../core/utils/util.dart';

class ContactListController extends GetxController {
  ContactListRepo repo;
  ContactListController({required this.repo});

  final TextEditingController chatController = TextEditingController();
  LocalizationController localizationController = LocalizationController();
  bool isLoading = false;
  bool nextPageLoading = false;
  String image = "";
  String imagePath = "";
  String mobile = "";
  String username = "";
  int page = 0;
  final ScrollController scrollController = ScrollController();
  List<String> more = ["Contact Details", "Send Templates"];

  File? selectedFile;

  void pickFile(int type) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: type == 0
          ? FileType.image
          : type == 1
          ? FileType.video
          : FileType.custom,
    );

    if (result == null) return;

    selectedFile = File(result.files.single.path!);
    update();
  }

  void pickDocs() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docs', 'xls'],
    );

    if (result == null) return;

    selectedFile = File(result.files.single.path!);
    update();
  }

  void removeAttachmentFromList() {
    if (selectedFile != null) {
      try {
        selectedFile!.delete();
      } catch (e) {
        printX("error : ${e.toString()}");
      }
      selectedFile = null;
      update();
    }
  }

  String converstaionId = "";
  Contact? contact;
  List<MessagesData> messages = [];
  List<MessagesData> filteredMessages = [];
  Future<void> getContactListData() async {
    try {
      if (page == 0) {
        isLoading = true;
        update();
      } else {
        nextPageLoading = true;
        update();
      }
      page = page + 1;
      final responseModal = await repo.getContactListDataRepo(page.toString(), searchQuery);
      if (responseModal.statusCode == 200) {
        ChatDataResponseModel model = ChatDataResponseModel.fromJson(responseModal.responseJson);
        if (model.status?.toLowerCase() == MyStrings.success) {
          messages.addAll(model.data?.messages?.data ?? []);
          contact = model.data?.contact;
          imagePath = model.data?.profilePath ?? "";
          nextPageUrl = model.data?.messages?.nextPageUrl ?? "";
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModal.message]);
      }
      if (page == 1) {
        isLoading = false;
        update();
      } else {
        nextPageLoading = false;
        update();
      }
    } catch (e) {
      if (page == 0) {
        isLoading = false;
        update();
      } else {
        nextPageLoading = false;
        update();
      }
    }
  }

  String searchQuery = '';
  void filterChats() {
    if (searchQuery.isEmpty) {
      filteredMessages = List.from(messages);
    } else {
      filteredMessages = messages.where((chat) => (chat.message ?? '').toLowerCase().contains(searchQuery)).toList();
    }
    update();
  }

  List<MessagesData> getCurrentChatData() {
    return searchQuery.isEmpty ? messages : filteredMessages;
  }

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (hasNext()) {
        getContactListData();
      }
    }
  }

  String nextPageUrl = "";

  bool hasNext() {
    return nextPageUrl.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  bool sendingMessage = false;
  void sendMessage() async {
    sendingMessage = true;
    update();
    try {
      MessageModel messageModel = MessageModel(
        chatId: converstaionId,
        message: chatController.text,
        file: selectedFile,
      );
      ResponseModel model = await repo.sendMessageRepo(messageModel);
      if (model.statusCode == 200) {
        SentMessageResponseModel responseModel = SentMessageResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == AppStatus.success) {
          if (responseModel.data?.message != null) {
            messages.insert(0, responseModel.data?.message ?? MessagesData());
          }
          chatController.clear();
          selectedFile = null;
          // CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
        sendingMessage = false;
        update();
      } else {
        sendingMessage = false;
        update();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      sendingMessage = false;
      update();
    }
  }

  bool isSearch = false;
  void changeSearchStatus() {
    isSearch = !isSearch;
    update();
  }

  List<String> status = [MyStrings.selectTemplate, "avvv", "asdsad"];
  int selectedIndex = 0;
  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }
}
