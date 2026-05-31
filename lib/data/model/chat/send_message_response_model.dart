import 'dart:convert';
import 'chat_data_response_model.dart';

SentMessageResponseModel sentMessageResponseModelFromJson(String str) =>
    SentMessageResponseModel.fromJson(json.decode(str));

String sentMessageResponseModelToJson(SentMessageResponseModel data) => json.encode(data.toJson());

class SentMessageResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  SentMessageResponseModel({this.remark, this.status, this.message, this.data});

  factory SentMessageResponseModel.fromJson(Map<String, dynamic> json) => SentMessageResponseModel(
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
  MessagesData? message;

  Data({this.message});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(message: json["message"] == null ? null : MessagesData.fromJson(json["message"]));

  Map<String, dynamic> toJson() => {"message": message?.toJson()};
}
