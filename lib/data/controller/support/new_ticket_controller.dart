import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/support/new_ticket_store_model.dart';
import 'package:ovowpp/data/repo/support/support_repo.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';

class NewTicketController extends GetxController {
  SupportRepo repo;
  NewTicketController({required this.repo});

  bool isLoading = false;

  final FocusNode subjectFocusNode = FocusNode();
  final FocusNode priorityFocusNode = FocusNode();
  final FocusNode messageFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  String noFileChosen = MyStrings.noFileChosen;
  String chooseFile = MyStrings.chooseFile;

  bool isRtl = false;

  List<File> attachmentList = [];
  void pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result == null) return;

    for (var i = 0; i < result.files.length; i++) {
      attachmentList.add(File(result.files[i].path!));
    }
    update();
    return;
  }

  void removeAttachmentFromList(int index) {
    if (attachmentList.length > index) {
      attachmentList.removeAt(index);
      update();
    }
  }

  void addNewAttachment() {
    if (attachmentList.length > 4) {
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      return;
    }

    update();
  }

  void refreshAttachmentList() {
    attachmentList.clear();
    attachmentList = [];
    update();
  }

  List<String> priorityList = [MyStrings.low.tr, MyStrings.medium.tr, MyStrings.high.tr];
  String? selectedPriority = MyStrings.low.tr;

  int selectedIndex = 0;
  void setPriority(String? newValue) {
    selectedPriority = newValue;
    if (newValue != null) {
      selectedIndex = priorityList.indexOf(newValue);
    }
    update();
  }

  bool isImage(String path) {
    if (path.contains('.jpg')) {
      printX("its image");
      return true;
    }
    if (path.contains('.png')) {
      return true;
    }
    if (path.contains('.jpeg')) {
      return true;
    }
    return false;
  }

  bool isXlsx(String path) {
    if (path.contains('.xlsx')) {
      return true;
    }
    if (path.contains('.xls')) {
      return true;
    }
    if (path.contains('.xlx')) {
      return true;
    }
    return false;
  }

  bool isDoc(String path) {
    if (path.contains('.doc')) {
      return true;
    }
    if (path.contains('.docs')) {
      return true;
    }
    return false;
  }

  bool submitLoading = false;
  void submit() async {
    String name = nameController.text.toString();
    String email = emailController.text.toString();
    String subject = subjectController.text.toString();
    String priority = "${selectedIndex + 1}";
    String message = messageController.text.toString();

    if (message.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.messageRequired]);
      return;
    }

    if (message.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.subjectRequired]);
      return;
    }

    submitLoading = true;
    update();

    TicketStoreModel model = TicketStoreModel(
      name: name,
      email: email,
      subject: subject,
      priority: priority,
      message: message,
      list: attachmentList,
    );
    ResponseModel responseModel = await repo.storeTicket(model);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        Get.back(result: "updated");
        CustomSnackBar.success(successList: [MyStrings.ticketCreateSuccessfully]);
        clearSelectedData();
      } else {
        Get.back(result: "updated");
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
        clearSelectedData();
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  void clearSelectedData() {
    subjectController.text = '';
    messageController.text = '';
    refreshAttachmentList();
  }
}
