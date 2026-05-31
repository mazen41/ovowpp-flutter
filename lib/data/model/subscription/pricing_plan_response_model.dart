import 'dart:convert';

import 'package:ovowpp/data/model/user/user.dart';

String? _stringOrNull(dynamic value) {
  if (value == null) return null;
  final normalized = value.toString().trim();
  if (normalized.isEmpty || normalized.toLowerCase() == 'null') return null;
  return normalized;
}

PricingPlanResponseModel pricingPlanResponseModelFromJson(String str) =>
    PricingPlanResponseModel.fromJson(json.decode(str));

String pricingPlanResponseModelToJson(PricingPlanResponseModel data) => json.encode(data.toJson());

class PricingPlanResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  PricingPlanResponseModel({this.remark, this.status, this.message, this.data});

  factory PricingPlanResponseModel.fromJson(Map<String, dynamic> json) => PricingPlanResponseModel(
    remark: _stringOrNull(json["remark"]),
    status: _stringOrNull(json["status"]),
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x.toString())),
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
  final List<PricingPlan>? pricingPlans;
  final User? user;
  final ActivePlan? activePlan;
  final PurchaseData? purchaseData;

  Data({this.pricingPlans, this.user, this.activePlan, this.purchaseData});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pricingPlans: json["pricing_plans"] == null
        ? []
        : List<PricingPlan>.from(json["pricing_plans"]!.map((x) => PricingPlan.fromJson(x))),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    activePlan: json["active_plan"] == null ? null : ActivePlan.fromJson(json["active_plan"]),
    purchaseData: json["purchase_data"] == null ? null : PurchaseData.fromJson(json["purchase_data"]),
  );

  Map<String, dynamic> toJson() => {
    "pricing_plans": pricingPlans == null ? [] : List<dynamic>.from(pricingPlans!.map((x) => x.toJson())),
    "user": user?.toJson(),
    "active_plan": activePlan?.toJson(),
    "purchase_data": purchaseData?.toJson(),
  };
}

class ActivePlan {
  final String? id;
  final String? name;
  final String? description;
  final String? monthlyPrice;
  final String? yearlyPrice;
  final String? status;
  final String? billingCycle;
  final String? expiredAt;
  final Map<String, dynamic> rawData;

  ActivePlan({
    this.id,
    this.name,
    this.description,
    this.monthlyPrice,
    this.yearlyPrice,
    this.status,
    this.billingCycle,
    this.expiredAt,
    required this.rawData,
  });

  factory ActivePlan.fromJson(Map<String, dynamic> json) => ActivePlan(
    id: _stringOrNull(json["id"]),
    name: _stringOrNull(json["name"]),
    description: _stringOrNull(json["description"]),
    monthlyPrice: _stringOrNull(json["monthly_price"]),
    yearlyPrice: _stringOrNull(json["yearly_price"]),
    status: _stringOrNull(json["status"]),
    billingCycle:
        _stringOrNull(json["billing_cycle"]) ??
        _stringOrNull(json["billing_type"]) ??
        _stringOrNull(json["recurring_type"]) ??
        _stringOrNull(json["type"]),
    expiredAt:
        _stringOrNull(json["expired_at"]) ??
        _stringOrNull(json["expiry_date"]) ??
        _stringOrNull(json["plan_expired_at"]),
    rawData: Map<String, dynamic>.from(json),
  );

  Map<String, dynamic> toJson() => rawData;
}

class PurchaseData {
  final String? id;
  final String? amount;
  final String? total;
  final String? status;
  final String? billingCycle;
  final String? purchaseAt;
  final String? createdAt;
  final String? activeAt;
  final String? expiredAt;
  final String? nextBillingAt;
  final String? nextInvoiceAt;
  final Map<String, dynamic> rawData;

  PurchaseData({
    this.id,
    this.amount,
    this.total,
    this.status,
    this.billingCycle,
    this.purchaseAt,
    this.createdAt,
    this.activeAt,
    this.expiredAt,
    this.nextBillingAt,
    this.nextInvoiceAt,
    required this.rawData,
  });

