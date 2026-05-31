// To parse this JSON data, do
//
//     final deleleContactResponseModel = deleleContactResponseModelFromJson(jsonString);

import 'dart:convert';

DeleleContactResponseModel deleleContactResponseModelFromJson(String str) =>
    DeleleContactResponseModel.fromJson(json.decode(str));

String deleleContactResponseModelToJson(DeleleContactResponseModel data) => json.encode(data.toJson());

class DeleleContactResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;

  DeleleContactResponseModel({this.remark, this.status, this.message});

  factory DeleleContactResponseModel.fromJson(Map<String, dynamic> json) => DeleleContactResponseModel(
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
