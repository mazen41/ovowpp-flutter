import 'dart:convert';

class CampaignModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CampaignModel({this.remark, this.status, this.message, this.data});

  factory CampaignModel.fromRawJson(String str) => CampaignModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CampaignModel.fromJson(Map<String, dynamic> json) => CampaignModel(
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
  Campaigns? campaigns;

  Data({this.campaigns});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(campaigns: json["campaigns"] == null ? null : Campaigns.fromJson(json["campaigns"]));

  Map<String, dynamic> toJson() => {"campaigns": campaigns?.toJson()};
}

class Campaigns {
  int? currentPage;
  List<CampaignsDatum>? data;

  String? nextPageUrl;

  Campaigns({this.currentPage, this.data, this.nextPageUrl});

  factory Campaigns.fromRawJson(String str) => Campaigns.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Campaigns.fromJson(Map<String, dynamic> json) => Campaigns(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<CampaignsDatum>.from(json["data"]!.map((x) => CampaignsDatum.fromJson(x))),
    nextPageUrl: json["next_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
  };
}

class CampaignsDatum {
  int? id;
  String? whatsappAccountId;
  String? title;
  String? userId;
  String? templateId;
  List<dynamic>? templateHeaderParams;
  List<dynamic>? templateBodyParams;
  String? sendAt;
  String? et;
  String? status;
  String? totalMessage;
  String? totalSend;
  String? totalSuccess;
  String? totalFailed;
  String? createdAt;
  String? updatedAt;

  CampaignsDatum({
    this.id,
    this.whatsappAccountId,
    this.title,
    this.userId,
    this.templateId,
    this.templateHeaderParams,
    this.templateBodyParams,
    this.sendAt,
    this.et,
    this.status,
    this.totalMessage,
    this.totalSend,
    this.totalSuccess,
    this.totalFailed,
    this.createdAt,
    this.updatedAt,
  });

  factory CampaignsDatum.fromRawJson(String str) => CampaignsDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CampaignsDatum.fromJson(Map<String, dynamic> json) => CampaignsDatum(
    id: json["id"],
    whatsappAccountId: json["whatsapp_account_id"]?.toString(),
    title: json["title"]?.toString(),
    userId: json["user_id"]?.toString(),
    templateId: json["template_id"]?.toString(),
    templateHeaderParams: json["template_header_params"] == null
        ? []
        : List<dynamic>.from(json["template_header_params"]!.map((x) => x)),
    templateBodyParams: json["template_body_params"] == null
        ? []
        : List<dynamic>.from(json["template_body_params"]!.map((x) => x)),
    sendAt: json["send_at"]?.toString(),
    et: json["et"]?.toString(),
    status: json["status"]?.toString(),
    totalMessage: json["total_message"]?.toString(),
    totalSend: json["total_send"]?.toString(),
    totalSuccess: json["total_success"]?.toString(),
    totalFailed: json["total_failed"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "whatsapp_account_id": whatsappAccountId,
    "title": title,
    "user_id": userId,
    "template_id": templateId,
    "template_header_params": templateHeaderParams == null
        ? []
        : List<dynamic>.from(templateHeaderParams!.map((x) => x)),
    "template_body_params": templateBodyParams == null ? [] : List<dynamic>.from(templateBodyParams!.map((x) => x)),
    "send_at": sendAt,
    "et": et,
    "status": status,
    "total_message": totalMessage,
    "total_send": totalSend,
    "total_success": totalSuccess,
    "total_failed": totalFailed,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
