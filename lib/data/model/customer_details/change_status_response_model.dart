// To parse this JSON data, do
//
//     final changeStatusResponseModel = changeStatusResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';

ChangeStatusResponseModel changeStatusResponseModelFromJson(String str) =>
    ChangeStatusResponseModel.fromJson(json.decode(str));

String changeStatusResponseModelToJson(ChangeStatusResponseModel data) => json.encode(data.toJson());

class ChangeStatusResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  ChangeStatusResponseModel({this.remark, this.status, this.message, this.data});

  factory ChangeStatusResponseModel.fromJson(Map<String, dynamic> json) => ChangeStatusResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
    "status": status,
    "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
    "data": data?.toJson(),
  };
}

class Data {
  final Note? note;

  Data({this.note});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(note: json["note"] == null ? null : Note.fromJson(json["note"]));

  Map<String, dynamic> toJson() => {"note": note?.toJson()};
}
