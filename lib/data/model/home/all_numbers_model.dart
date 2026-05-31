// To parse this JSON data, do
//
//     final allNumbersResponseModel = allNumbersResponseModelFromJson(jsonString);

import 'dart:convert';

AllNumbersResponseModel allNumbersResponseModelFromJson(String str) =>
    AllNumbersResponseModel.fromJson(json.decode(str));

String allNumbersResponseModelToJson(AllNumbersResponseModel data) => json.encode(data.toJson());

class AllNumbersResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  AllNumbersResponseModel({this.remark, this.status, this.message, this.data});

  factory AllNumbersResponseModel.fromJson(Map<String, dynamic> json) => AllNumbersResponseModel(
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
  final List<WhatsappAccount>? whatsappAccounts;

  Data({this.whatsappAccounts});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    whatsappAccounts: json["whatsapp_accounts"] == null
        ? []
        : List<WhatsappAccount>.from(json["whatsapp_accounts"]!.map((x) => WhatsappAccount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "whatsapp_accounts": whatsappAccounts == null ? [] : List<dynamic>.from(whatsappAccounts!.map((x) => x.toJson())),
  };
}

class WhatsappAccount {
  final String? id;
  final String? userId;
  final String? businessName;
  final String? whatsappBusinessAccountId;
  final String? phoneNumber;
  final String? phoneNumberId;
  final String? accessToken;
  final String? codeVerificationStatus;
  final String? isDefault;
  final String? createdAt;
  final String? updatedAt;

  WhatsappAccount({
    this.id,
    this.userId,
    this.businessName,
    this.whatsappBusinessAccountId,
    this.phoneNumber,
    this.phoneNumberId,
    this.accessToken,
    this.codeVerificationStatus,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory WhatsappAccount.fromJson(Map<String, dynamic> json) => WhatsappAccount(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    businessName: json["business_name"]?.toString(),
    whatsappBusinessAccountId: json["whatsapp_business_account_id"]?.toString(),
    phoneNumber: json["phone_number"]?.toString(),
    phoneNumberId: json["phone_number_id"]?.toString(),
    accessToken: json["access_token"]?.toString(),
    codeVerificationStatus: json["code_verification_status"]?.toString(),
    isDefault: json["is_default"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "business_name": businessName,
    "whatsapp_business_account_id": whatsappBusinessAccountId,
    "phone_number": phoneNumber,
    "phone_number_id": phoneNumberId,
    "access_token": accessToken,
    "code_verification_status": codeVerificationStatus,
    "is_default": isDefault,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
