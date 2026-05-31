// To parse this JSON data, do
//
//     final contactListUpdateesponseModel = contactListUpdateesponseModelFromJson(jsonString);

import 'dart:convert';

ContactListUpdateesponseModel contactListUpdateesponseModelFromJson(String str) =>
    ContactListUpdateesponseModel.fromJson(json.decode(str));

String contactListUpdateesponseModelToJson(ContactListUpdateesponseModel data) => json.encode(data.toJson());

class ContactListUpdateesponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final ContactListUpdateesponseModelData? data;

  ContactListUpdateesponseModel({this.remark, this.status, this.message, this.data});

  factory ContactListUpdateesponseModel.fromJson(Map<String, dynamic> json) => ContactListUpdateesponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : ContactListUpdateesponseModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
    "status": status,
    "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
    "data": data?.toJson(),
  };
}

class ContactListUpdateesponseModelData {
  final DataData? data;
  final String? type;

  ContactListUpdateesponseModelData({this.data, this.type});

  factory ContactListUpdateesponseModelData.fromJson(Map<String, dynamic> json) => ContactListUpdateesponseModelData(
    data: json["data"] == null ? null : DataData.fromJson(json["data"]),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "type": type};
}

class DataData {
  final String? id;
  final String? userId;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  DataData({this.id, this.userId, this.name, this.createdAt, this.updatedAt});

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    name: json["name"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
