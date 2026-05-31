// To parse this JSON data, do
//
//     final saveContactListResponseModel = saveContactListResponseModelFromJson(jsonString);

import 'dart:convert';

SaveContactListResponseModel saveContactListResponseModelFromJson(String str) =>
    SaveContactListResponseModel.fromJson(json.decode(str));

String saveContactListResponseModelToJson(SaveContactListResponseModel data) => json.encode(data.toJson());

class SaveContactListResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;

  SaveContactListResponseModel({this.remark, this.status, this.message});

  factory SaveContactListResponseModel.fromJson(Map<String, dynamic> json) => SaveContactListResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
    "status": status,
    "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
  };
}