  factory PurchaseData.fromJson(Map<String, dynamic> json) => PurchaseData(
    id: _stringOrNull(json["id"]),
    amount: _stringOrNull(json["amount"]) ?? _stringOrNull(json["price"]) ?? _stringOrNull(json["total"]),
    total: _stringOrNull(json["total"]) ?? _stringOrNull(json["amount"]) ?? _stringOrNull(json["price"]),
    status: _stringOrNull(json["status"]),
    billingCycle:
        _stringOrNull(json["billing_cycle"]) ??
        _stringOrNull(json["billing_type"]) ??
        _stringOrNull(json["recurring_type"]) ??
        _stringOrNull(json["type"]),
    purchaseAt: _stringOrNull(json["purchase_at"]) ?? _stringOrNull(json["created_at"]),
    createdAt: _stringOrNull(json["created_at"]) ?? _stringOrNull(json["purchase_at"]),
    activeAt: _stringOrNull(json["active_at"]),
    expiredAt: _stringOrNull(json["expired_at"]) ?? _stringOrNull(json["expiry_date"]),
    nextBillingAt: _stringOrNull(json["next_billing_at"]) ?? _stringOrNull(json["renew_at"]),
    nextInvoiceAt:
        _stringOrNull(json["next_invoice_at"]) ??
        _stringOrNull(json["next_billing_at"]) ??
        _stringOrNull(json["renew_at"]),
    rawData: Map<String, dynamic>.from(json),
  );

  Map<String, dynamic> toJson() => rawData;
}

class PricingPlan {
  final String? id;
  final String? name;
  final String? description;
  final String? monthlyPrice;
  final String? yearlyPrice;
  final String? accountLimit;
  final String? contactLimit;
  final String? templateLimit;
  final String? welcomeMessage;
  final String? aiAssistance;
  final String? interactiveMessage;
  final String? ecommerceAvailable;
  final String? chatbotLimit;
  final String? campaignLimit;
  final String? flowLimit;
  final String? shortLinkLimit;
  final String? floaterLimit;
  final String? agentLimit;
  final String? status;
  final String? isPopular;
  final String? apiAvailable;
  final String? createdAt;
  final String? updatedAt;

  PricingPlan({
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

  factory PricingPlan.fromJson(Map<String, dynamic> json) => PricingPlan(
    id: _stringOrNull(json["id"]),
    name: _stringOrNull(json["name"]),
    description: _stringOrNull(json["description"]),
    monthlyPrice: _stringOrNull(json["monthly_price"]),
    yearlyPrice: _stringOrNull(json["yearly_price"]),
    accountLimit: _stringOrNull(json["account_limit"]),
    contactLimit: _stringOrNull(json["contact_limit"]),
    templateLimit: _stringOrNull(json["template_limit"]),
    welcomeMessage: _stringOrNull(json["welcome_message"]),
    aiAssistance: _stringOrNull(json["ai_assistance"]),
    interactiveMessage: _stringOrNull(json["interactive_message"]),
    ecommerceAvailable: _stringOrNull(json["ecommerce_available"]),
    chatbotLimit: _stringOrNull(json["chatbot_limit"]),
    campaignLimit: _stringOrNull(json["campaign_limit"]),
    flowLimit: _stringOrNull(json["flow_limit"]),
    shortLinkLimit: _stringOrNull(json["short_link_limit"]),
    floaterLimit: _stringOrNull(json["floater_limit"]),
    agentLimit: _stringOrNull(json["agent_limit"]),
    status: _stringOrNull(json["status"]),
    isPopular: _stringOrNull(json["is_popular"]),
    apiAvailable: _stringOrNull(json["api_available"]),
    createdAt: _stringOrNull(json["created_at"]),
    updatedAt: _stringOrNull(json["updated_at"]),
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
