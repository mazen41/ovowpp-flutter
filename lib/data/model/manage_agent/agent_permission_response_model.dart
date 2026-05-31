import 'dart:convert';

AgentPermissionResponseModel agentPermissionResponseModelFromJson(String str) =>
    AgentPermissionResponseModel.fromJson(json.decode(str));

String agentPermissionResponseModelToJson(AgentPermissionResponseModel data) => json.encode(data.toJson());

class AgentPermissionResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  AgentPermissionResponseModel({this.remark, this.status, this.message, this.data});

  factory AgentPermissionResponseModel.fromJson(Map<String, dynamic> json) => AgentPermissionResponseModel(
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
  Agent? agent;
  List<Permission>? permissions;
  List<Permission>? existingPermissions;

  Data({this.agent, this.permissions, this.existingPermissions});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    agent: json["agent"] == null ? null : Agent.fromJson(json["agent"]),
    permissions: json["permissions"] == null
        ? []
        : List<Permission>.from(json["permissions"]!.map((x) => Permission.fromJson(x))),
    existingPermissions: json["existing_permissions"] == null
        ? []
        : List<Permission>.from(json["existing_permissions"]!.map((x) => Permission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "agent": agent?.toJson(),
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toJson())),
    "existing_permissions": existingPermissions == null
        ? []
        : List<dynamic>.from(existingPermissions!.map((x) => x.toJson())),
  };
}

class Agent {
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
  List<Permission>? agentPermissions;

  Agent({
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
    this.agentPermissions,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
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
    agentPermissions: json["agent_permissions"] == null
        ? []
        : List<Permission>.from(json["agent_permissions"]!.map((x) => Permission.fromJson(x))),
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
    "agent_permissions": agentPermissions == null ? [] : List<dynamic>.from(agentPermissions!.map((x) => x.toJson())),
  };
}

class Permission {
  String? id;
  String? name;
  GuardName? guardName;
  String? groupName;
  DateTime? createdAt;
  DateTime? updatedAt;
  Pivot? pivot;

  Permission({this.id, this.name, this.guardName, this.groupName, this.createdAt, this.updatedAt, this.pivot});

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    id: json["id"]?.toString(),
    name: json["name"]?.toString(),
    guardName: guardNameValues.map[json["guard_name"]]!,
    groupName: json["group_name"]?.toString(),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "guard_name": guardNameValues.reverse[guardName],
    "group_name": groupName,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "pivot": pivot?.toJson(),
  };
}

enum GuardName { WEB }

final guardNameValues = EnumValues({"web": GuardName.WEB});

class Pivot {
  int? agentId;
  int? agentPermissionId;

  Pivot({this.agentId, this.agentPermissionId});

  factory Pivot.fromJson(Map<String, dynamic> json) =>
      Pivot(agentId: json["agent_id"], agentPermissionId: json["agent_permission_id"]);

  Map<String, dynamic> toJson() => {"agent_id": agentId, "agent_permission_id": agentPermissionId};
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
