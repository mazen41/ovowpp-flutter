import 'dart:convert';

SwitchNumbersResponseModel switchNumbersResponseModelFromJson(String str) =>
    SwitchNumbersResponseModel.fromJson(json.decode(str));

String switchNumbersResponseModelToJson(SwitchNumbersResponseModel data) => json.encode(data.toJson());

class SwitchNumbersResponseModel {
  String? remark;
  String? status;
  List<String>? message;

  SwitchNumbersResponseModel({this.remark, this.status, this.message});

  factory SwitchNumbersResponseModel.fromJson(Map<String, dynamic> json) => SwitchNumbersResponseModel(
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
