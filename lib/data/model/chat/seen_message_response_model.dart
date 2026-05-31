import 'dart:convert';

SeenMessageResponseModel seenMessageResponseModelFromJson(String str) =>
    SeenMessageResponseModel.fromJson(json.decode(str));

String seenMessageResponseModelToJson(SeenMessageResponseModel data) => json.encode(data.toJson());

class SeenMessageResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  SeenMessageResponseModel({this.remark, this.status, this.message, this.data});

  factory SeenMessageResponseModel.fromJson(Map<String, dynamic> json) => SeenMessageResponseModel(
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
  final String? unseenMessageCount;

  Data({this.unseenMessageCount});

  factory Data.fromJson(Map<String, dynamic> json) => Data(unseenMessageCount: json["unseenMessageCount"]?.toString());

  Map<String, dynamic> toJson() => {"unseenMessageCount": unseenMessageCount};
}
