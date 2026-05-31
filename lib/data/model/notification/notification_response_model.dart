import 'package:ovowpp/core/helper/string_format_helper.dart';

class NotificationResponseModel {
  NotificationResponseModel({String? remark, String? status, List<String>? message, MainData? mainData}) {
    _remark = remark;
    _status = status;
    _message = message;
    _mainData = mainData;
  }

  NotificationResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'];
    _message = json['message'] != null ? (json['message'] as List<dynamic>).toStringList() : [];
    _mainData = json['data'] != null ? MainData.fromJson(json['data']) : null;
  }
  String? _remark;
  String? _status;
  List<String>? _message;
  MainData? _mainData;

  String? get remark => _remark;
  String? get status => _status;
  List<String>? get message => _message;
  MainData? get data => _mainData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message;
    }
    if (_mainData != null) {
      map['data'] = _mainData?.toJson();
    }
    return map;
  }
}

class MainData {
  MainData({Notifications? notifications}) {
    _notifications = notifications;
  }

  MainData.fromJson(dynamic json) {
    _notifications = json['notifications'] != null ? Notifications.fromJson(json['notifications']) : null;
  }
  Notifications? _notifications;

  Notifications? get notifications => _notifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_notifications != null) {
      map['notifications'] = _notifications?.toJson();
    }
    return map;
  }
}

class Notifications {
  Notifications({List<Data>? data, List<Links>? links, dynamic nextPageUrl}) {
    _data = data;

    _links = links;
    _nextPageUrl = nextPageUrl;
  }

  Notifications.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }

    if (json['links'] != null) {
      _links = [];
      json['links'].forEach((v) {
        _links?.add(Links.fromJson(v));
      });
    }
    _nextPageUrl = json['next_page_url'];
  }

  List<Data>? _data;

  List<Links>? _links;
  dynamic _nextPageUrl;

  List<Data>? get data => _data;

  List<Links>? get links => _links;
  dynamic get nextPageUrl => _nextPageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }

    if (_links != null) {
      map['links'] = _links?.map((v) => v.toJson()).toList();
    }
    map['next_page_url'] = _nextPageUrl;

    return map;
  }
}

class Links {
  Links({dynamic url, String? label, bool? active}) {
    _url = url;
    _label = label;
    _active = active;
  }

  Links.fromJson(dynamic json) {
    _url = json['url'];
    _label = json['label'];
    _active = json['active'];
  }
  dynamic _url;
  String? _label;
  bool? _active;

  dynamic get url => _url;
  String? get label => _label;
  bool? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    map['label'] = _label;
    map['active'] = _active;
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.userId,
    this.sender,
    this.sentFrom,
    this.sentTo,
    this.subject,
    this.message,
    this.notificationType,
    this.image,
    this.userRead,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'].toString();
    sender = json['sender'].toString();
    sentFrom = json['sent_from'].toString();
    sentTo = json['sent_to'].toString();
    subject = json['subject'].toString();
    message = json['message'];
    notificationType = json['notification_type'].toString();
    image = json['image'].toString();
    userRead = json['user_read'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  String? userId;
  String? sender;
  String? sentFrom;
  String? sentTo;
  String? subject;
  String? message;
  String? notificationType;
  String? image;
  String? userRead;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['sender'] = sender;
    map['sent_from'] = sentFrom;
    map['sent_to'] = sentTo;
    map['subject'] = subject;
    map['message'] = message;
    map['notification_type'] = notificationType;
    map['image'] = image;
    map['user_read'] = userRead;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
