// To parse this JSON data, do
//
//     final uploadCsvResponseModel = uploadCsvResponseModelFromJson(jsonString);

import 'dart:convert';

UploadCsvResponseModel uploadCsvResponseModelFromJson(String str) => UploadCsvResponseModel.fromJson(json.decode(str));

String uploadCsvResponseModelToJson(UploadCsvResponseModel data) => json.encode(data.toJson());

class UploadCsvResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;

  UploadCsvResponseModel({this.remark, this.status, this.message});

  factory UploadCsvResponseModel.fromJson(Map<String, dynamic> json) => UploadCsvResponseModel(
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
