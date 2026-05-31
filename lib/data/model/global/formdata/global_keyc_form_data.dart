import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ovowpp/core/utils/util.dart';

class GlobalKYCForm {
  GlobalKYCForm({List<GlobalFormModle>? list}) {
    _list = list;
  }

  List<GlobalFormModle>? _list = [];
  List<GlobalFormModle>? get list => _list;

  GlobalKYCForm.fromJson(dynamic json) {
    try {
      var map = Map.from(json).map((key, value) => MapEntry(key, value));
      List<GlobalFormModle>? list = map.entries
          .map(
            (e) => GlobalFormModle(
              e.value['name'],
              e.value['label'],
              e.value['is_required'],
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

class GlobalFormModle {
  String? name;
  String? label;
  String? isRequired;
  String? extensions;
  List<String>? options;
  String? type;
  dynamic selectedValue;
  File? imageFile;
  List<String>? cbSelected;

  GlobalFormModle(
    this.name,
    this.label,
    this.isRequired,
    this.extensions,
    this.options,
    this.type,
    this.selectedValue, {
    this.cbSelected,
    this.imageFile,
  });
}
