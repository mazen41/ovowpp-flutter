import 'dart:convert';

import 'package:ovowpp/data/model/user/user.dart';

class DashboardResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  DashboardResponseModel({this.remark, this.status, this.message, this.data});

  factory DashboardResponseModel.fromRawJson(String str) => DashboardResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) => DashboardResponseModel(
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
  DashboardExtraData? widget;
  String? profilePath;

  Data({this.user, this.widget, this.profilePath});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    widget: json["widget"] == null ? null : DashboardExtraData.fromJson(json["widget"]),
    profilePath: json["profilePath"],
  );

  Map<String, dynamic> toJson() => {"user": user?.toJson(), "widget": widget?.toJson(), "profilePath": profilePath};
}

class DashboardExtraData {
  String? activeCampaign;
  String? completedCampaign;
  String? totalMessage;
  String? sentMessage;
  String? contactCount;
  String? topContact;
  String? topContactMessage;
  String? chatCompletionRate;
  Subscription? subscription;
  String? walletBalance;
  List<String>? permissions;

  DashboardExtraData({
    this.activeCampaign,
    this.completedCampaign,
    this.totalMessage,
    this.sentMessage,
    this.contactCount,
    this.topContact,
    this.topContactMessage,
    this.chatCompletionRate,
    this.subscription,
    this.walletBalance,
    this.permissions,
  });

