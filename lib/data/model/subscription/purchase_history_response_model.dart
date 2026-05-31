// To parse this JSON data, do
//
//     final purchaseHistoryResponseModel = purchaseHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovowpp/data/model/deposit/deposit_history_response_model.dart';

String? _stringOrNull(dynamic value) {
  if (value == null) return null;
  final normalized = value.toString().trim();
  if (normalized.isEmpty || normalized.toLowerCase() == 'null') return null;
  return normalized;
}

PurchaseHistoryResponseModel purchaseHistoryResponseModelFromJson(String str) =>
    PurchaseHistoryResponseModel.fromJson(json.decode(str));

String purchaseHistoryResponseModelToJson(PurchaseHistoryResponseModel data) => json.encode(data.toJson());

class PurchaseHistoryResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  PurchaseHistoryResponseModel({this.remark, this.status, this.message, this.data});

  factory PurchaseHistoryResponseModel.fromJson(Map<String, dynamic> json) => PurchaseHistoryResponseModel(
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
  final PurchaseHistories? purchaseHistories;

  Data({this.purchaseHistories});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    purchaseHistories: json["purchase_histories"] == null
        ? null
        : PurchaseHistories.fromJson(json["purchase_histories"]),
  );

  Map<String, dynamic> toJson() => {"purchase_histories": purchaseHistories?.toJson()};
}

class PurchaseHistories {
  final String? currentPage;
  final List<PurchaseHistoryData>? data;
  final String? firstPageUrl;
  final String? from;
  final String? lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? path;
  final String? perPage;
  final String? prevPageUrl;
  final String? to;
  final String? total;

  PurchaseHistories({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory PurchaseHistories.fromJson(Map<String, dynamic> json) => PurchaseHistories(
    currentPage: _stringOrNull(json["current_page"]),
    data: json["data"] == null
        ? []
        : List<PurchaseHistoryData>.from(json["data"]!.map((x) => PurchaseHistoryData.fromJson(x))),
    firstPageUrl: _stringOrNull(json["first_page_url"]),
    from: _stringOrNull(json["from"]),
    lastPage: _stringOrNull(json["last_page"]),
    lastPageUrl: _stringOrNull(json["last_page_url"]),
    nextPageUrl: _stringOrNull(json["next_page_url"]),
    path: _stringOrNull(json["path"]),
    perPage: _stringOrNull(json["per_page"]),
    prevPageUrl: _stringOrNull(json["prev_page_url"]),
    to: _stringOrNull(json["to"]),
    total: _stringOrNull(json["total"]),
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class PurchaseHistoryData {
  final String? id;
  final String? planId;
  final String? userId;
  final String? couponId;
  final String? recurringType;
  final String? amount;
  final String? discountAmount;
  final String? paymentMethod;
  final String? gatewayMethodCode;
  final String? autoRenewal;
  final String? expiredAt;
  final String? isSentExpiredNotify;
  final String? isSentReminderNotify;
  final String? createdAt;
  final String? updatedAt;
  final Gateway? gateway;

  PurchaseHistoryData({
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
    this.gateway,
  });

  factory PurchaseHistoryData.fromJson(Map<String, dynamic> json) => PurchaseHistoryData(
    id: _stringOrNull(json["id"]),
    planId: _stringOrNull(json["plan_id"]),
    userId: _stringOrNull(json["user_id"]),
    couponId: _stringOrNull(json["coupon_id"]),
    recurringType: _stringOrNull(json["recurring_type"]),
    amount: _stringOrNull(json["amount"]),
    discountAmount: _stringOrNull(json["discount_amount"]),
    paymentMethod: _stringOrNull(json["payment_method"]),
    gatewayMethodCode: _stringOrNull(json["gateway_method_code"]),
    autoRenewal: _stringOrNull(json["auto_renewal"]),
    expiredAt: _stringOrNull(json["expired_at"]),
    isSentExpiredNotify: _stringOrNull(json["is_sent_expired_notify"]),
    isSentReminderNotify: _stringOrNull(json["is_sent_reminder_notify"]),
    createdAt: _stringOrNull(json["created_at"]),
    updatedAt: _stringOrNull(json["updated_at"]),
    gateway: json["gateway"] == null ? null : Gateway.fromJson(json["gateway"]),
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
    "gateway": gateway?.toJson(),
  };
}

class SupportedCurrencies {
  final String? usd;
  final String? ngn;

  SupportedCurrencies({this.usd, this.ngn});

  factory SupportedCurrencies.fromJson(Map<String, dynamic> json) =>
      SupportedCurrencies(usd: _stringOrNull(json["USD"]), ngn: _stringOrNull(json["NGN"]));

  Map<String, dynamic> toJson() => {"USD": usd, "NGN": ngn};
}
