import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/support/support_ticket_view_response_model.dart';

import 'package:ovowpp/data/repo/support/support_repo.dart';
import 'package:ovowpp/data/services/api_service.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TicketDetailsController extends GetxController {
  SupportRepo repo;
  final String ticketId;
  String username = '';
  bool isRtl = false;

  TicketDetailsController({required this.repo, required this.ticketId});

  Future<void> loadData() async {
    isLoading = true;
    update();
    String languageCode = SharedPreferenceService.getString(SharedPreferenceService.languageCode, defaultValue: 'en');
    if (languageCode == 'ar') {
      isRtl = true;
    }
    await loadTicketDetailsData();
    isLoading = false;
    update();
  }

  bool isLoading = false;

  final TextEditingController replyController = TextEditingController();

  MyTickets? receivedTicketModel;
  List<File> attachmentList = [];

  String noFileChosen = MyStrings.noFileChosen;
  String chooseFile = MyStrings.chooseFile;

  String ticketImagePath = "";

  void pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
    );
    if (result == null) return;

    attachmentList.add(File(result.files.single.path!));

    update();
  }

  void removeAttachmentFromList(int index) {
    if (attachmentList.length > index) {
      attachmentList.removeAt(index);
      update();
    }
  }

  SupportTicketViewResponseModel model = SupportTicketViewResponseModel();
  List<SupportMessage> messageList = [];
  String ticket = '';
  String subject = '';
  String status = '-1';
  String ticketName = '';
  String mediaBasePath = '';

  Future<void> loadTicketDetailsData({bool shouldLoad = true}) async {
    isLoading = shouldLoad;
    update();
    ResponseModel response = await repo.getSingleTicket(ticketId);

    if (response.statusCode == 200) {
      model = SupportTicketViewResponseModel.fromJson(response.responseJson);
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        mediaBasePath = model.data?.mediaBasePath ?? '';
        ticket = model.data?.myTickets?.ticket ?? '';
        subject = model.data?.myTickets?.subject ?? '';
        status = model.data?.myTickets?.status ?? '';
        ticketName = model.data?.myTickets?.name ?? '';
        receivedTicketModel = model.data?.myTickets;
        List<SupportMessage>? tempTicketList = model.data?.myMessages;
        if (tempTicketList != null && tempTicketList.isNotEmpty) {
          messageList.clear();
          messageList.addAll(tempTicketList);
        }
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();
  }

  bool submitLoading = false;
  Future<void> submitReply() async {
    if (replyController.text.toString().isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.replyTicketEmptyMsg]);
      return;
    }
    submitLoading = true;
    update();

    try {
      bool b = await repo.replyTicket(replyController.text, attachmentList, receivedTicketModel?.id.toString() ?? "-1");

      if (b) {
        await loadTicketDetailsData(shouldLoad: false);
        CustomSnackBar.success(successList: [MyStrings.repliedSuccessfully]);
        replyController.text = '';
        refreshAttachmentList();
      }
    } catch (e) {
      submitLoading = false;
      update();
    } finally {
      submitLoading = false;
      update();
    }
  }

  void setTicketModel(MyTickets? ticketModel) {
    receivedTicketModel = ticketModel;
    update();
  }

  void clearAllData() {
    refreshAttachmentList();
    replyController.clear();
    messageList.clear();
  }

  void refreshAttachmentList() {
    attachmentList.clear();
    update();
  }

  bool closeLoading = false;
  void closeTicket(String supportTicketID) async {
    closeLoading = true;
    update();
    ResponseModel responseModel = await repo.closeTicket(supportTicketID);
    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);
      if (model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        clearAllData();
        Get.back(result: "updated");
        CustomSnackBar.success(successList: model.message ?? [MyStrings.requestSuccess]);
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    closeLoading = false;
    update();
  }

  //download pdf
  TargetPlatform? platform;
  String downLoadId = "";

  Future<String?> findLocalPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        return directory.path;
      } else {
        return (await getExternalStorageDirectory())?.path ?? "";
      }
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return null;
    }
  }

  bool isSubmitLoading = false;
  int selectedIndex = -1;
  String getContentType(String extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'jpeg':
      case 'jpg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  Future<void> downloadAttachment(String url, int index, String extension) async {
    selectedIndex = index;
    isSubmitLoading = true;
    update();
    var downloadsDirectory = Directory('/storage/emulated/0/Download');
    var fileName = '${MyStrings.appName}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    if (downloadsDirectory.existsSync() == true) {
      final downloadPath = '${downloadsDirectory.path}/$fileName';
      ResponseModel responseModel = await ApiService.downloadFile(url, downloadPath);
      CustomSnackBar.success(successList: [responseModel.message]);
    }

    selectedIndex = -1;
    isSubmitLoading = false;
    update();
  }

  Future<void> saveAndOpenFile(List<int> bytes, String fileName, String extension) async {
    Directory? downloadsDirectory;

    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        CustomSnackBar.error(errorList: [MyStrings.permissionDenied]);
        return;
      }
      downloadsDirectory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDirectory = await getApplicationDocumentsDirectory();
    }

    if (downloadsDirectory != null) {
      final downloadPath = '${downloadsDirectory.path}/$fileName';
      final file = File(downloadPath);
      await file.writeAsBytes(bytes);
      CustomSnackBar.success(successList: ['File saved at: $downloadPath']);
      await openFile(downloadPath, extension);
    } else {
      CustomSnackBar.error(errorList: [MyStrings.downloadDirNotFound]);
    }
  }

  Future<void> openFile(String path, String extension) async {
    final file = File(path);
    if (await file.exists()) {
      final result = await OpenFile.open(path);
      if (result.type != ResultType.done) {
        if (result.type == ResultType.noAppToOpen) {
          CustomSnackBar.error(errorList: [MyStrings.noDocOpenerApp, 'File saved at: $path']);
        }
      }
    } else {
      CustomSnackBar.error(errorList: [MyStrings.fileNotFound]);
    }
  }
}
