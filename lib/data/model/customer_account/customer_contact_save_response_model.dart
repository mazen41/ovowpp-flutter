// To parse this JSON data, do
//
//     final customerContactSaveResponseModel = customerContactSaveResponseModelFromJson(jsonString);

import 'dart:convert';

CustomerContactSaveResponseModel customerContactSaveResponseModelFromJson(String str) =>
    CustomerContactSaveResponseModel.fromJson(json.decode(str));

String customerContactSaveResponseModelToJson(CustomerContactSaveResponseModel data) => json.encode(data.toJson());

class CustomerContactSaveResponseModel {
  final String remark;
  final String status;
  final List<String> message;

  CustomerContactSaveResponseModel({required this.remark, required this.status, required this.message});

  factory CustomerContactSaveResponseModel.fromJson(Map<String, dynamic> json) => CustomerContactSaveResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: List<String>.from(json["message"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
    "status": status,
    "message": List<dynamic>.from(message.map((x) => x)),
  };
}
