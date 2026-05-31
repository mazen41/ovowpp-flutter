// To parse this JSON data, do
//
//     final homeResponseModel = homeResponseModelFromJson(jsonString);

import 'dart:convert';

import '../user/user.dart';

HomeResponseModel homeResponseModelFromJson(String str) => HomeResponseModel.fromJson(json.decode(str));

String homeResponseModelToJson(HomeResponseModel data) => json.encode(data.toJson());

class HomeResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  HomeResponseModel({this.remark, this.status, this.message, this.data});

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) => HomeResponseModel(
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
  User? user;
  String? profilePath;

  Data({this.user, this.profilePath});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profilePath: json["profilePath"]?.toString(),
  );

  Map<String, dynamic> toJson() => {"user": user?.toJson(), "profilePath": profilePath};
}