  factory DashboardExtraData.fromRawJson(String str) => DashboardExtraData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardExtraData.fromJson(Map<String, dynamic> json) => DashboardExtraData(
    activeCampaign: json["active_campaign"]?.toString(),
    completedCampaign: json["completed_campaign"]?.toString(),
    totalMessage: json["total_message"]?.toString(),
    sentMessage: json["sent_message"]?.toString(),
    contactCount: json["contact_count"]?.toString(),
    topContact: json["top_contact"]?.toString(),
    topContactMessage: json["top_contact_message"]?.toString(),
    chatCompletionRate: json["chat_completion_rate"]?.toString(),
    subscription: json["subscription"] == null ? null : Subscription.fromJson(json["subscription"]),
    walletBalance: json["wallet_balance"]?.toString(),
    permissions: json["permissions"] == null ? [] : List<String>.from(json["permissions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "active_campaign": activeCampaign,
    "completed_campaign": completedCampaign,
    "total_message": totalMessage,
    "sent_message": sentMessage,
    "contact_count": contactCount,
    "top_contact": topContact,
    "top_contact_message": topContactMessage,
    "chat_completion_rate": chatCompletionRate,
    "subscription": subscription?.toJson(),
    "wallet_balance": walletBalance,
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
  };
}

class Subscription {
  String? id;
  String? planId;
  String? userId;
  String? couponId;
  String? recurringType;
  String? amount;
  String? discountAmount;
  String? paymentMethod;
  String? gatewayMethodCode;
  String? autoRenewal;
  String? expiredAt;
  String? isSentExpiredNotify;
  String? isSentReminderNotify;
  String? createdAt;
  String? updatedAt;
  Plan? plan;

  Subscription({
    this.id,
    this.planId,
    this.userId,
    this.couponId,
    this.recurringType,
    this.amount,
    this.discountAmount,
    this.paymentMethod,
    this.gatewayMethodCode,
    this.autoRenewal,
    this.expiredAt,
    this.isSentExpiredNotify,
    this.isSentReminderNotify,
    this.createdAt,
    this.updatedAt,
    this.plan,
  });

  factory Subscription.fromRawJson(String str) => Subscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json["id"]?.toString(),
    planId: json["plan_id"]?.toString(),
    userId: json["user_id"]?.toString(),
    couponId: json["coupon_id"]?.toString(),
    recurringType: json["recurring_type"]?.toString(),
    amount: json["amount"]?.toString(),
    discountAmount: json["discount_amount"]?.toString(),
    paymentMethod: json["payment_method"]?.toString(),
    gatewayMethodCode: json["gateway_method_code"]?.toString(),
    autoRenewal: json["auto_renewal"]?.toString(),
    expiredAt: json["expired_at"]?.toString(),
    isSentExpiredNotify: json["is_sent_expired_notify"]?.toString(),
    isSentReminderNotify: json["is_sent_reminder_notify"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan_id": planId,
    "user_id": userId,
    "coupon_id": couponId,
    "recurring_type": recurringType,
    "amount": amount,
    "discount_amount": discountAmount,
    "payment_method": paymentMethod,
    "gateway_method_code": gatewayMethodCode,
    "auto_renewal": autoRenewal,
    "expired_at": expiredAt,
    "is_sent_expired_notify": isSentExpiredNotify,
    "is_sent_reminder_notify": isSentReminderNotify,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "plan": plan?.toJson(),
  };
}

class Plan {
  String? id;
  String? name;
  String? description;
  String? monthlyPrice;
  String? yearlyPrice;
  String? accountLimit;
  String? contactLimit;
  String? templateLimit;
  String? welcomeMessage;
  String? aiAssistance;
  String? interactiveMessage;
  String? ecommerceAvailable;
  String? chatbotLimit;
  String? campaignLimit;
  String? flowLimit;
  String? shortLinkLimit;
  String? floaterLimit;
  String? agentLimit;
  String? status;
  String? isPopular;
  String? apiAvailable;
  String? createdAt;
  String? updatedAt;

  Plan({
    this.id,
    this.name,
    this.description,
    this.monthlyPrice,
    this.yearlyPrice,
    this.accountLimit,
    this.contactLimit,
    this.templateLimit,
    this.welcomeMessage,
    this.aiAssistance,
    this.interactiveMessage,
    this.ecommerceAvailable,
    this.chatbotLimit,
    this.campaignLimit,
    this.flowLimit,
    this.shortLinkLimit,
    this.floaterLimit,
    this.agentLimit,
    this.status,
    this.isPopular,
    this.apiAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory Plan.fromRawJson(String str) => Plan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["id"]?.toString(),
    name: json["name"]?.toString(),
    description: json["description"]?.toString(),
    monthlyPrice: json["monthly_price"]?.toString(),
    yearlyPrice: json["yearly_price"]?.toString(),
    accountLimit: json["account_limit"]?.toString(),
    contactLimit: json["contact_limit"]?.toString(),
    templateLimit: json["template_limit"]?.toString(),
    welcomeMessage: json["welcome_message"]?.toString(),
    aiAssistance: json["ai_assistance"]?.toString(),
    interactiveMessage: json["interactive_message"]?.toString(),
    ecommerceAvailable: json["ecommerce_available"]?.toString(),
    chatbotLimit: json["chatbot_limit"]?.toString(),
    campaignLimit: json["campaign_limit"]?.toString(),
    flowLimit: json["flow_limit"]?.toString(),
    shortLinkLimit: json["short_link_limit"]?.toString(),
    floaterLimit: json["floater_limit"]?.toString(),
    agentLimit: json["agent_limit"]?.toString(),
    status: json["status"]?.toString(),
    isPopular: json["is_popular"]?.toString(),
    apiAvailable: json["api_available"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "monthly_price": monthlyPrice,
    "yearly_price": yearlyPrice,
    "account_limit": accountLimit,
    "contact_limit": contactLimit,
    "template_limit": templateLimit,
    "welcome_message": welcomeMessage,
    "ai_assistance": aiAssistance,
    "interactive_message": interactiveMessage,
    "ecommerce_available": ecommerceAvailable,
    "chatbot_limit": chatbotLimit,
    "campaign_limit": campaignLimit,
    "flow_limit": flowLimit,
    "short_link_limit": shortLinkLimit,
    "floater_limit": floaterLimit,
    "agent_limit": agentLimit,
    "status": status,
    "is_popular": isPopular,
    "api_available": apiAvailable,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
