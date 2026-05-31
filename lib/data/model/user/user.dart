class User {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? image;
  String? dialCode;
  String? mobile;
  String? refBy;
  String? countryName;
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
  String? en;
  String? sn;
  String? pn;
  String? banReason;
  String? provider;
  String? providerId;
  String? parentId;
  String? isAgent;
  String? planId;
  String? accountLimit;
  String? contactLimit;
  String? templateLimit;
  String? welcomeMessage;
  String? aiAssistance;
  String? ctaUrlMessage;
  String? chatbotLimit;
  String? campaignLimit;
  String? shortLinkLimit;
  String? floaterLimit;
  String? agentLimit;
  String? planExpiredAt;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;
  User? parent;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.image,
    this.dialCode,
    this.mobile,
    this.refBy,
    this.countryName,
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
    this.en,
    this.sn,
    this.pn,
    this.banReason,
    this.provider,
    this.providerId,
    this.parentId,
    this.isAgent,
    this.planId,
    this.accountLimit,
    this.contactLimit,
    this.templateLimit,
    this.welcomeMessage,
    this.aiAssistance,
    this.ctaUrlMessage,
    this.chatbotLimit,
    this.campaignLimit,
    this.shortLinkLimit,
    this.floaterLimit,
    this.agentLimit,
    this.planExpiredAt,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.parent,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstname: json["firstname"]?.toString(),
    lastname: json["lastname"]?.toString(),
    username: json["username"]?.toString(),
    email: json["email"]?.toString(),
    image: json["image"]?.toString(),
    dialCode: json["dial_code"]?.toString(),
    mobile: json["mobile"]?.toString(),
    refBy: json["ref_by"]?.toString(),
    countryName: json["country_name"]?.toString(),
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
    en: json["en"]?.toString(),
    sn: json["sn"]?.toString(),
    pn: json["pn"]?.toString(),
    banReason: json["ban_reason"]?.toString(),
    provider: json["provider"]?.toString(),
    providerId: json["provider_id"]?.toString(),
    parentId: json["parent_id"]?.toString(),
    isAgent: json["is_agent"]?.toString(),
    planId: json["plan_id"]?.toString(),
    accountLimit: json["account_limit"]?.toString(),
    contactLimit: json["contact_limit"]?.toString(),
    templateLimit: json["template_limit"]?.toString(),
    welcomeMessage: json["welcome_message"]?.toString(),
    aiAssistance: json["ai_assistance"]?.toString(),
    ctaUrlMessage: json["cta_url_message"]?.toString(),
    chatbotLimit: json["chatbot_limit"]?.toString(),
    campaignLimit: json["campaign_limit"]?.toString(),
    shortLinkLimit: json["short_link_limit"]?.toString(),
    floaterLimit: json["floater_limit"]?.toString(),
    agentLimit: json["agent_limit"]?.toString(),
    planExpiredAt: json["plan_expired_at"]?.toString(),
    isDeleted: json["is_deleted"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    parent: json["parent"] == null ? null : User.fromJson(json["parent"]),
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
    "ref_by": refBy,
    "country_name": countryName,
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
    "en": en,
    "sn": sn,
    "pn": pn,
    "ban_reason": banReason,
    "provider": provider,
    "provider_id": providerId,
    "parent_id": parentId,
    "is_agent": isAgent,
    "plan_id": planId,
    "account_limit": accountLimit,
    "contact_limit": contactLimit,
    "template_limit": templateLimit,
    "welcome_message": welcomeMessage,
    "ai_assistance": aiAssistance,
    "cta_url_message": ctaUrlMessage,
    "chatbot_limit": chatbotLimit,
    "campaign_limit": campaignLimit,
    "short_link_limit": shortLinkLimit,
    "floater_limit": floaterLimit,
    "agent_limit": agentLimit,
    "plan_expired_at": planExpiredAt,
    "is_deleted": isDeleted,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "parent": parent?.toJson(),
  };
}
