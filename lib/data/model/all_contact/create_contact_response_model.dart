// To parse this JSON data, do
//
//     final createContactResponseModel = createContactResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';

CreateContactResponseModel createContactResponseModelFromJson(String str) =>
    CreateContactResponseModel.fromJson(json.decode(str));

String createContactResponseModelToJson(CreateContactResponseModel data) => json.encode(data.toJson());

class CreateContactResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  CreateContactResponseModel({this.remark, this.status, this.message, this.data});

  factory CreateContactResponseModel.fromJson(Map<String, dynamic> json) => CreateContactResponseModel(
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
  final Conversation? conversation;

  Data({this.conversation});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(conversation: json["conversation"] == null ? null : Conversation.fromJson(json["conversation"]));

  Map<String, dynamic> toJson() => {"conversation": conversation?.toJson()};
}
