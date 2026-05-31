import 'package:ovowpp/core/helper/string_format_helper.dart';

class DepositInsertResponseModel {
  DepositInsertResponseModel({String? remark, String? status, List<String>? message, Data? data}) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  DepositInsertResponseModel.fromJson(dynamic json) {
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
  Data({String? redirectUrl}) {
    _redirectUrl = redirectUrl;
  }

  Data.fromJson(dynamic json) {
    _redirectUrl = json['redirect_url'] != null ? json['redirect_url'].toString() : '';
  }

  String? _redirectUrl;

  String? get redirectUrl => _redirectUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['redirect_url'] = _redirectUrl;
    return map;
  }
}
