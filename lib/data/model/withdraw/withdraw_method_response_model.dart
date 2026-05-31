import 'dart:convert';

class WithdrawMethodResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  WithdrawMethodResponseModel({this.remark, this.status, this.message, this.data});

  factory WithdrawMethodResponseModel.fromRawJson(String str) => WithdrawMethodResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WithdrawMethodResponseModel.fromJson(Map<String, dynamic> json) => WithdrawMethodResponseModel(
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
  List<WithdrawMethod>? withdrawMethods;

  Data({this.withdrawMethods});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    withdrawMethods: json["withdraw_methods"] == null
        ? []
        : List<WithdrawMethod>.from(json["withdraw_methods"]!.map((x) => WithdrawMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "withdraw_methods": withdrawMethods == null ? [] : List<dynamic>.from(withdrawMethods!.map((x) => x.toJson())),
  };
}

class WithdrawMethod {
  int? id;
  int? formId;
  String? name;
  String? image;
  String? minLimit;
  String? maxLimit;
  String? fixedCharge;
  String? rate;
  String? percentCharge;
  String? currency;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;

  WithdrawMethod({
    this.id,
    this.formId,
    this.name,
    this.image,
    this.minLimit,
    this.maxLimit,
    this.fixedCharge,
    this.rate,
    this.percentCharge,
    this.currency,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawMethod.fromRawJson(String str) => WithdrawMethod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WithdrawMethod.fromJson(Map<String, dynamic> json) => WithdrawMethod(
    id: json["id"],
    formId: json["form_id"],
    name: json["name"],
    image: json["image"],
    minLimit: json["min_limit"],
    maxLimit: json["max_limit"],
    fixedCharge: json["fixed_charge"],
    rate: json["rate"],
    percentCharge: json["percent_charge"],
    currency: json["currency"],
    description: json["description"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "form_id": formId,
    "name": name,
    "image": image,
    "min_limit": minLimit,
    "max_limit": maxLimit,
    "fixed_charge": fixedCharge,
    "rate": rate,
    "percent_charge": percentCharge,
    "currency": currency,
    "description": description,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
