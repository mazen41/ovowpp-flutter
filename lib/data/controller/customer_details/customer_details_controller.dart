import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/translations/localization_controller.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/customer_details/change_status_response_model.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/customer_detais/customer_details_repo.dart';

class CustomerDetailsController extends GetxController {
  CustomerDetailsRepo repo;
  CustomerDetailsController({required this.repo});
  LocalizationController localizationController = LocalizationController();
  bool isLoading = false;
  late TabController tabController;
  int selectedIndex = 0;
  int currentIndex = 0;

  String id = "";
  final TextEditingController noteController = TextEditingController();
  final TextEditingController noteSearchController = TextEditingController();
  List<String> status = ["None", "Pending", "Important", "Done"];
  List<String> status2 = [MyStrings.selectTemplate, "avvv", "asdsad"];

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }

  String imagePath = "";
  List<AllContacts> tags = [];
  List<Note> notes = [];
  Conversation? conversation;
  Contact? contact;

  void customerDetailsData({bool forceLoad = true}) async {
    try {
      isLoading = forceLoad;
      update();
      ResponseModel model = await repo.getCustomerDetailsRepo(id);
      if (model.statusCode == 200) {
        CustomerDetailsResponseModel responseModel = CustomerDetailsResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          tags = responseModel.data?.conversation?.contact?.tags ?? [];
          notes = responseModel.data?.conversation?.notes ?? [];
          filteredNotes = responseModel.data?.conversation?.notes ?? [];
          contact = responseModel.data?.conversation?.contact;
          imagePath = responseModel.data?.imagePath ?? "";
          conversation = responseModel.data?.conversation;

          update();
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  List<Note> filteredNotes = [];

  void searchNotes(String query) {
    if (query.isEmpty) {
      filteredNotes = notes;
    } else {
      filteredNotes = notes.where((note) => note.note?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    }
    update();
  }

  void changeStatus(String status) async {
    try {
      ResponseModel model = await repo.changeStatusRepo(id, status);
      if (model.statusCode == 200) {
        ChangeStatusResponseModel responseModel = ChangeStatusResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      printX("error : ${e.toString()}");
    }
  }

  bool noteLoading = false;
  void addNote() async {
    noteLoading = true;
    update();
    try {
      ResponseModel model = await repo.addNotesRepo(id, noteController.text);
      if (model.statusCode == 200) {
        ChangeStatusResponseModel responseModel = ChangeStatusResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          notes.insert(0, responseModel.data?.note ?? Note());
          noteController.clear();
          customerDetailsData(forceLoad: false);
          CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
        noteLoading = false;
        update();
      } else {
        noteLoading = false;
        update();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      noteLoading = false;
      update();
    }
  }

  int? deletingIndex;

  void deleteNote(int index, String noteId) async {
    try {
      deletingIndex = index;
      update();
      ResponseModel model = await repo.deleteNoteRepo(noteId);
      if (model.statusCode == 200) {
        ChangeStatusResponseModel responseModel = ChangeStatusResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          filteredNotes.removeAt(index);
          notes.removeAt(index);
          Get.back();

          CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
        noteLoading = false;
        update();
      } else {
        noteLoading = false;
        update();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      noteLoading = false;
      update();
    } finally {
      deletingIndex = null;
      update();
    }
  }

  int selectedCurrencyIndex = 0;
  void changeIndicator() {
    if (tabController.index == 2) {
      var index = tabController.previousIndex;
      tabController.index = index;
    }

    currentIndex = tabController.index;
    customerDetailsData(forceLoad: false);
    update();
  }

  void changeCurrencyIndex(int index) {
    selectedCurrencyIndex = index;
    update();
  }
}
