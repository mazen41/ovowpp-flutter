import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';

import '../../../core/utils/util_exporter.dart';

class KycResponseModel {
  KycResponseModel({String? remark, String? status, List<String>? message, Data? data}) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  KycResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'] != null ? json['status'].toString() : '';
    _message = json['message'] != null ? (json['message'] as List<dynamic>).toStringList() : [];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? _remark;
  String? _status;
  List<String>? _message;
  Data? _data;

  String? get remark => _remark;
  String? get status => _status;
  List<String>? get message => _message;
  Data? get data => _data;
}

class Data {
  Data({Form? form}) {
    _form = form;
  }

  Data.fromJson(dynamic json) {
    _form = json['form'] != null ? Form.fromJson(json['form']) : null;
  }

  Form? _form;

  Form? get form => _form;
}

class Form {
  Form({List<KycFormModel>? list}) {
    _list = list;
  }

  List<KycFormModel>? _list = [];
  List<KycFormModel>? get list => _list;

  Form.fromJson(dynamic json) {
    var map = Map.from(json).map((key, value) => MapEntry(key, value));
    try {
      List<KycFormModel>? list = map.entries
          .map(
            (e) => KycFormModel(
              e.value['name'],
              e.value['label'],
              e.value['is_required'],
              e.value['instruction'],
              e.value['extensions'],
              (e.value['options'] as List).map((e) => e as String).toList(),
              e.value['type'],
              '',
            ),
          )
          .toList();

      if (list.isNotEmpty) {
        list.removeWhere((element) => element.toString().isEmpty);
        _list?.addAll(list);
      }
      _list;
    } catch (e) {
      printX(e.toString());
    }
  }
}

class KycFormModel {
  String? name;
  String? label;
  String? isRequired;
  String? instruction;
  String? extensions;
  List<String>? options;
  String? type;
  dynamic selectedValue;
  TextEditingController? textEditingController;
  File? imageFile;
  List<String>? cbSelected;
  // Added an optional parameter to initialize the textEditingController
  KycFormModel(
    this.name,
    this.label,
    this.isRequired,
    this.instruction,
    this.extensions,
    this.options,
    this.type,
    this.selectedValue, {
    this.cbSelected,
    this.imageFile,
    this.textEditingController,
  }) {
    // Initialize textEditingController if not provided
    textEditingController ??= TextEditingController();
  }
}
