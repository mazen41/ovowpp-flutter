// To parse this JSON data, do
//
//     final agentListResponseModel = agentListResponseModelFromJson(jsonString);

import 'dart:convert';

AgentListResponseModel agentListResponseModelFromJson(String str) => AgentListResponseModel.fromJson(json.decode(str));

class AgentListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  AgentListResponseModel({this.remark, this.status, this.message, this.data});

  factory AgentListResponseModel.fromJson(Map<String, dynamic> json) => AgentListResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  Agents? agents;
  String? profilePath;

  Data({this.agents, this.profilePath});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(agents: json["agents"] == null ? null : Agents.fromJson(json["agents"]), profilePath: json["profile_path"]);
}

class Agents {
  List<AgentData>? data;
  dynamic nextPageUrl;

  Agents({this.data, this.nextPageUrl});

  factory Agents.fromJson(Map<String, dynamic> json) => Agents(
    data: json["data"] == null ? [] : List<AgentData>.from(json["data"]!.map((x) => AgentData.fromJson(x))),
    nextPageUrl: json["next_page_url"],
  );
}

class AgentData {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? image;
  String? dialCode;
  String? mobile;
  String? parentId;
  String? isAgent;
  String? refBy;
  String? countryName;
  String? subscriptionId;
  String? availableContact;
  String? availableContactList;
  String? availableTemplate;
  String? whatsappAccountsLimit;
  String? monthlyMessageLimit;
  String? availableChatbot;
  String? campaignAvailable;
  String? countryCode;
  String? city;
  String? state;
  String? zip;
  String? address;
  String? status;
  String? kycRejectionReason;
  String? kv;
  String? ev;
  String? sv;
  String? profileComplete;
  String? verCodeSendAt;
  String? ts;
  String? tv;
  String? tsc;
  String? banReason;
  String? provider;
  String? providerId;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  AgentData({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.image,
    this.dialCode,
    this.mobile,
    this.parentId,
    this.isAgent,
    this.refBy,
    this.countryName,
    this.subscriptionId,
    this.availableContact,
    this.availableContactList,
    this.availableTemplate,
    this.whatsappAccountsLimit,
    this.monthlyMessageLimit,
    this.availableChatbot,
    this.campaignAvailable,
    this.countryCode,
    this.city,
    this.state,
    this.zip,
    this.address,
    this.status,
    this.kycRejectionReason,
    this.kv,
    this.ev,
    this.sv,
    this.profileComplete,
    this.verCodeSendAt,
    this.ts,
    this.tv,
    this.tsc,
    this.banReason,
    this.provider,
    this.providerId,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory AgentData.fromJson(Map<String, dynamic> json) => AgentData(
    id: json["id"],
    firstname: json["firstname"]?.toString(),
    lastname: json["lastname"]?.toString(),
    username: json["username"]?.toString(),
    email: json["email"]?.toString(),
    image: json["image"]?.toString(),
    dialCode: json["dial_code"]?.toString(),
    mobile: json["mobile"]?.toString(),
    parentId: json["parent_id"]?.toString(),
    isAgent: json["is_agent"]?.toString(),
    refBy: json["ref_by"]?.toString(),
    countryName: json["country_name"]?.toString(),
    subscriptionId: json["subscription_id"]?.toString(),
    availableContact: json["available_contact"]?.toString(),
    availableContactList: json["available_contact_list"]?.toString(),
    availableTemplate: json["available_template"]?.toString(),
    whatsappAccountsLimit: json["whatsapp_accounts_limit"]?.toString(),
    monthlyMessageLimit: json["monthly_message_limit"]?.toString(),
    availableChatbot: json["available_chatbot"]?.toString(),
    campaignAvailable: json["campaign_available"]?.toString(),
    countryCode: json["country_code"]?.toString(),
    city: json["city"]?.toString(),
    state: json["state"]?.toString(),
    zip: json["zip"]?.toString(),
    address: json["address"]?.toString(),
    status: json["status"]?.toString(),
    kycRejectionReason: json["kyc_rejection_reason"]?.toString(),
    kv: json["kv"]?.toString(),
    ev: json["ev"]?.toString(),
    sv: json["sv"]?.toString(),
    profileComplete: json["profile_complete"]?.toString(),
    verCodeSendAt: json["ver_code_send_at"]?.toString(),
    ts: json["ts"]?.toString(),
    tv: json["tv"]?.toString(),
    tsc: json["tsc"]?.toString(),
    banReason: json["ban_reason"]?.toString(),
    provider: json["provider"]?.toString(),
    providerId: json["provider_id"]?.toString(),
    isDeleted: json["is_deleted"]?.toString(),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "email": email,
    "image": image,
    "dial_code": dialCode,
    "mobile": mobile,
    "parent_id": parentId,
    "is_agent": isAgent,
    "ref_by": refBy,
    "country_name": countryName,
    "subscription_id": subscriptionId,
    "available_contact": availableContact,
    "available_contact_list": availableContactList,
    "available_template": availableTemplate,
    "whatsapp_accounts_limit": whatsappAccountsLimit,
    "monthly_message_limit": monthlyMessageLimit,
    "available_chatbot": availableChatbot,
    "campaign_available": campaignAvailable,
    "country_code": countryCode,
    "city": city,
    "state": state,
    "zip": zip,
    "address": address,
    "status": status,
    "kyc_rejection_reason": kycRejectionReason,
    "kv": kv,
    "ev": ev,
    "sv": sv,
    "profile_complete": profileComplete,
    "ver_code_send_at": verCodeSendAt,
    "ts": ts,
    "tv": tv,
    "tsc": tsc,
    "ban_reason": banReason,
    "provider": provider,
    "provider_id": providerId,
    "is_deleted": isDeleted,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {"url": url, "label": label, "active": active};
}
