import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';

import '../../../core/utils/util_exporter.dart';

class WithdrawRequestResponseModel {
  WithdrawRequestResponseModel({String? remark, String? status, List<String>? message, Data? data}) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  WithdrawRequestResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'];
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message;
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({String? trx, WithdrawData? withdrawData, Form? form}) {
    _trx = trx;
    _withdrawData = withdrawData;
    _form = form;
  }

  Data.fromJson(dynamic json) {
    _trx = json['trx'];
    _form = json['form'] != null ? Form.fromJson(json['form']) : null;
    _withdrawData = json['withdraw_data'] != null ? WithdrawData.fromJson(json['withdraw_data']) : null;
  }

  String? _trx;
  WithdrawData? _withdrawData;
  Form? _form;

  String? get trx => _trx;
  WithdrawData? get withdrawData => _withdrawData;
  Form? get form => _form;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['trx'] = _trx;
    if (_withdrawData != null) {
      map['withdraw_data'] = _withdrawData?.toJson();
    }
    return map;
  }
}

class Form {
  Form({List<FormModel>? list}) {
    _list = list;
  }

  List<FormModel>? _list = [];

  List<FormModel>? get list => _list;

  Form.fromJson(dynamic json) {
    var map = Map.from(json).map((k, v) => MapEntry<String, dynamic>(k, v));

    try {
      List<FormModel>? list = map.entries
          .map(
            (e) => FormModel(
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
      if (kDebugMode) {
        printX(e.toString());
      }
    }
  }
}

class FormModel {
  String? name;
  String? label;
  String? isRequired;
  String? instruction;
  String? extensions;
  List<String>? options;
  String? type;
  dynamic selectedValue;
  TextEditingController? textEditingController;
  File? file;
  List<String>? cbSelected;
  // Added an optional parameter to initialize the textEditingController
  FormModel(
    this.name,
    this.label,
    this.isRequired,
    this.instruction,
    this.extensions,
    this.options,
    this.type,
    this.selectedValue, {
    this.cbSelected,
    this.file,
    this.textEditingController,
  }) {
    // Initialize textEditingController if not provided
    textEditingController ??= TextEditingController();
  }
}

class WithdrawData {
  WithdrawData({
    String? methodId,
    String? userId,
    String? amount,
    String? currency,
    String? rate,
    String? charge,
    String? finalAmount,
    String? afterCharge,
    String? trx,
    String? updatedAt,
    String? createdAt,
    int? id,
  }) {
    _methodId = methodId;
    _userId = userId;
    _amount = amount;
    _currency = currency;
    _rate = rate;
    _charge = charge;
    _finalAmount = finalAmount;
    _afterCharge = afterCharge;
    _trx = trx;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
  }

  WithdrawData.fromJson(dynamic json) {
    _methodId = json['method_id'].toString();
    _userId = json['user_id'].toString();
    _amount = json['amount'] != null ? json['amount'].toString() : '0';
    _currency = json['currency'].toString();
    _rate = json['rate'] != null ? json['rate'].toString() : '1';
    _charge = json['charge'] != null ? json['charge'].toString() : '0';
    _finalAmount = json['final_amount'] != null ? json['final_amount'].toString() : '';
    _afterCharge = json['after_charge'] != null ? json['after_charge'].toString() : '';
    _trx = json['trx'].toString();
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }

  String? _methodId;
  String? _userId;
  String? _amount;
  String? _currency;
  String? _rate;
  String? _charge;
  String? _finalAmount;
  String? _afterCharge;
  String? _trx;
  String? _updatedAt;
  String? _createdAt;
  int? _id;

  String? get methodId => _methodId;
  String? get userId => _userId;
  String? get amount => _amount;
  String? get currency => _currency;
  String? get rate => _rate;
  String? get charge => _charge;
  String? get finalAmount => _finalAmount;
  String? get afterCharge => _afterCharge;
  String? get trx => _trx;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['method_id'] = _methodId;
    map['user_id'] = _userId;
    map['amount'] = _amount;
    map['currency'] = _currency;
    map['rate'] = _rate;
    map['charge'] = _charge;
    map['final_amount'] = _finalAmount;
    map['after_charge'] = _afterCharge;
    map['trx'] = _trx;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}
