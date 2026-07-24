import 'dart:convert';

class CreateCampaignModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CreateCampaignModel({this.remark, this.status, this.message, this.data});

  factory CreateCampaignModel.fromRawJson(String str) => CreateCampaignModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateCampaignModel.fromJson(Map<String, dynamic> json) => CreateCampaignModel(
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
  List<Template>? templates;
  List<WhatsappAccount>? whatsappAccounts;
  List<ContactList>? contactLists;
  List<ContactList>? contactTags;

  Data({this.templates, this.whatsappAccounts, this.contactLists, this.contactTags});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    templates: json["templates"] == null
        ? []
        : List<Template>.from(json["templates"]!.map((x) => Template.fromJson(x))),
    whatsappAccounts: json["whatsapp_accounts"] == null
        ? []
        : List<WhatsappAccount>.from(json["whatsapp_accounts"]!.map((x) => WhatsappAccount.fromJson(x))),
    contactLists: json["contact_lists"] == null
        ? []
        : List<ContactList>.from(json["contact_lists"]!.map((x) => ContactList.fromJson(x))),
    contactTags: json["contact_tags"] == null
        ? []
        : List<ContactList>.from(json["contact_tags"]!.map((x) => ContactList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "templates": templates == null ? [] : List<dynamic>.from(templates!.map((x) => x.toJson())),
    "whatsapp_accounts": whatsappAccounts == null ? [] : List<dynamic>.from(whatsappAccounts!.map((x) => x.toJson())),
    "contact_lists": contactLists == null ? [] : List<dynamic>.from(contactLists!.map((x) => x.toJson())),
    "contact_tags": contactTags == null ? [] : List<dynamic>.from(contactTags!.map((x) => x.toJson())),
  };
}

class ContactList {
  int? id;
  int? userId;
  String? name;
  String? createdAt;
  String? updatedAt;

  ContactList({this.id, this.userId, this.name, this.createdAt, this.updatedAt});

  factory ContactList.fromRawJson(String str) => ContactList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContactList.fromJson(Map<String, dynamic> json) => ContactList(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Template {
  int? id;
  String? userId;
  String? whatsappTemplateId;
  String? whatsappAccountId;
  String? name;
  Header? header;
  String? headerFormat;
  String? headerMedia;
  String? body;
  List<Button>? buttons;
  String? footer;
  String? addSecurityRecommendation;
  dynamic codeExpirationMinutes;
  String? categoryId;
  String? languageId;
  String? status;
  dynamic rejectedReason;
  String? createdAt;
  String? updatedAt;

  Template({
    this.id,
    this.userId,
    this.whatsappTemplateId,
    this.whatsappAccountId,
    this.name,
    this.header,
    this.headerFormat,
    this.headerMedia,
    this.body,
    this.buttons,
    this.footer,
    this.addSecurityRecommendation,
    this.codeExpirationMinutes,
    this.categoryId,
    this.languageId,
    this.status,
    this.rejectedReason,
    this.createdAt,
    this.updatedAt,
  });

  factory Template.fromRawJson(String str) => Template.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Template.fromJson(Map<String, dynamic> json) => Template(
    id: json["id"],
    userId: json["user_id"]?.toString(),
    whatsappTemplateId: json["whatsapp_template_id"]?.toString(),
    whatsappAccountId: json["whatsapp_account_id"]?.toString(),
    name: json["name"]?.toString(),
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    headerFormat: json["header_format"],
    headerMedia: json["header_media"],
    body: json["body"],
    buttons: json["buttons"] == null ? [] : List<Button>.from(json["buttons"]!.map((x) => Button.fromJson(x))),
    footer: json["footer"],
    addSecurityRecommendation: json["add_security_recommendation"]?.toString(),
    codeExpirationMinutes: json["code_expiration_minutes"],
    categoryId: json["category_id"]?.toString(),
    languageId: json["language_id"]?.toString(),
    status: json["status"]?.toString(),
    rejectedReason: json["rejected_reason"],
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "whatsapp_template_id": whatsappTemplateId,
    "whatsapp_account_id": whatsappAccountId,
    "name": name,
    "header": header?.toJson(),
    "header_format": headerFormat,
    "header_media": headerMedia,
    "body": body,
    "buttons": buttons == null ? [] : List<dynamic>.from(buttons!.map((x) => x.toJson())),
    "footer": footer,
    "add_security_recommendation": addSecurityRecommendation,
    "code_expiration_minutes": codeExpirationMinutes,
    "category_id": categoryId,
    "language_id": languageId,
    "status": status,
    "rejected_reason": rejectedReason,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Button {
  String? type;
  String? text;
  String? phoneNumber;
  String? url;

  Button({this.type, this.text, this.phoneNumber, this.url});

  factory Button.fromRawJson(String str) => Button.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Button.fromJson(Map<String, dynamic> json) =>
      Button(type: json["type"], text: json["text"], phoneNumber: json["phone_number"], url: json["url"]);

  Map<String, dynamic> toJson() => {"type": type, "text": text, "phone_number": phoneNumber, "url": url};
}

class Header {
  String? handle;

  Header({this.handle});

  factory Header.fromRawJson(String str) => Header.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Header.fromJson(Map<String, dynamic> json) => Header(handle: json["handle"]);

  Map<String, dynamic> toJson() => {"handle": handle};
}

class WhatsappAccount {
  int? id;
  String? userId;
  String? businessName;
  String? whatsappBusinessAccountId;
  String? phoneNumber;
  String? phoneNumberId;
  String? accessToken;
  String? codeVerificationStatus;
  String? metaAppId;
  String? isDefault;
  String? createdAt;
  String? updatedAt;

  WhatsappAccount({
    this.id,
    this.userId,
    this.businessName,
    this.whatsappBusinessAccountId,
    this.phoneNumber,
    this.phoneNumberId,
    this.accessToken,
    this.codeVerificationStatus,
    this.metaAppId,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory WhatsappAccount.fromRawJson(String str) => WhatsappAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WhatsappAccount.fromJson(Map<String, dynamic> json) => WhatsappAccount(
    id: json["id"],
    userId: json["user_id"]?.toString(),
    businessName: json["business_name"]?.toString(),
    whatsappBusinessAccountId: json["whatsapp_business_account_id"]?.toString(),
    phoneNumber: json["phone_number"]?.toString(),
    phoneNumberId: json["phone_number_id"]?.toString(),
    accessToken: json["access_token"]?.toString(),
    codeVerificationStatus: json["code_verification_status"]?.toString(),
    metaAppId: json["meta_app_id"]?.toString(),
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
    "meta_app_id": metaAppId,
    "is_default": isDefault,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
