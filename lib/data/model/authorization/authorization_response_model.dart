import 'package:ovowpp/core/helper/string_format_helper.dart';

import '../user/user.dart';

class AuthorizationResponseModel {
  AuthorizationResponseModel({String? remark, String? status, List<String>? message, Data? data}) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  AuthorizationResponseModel.fromJson(dynamic json) {
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
  Data({String? actionId, User? user}) {
    _actionId = actionId;
    _user = user;
  }

  Data.fromJson(dynamic json) {
    _actionId = json['action_id'] != null ? json['action_id'].toString() : '';
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  String? _actionId;
  User? _user;

  String? get actionId => _actionId;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['action_id'] = _actionId;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }
}
