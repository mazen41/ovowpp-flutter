import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/core/helper/date_converter.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/kyc/kyc_response_model.dart';
import 'package:ovowpp/data/repo/kyc/kyc_repo.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class KycController extends GetxController {
  KycRepo repo;
  KycController({required this.repo});
  File? imageFile;

  bool isLoading = true;
  List<KycFormModel> formList = [];
  String selectOne = MyStrings.selectOne;

  KycResponseModel model = KycResponseModel();
  bool isNoDataFound = false;
  bool isAlreadyVerified = false;
  bool isAlreadyPending = false;

  Future<void> beforeInitLoadKycData() async {
    setStatusTrue();

    try {
      model = await repo.getKycData();

      if (model.data != null && model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        List<KycFormModel>? tList = model.data?.form?.list;

        if (tList != null && tList.isNotEmpty) {
          formList.clear();
          for (var element in tList) {
            if (element.type == 'select') {
              bool? isEmpty = element.options?.isEmpty;
              bool empty = isEmpty ?? true;
              if (element.options != null && empty != true) {
                element.options?.insert(0, selectOne);
                element.selectedValue = element.options?.first;
                formList.add(element);
              }
            } else {
              formList.add(element);
            }
          }
        }

        isNoDataFound = false;
      } else {
        if (model.remark?.toLowerCase() == 'already_verified') {
          isAlreadyVerified = true;
        } else if (model.remark?.toLowerCase() == 'under_review') {
          isAlreadyPending = true;
        } else {
          isNoDataFound = true;
        }
      }
    } finally {
      setStatusFalse();
    }
    setStatusFalse();
  }

  void setStatusTrue() {
    isLoading = true;
    update();
  }

  void setStatusFalse() {
    isLoading = false;
    update();
  }

  bool submitLoading = false;
  Future<void> submitKycData() async {
    List<String> list = hasError();

    if (list.isNotEmpty) {
      CustomSnackBar.error(errorList: list);
      return;
    }

    submitLoading = true;
    update();

    AuthorizationResponseModel response = await repo.submitKycData(formList);

    if (response.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
      isAlreadyPending = true;
      CustomSnackBar.success(successList: response.message ?? [MyStrings.success.tr]);
    } else {
      CustomSnackBar.error(errorList: response.message ?? [MyStrings.requestFail.tr]);
    }

    submitLoading = false;
    update();
  }

  List<String> hasError() {
    List<String> errorList = [];
    errorList.clear();

    for (var element in formList) {
      if (element.isRequired == 'required') {
        if (element.type == 'checkbox') {
          if (element.cbSelected == null) {
            errorList.add('${element.name} ${MyStrings.isRequired}');
          }
        } else if (element.type == 'file') {
          if (element.imageFile == null) {
            errorList.add('${element.name} ${MyStrings.isRequired}');
          }
        } else {
          if (element.selectedValue == '' || element.selectedValue == selectOne) {
            errorList.add('${element.name} ${MyStrings.isRequired}');
          }
        }
      }
    }
    return errorList;
  }

  void changeSelectedValue(dynamic value, int index) {
    formList[index].selectedValue = value;
    update();
  }

  void changeSelectedDateTimeValue(int index, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (!context.mounted) return;
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        formList[index].selectedValue = DateConverter.estimatedDateTime(selectedDateTime);
        // formList[index].selectedValue = selectedDateTime.toIso8601String();
        formList[index].textEditingController?.text = DateConverter.estimatedDateTime(selectedDateTime);
        printX(formList[index].textEditingController?.text);
        printX(formList[index].selectedValue);
        update();
      }
    }

    update();
  }

  void changeSelectedDateOnlyValue(int index, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final DateTime selectedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);

      formList[index].selectedValue = DateConverter.estimatedDate(selectedDateTime);
      formList[index].textEditingController?.text = DateConverter.estimatedDate(selectedDateTime);
      printX(formList[index].textEditingController?.text);
      printX(formList[index].selectedValue);
      update();
    }

    update();
  }

  void changeSelectedTimeOnlyValue(int index, BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      final DateTime selectedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );

      formList[index].selectedValue = DateConverter.estimatedTime(selectedDateTime);
      formList[index].textEditingController?.text = DateConverter.estimatedTime(selectedDateTime);
      printX(formList[index].textEditingController?.text);
      printX(formList[index].selectedValue);
      update();
    }

    update();
  }

  //End DATE TIME
  void changeSelectedRadioBtnValue(int listIndex, int selectedIndex) {
    formList[listIndex].selectedValue = formList[listIndex].options?[selectedIndex];
    update();
  }

  void changeSelectedCheckBoxValue(int listIndex, String value) {
    List<String> list = value.split('_');
    int index = int.parse(list[0]);
    bool status = list[1] == 'true' ? true : false;

    List<String>? selectedValue = formList[listIndex].cbSelected;

    if (selectedValue != null) {
      String? value = formList[listIndex].options?[index];
      if (status) {
        if (!selectedValue.contains(value)) {
          selectedValue.add(value!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(value)) {
          selectedValue.removeWhere((element) => element == value);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    } else {
      selectedValue = [];
      String? value = formList[listIndex].options?[index];
      if (status) {
        if (!selectedValue.contains(value)) {
          selectedValue.add(value!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(value)) {
          selectedValue.removeWhere((element) => element == value);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    }
  }

  void pickFile(int index, {List<String>? extention}) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: extention ?? ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx', 'csv', 'txt', 'docx', 'xls', 'xlsx'],
    );

    if (result == null) return;

    formList[index].imageFile = File(result.files.single.path!);
    String fileName = result.files.single.name;
    formList[index].selectedValue = fileName;
    update();
    return;
  }
}
