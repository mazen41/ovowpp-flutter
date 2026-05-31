import 'dart:convert';

class DepositHistoryResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  DepositHistoryResponseModel({this.remark, this.status, this.message, this.data});

  factory DepositHistoryResponseModel.fromRawJson(String str) => DepositHistoryResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DepositHistoryResponseModel.fromJson(Map<String, dynamic> json) => DepositHistoryResponseModel(
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
  Deposits? deposits;

  Data({this.deposits});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(deposits: json["deposits"] == null ? null : Deposits.fromJson(json["deposits"]));

  Map<String, dynamic> toJson() => {"deposits": deposits?.toJson()};
}

class Deposits {
  String? currentPage;
  List<DepositHistoryListModel>? data;
  String? firstPageUrl;
  String? from;
  String? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  String? perPage;
  dynamic prevPageUrl;
  String? to;
  String? total;

  Deposits({
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

  factory Deposits.fromRawJson(String str) => Deposits.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Deposits.fromJson(Map<String, dynamic> json) => Deposits(
    currentPage: json["current_page"]?.toString(),
    data: json["data"] == null
        ? []
        : List<DepositHistoryListModel>.from(json["data"]!.map((x) => DepositHistoryListModel.fromJson(x))),
    firstPageUrl: json["first_page_url"]?.toString(),
    from: json["from"]?.toString(),
    lastPage: json["last_page"]?.toString(),
    lastPageUrl: json["last_page_url"]?.toString(),
    nextPageUrl: json["next_page_url"]?.toString(),
    path: json["path"]?.toString(),
    perPage: json["per_page"]?.toString(),
    prevPageUrl: json["prev_page_url"]?.toString(),
    to: json["to"]?.toString(),
    total: json["total"]?.toString(),
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

class DepositHistoryListModel {
  String? id;
  String? userId;
  String? planId;
  String? couponId;
  String? planRecurringType;
  String? methodCode;
  String? amount;
  String? methodCurrency;
  String? charge;
  String? rate;
  String? finalAmount;
  String? btcAmount;
  String? btcWallet;
  String? trx;
  String? paymentTry;
  String? status;
  String? fromApi;
  dynamic adminFeedback;
  String? successUrl;
  String? failedUrl;
  String? lastCron;
  String? createdAt;
  String? updatedAt;
  Gateway? gateway;

  DepositHistoryListModel({
    this.id,
    this.userId,
    this.planId,
    this.couponId,
    this.planRecurringType,
    this.methodCode,
    this.amount,
    this.methodCurrency,
    this.charge,
    this.rate,
    this.finalAmount,
    this.btcAmount,
    this.btcWallet,
    this.trx,
    this.paymentTry,
    this.status,
    this.fromApi,
    this.adminFeedback,
    this.successUrl,
    this.failedUrl,
    this.lastCron,
    this.createdAt,
    this.updatedAt,
    this.gateway,
  });

  factory DepositHistoryListModel.fromRawJson(String str) => DepositHistoryListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DepositHistoryListModel.fromJson(Map<String, dynamic> json) => DepositHistoryListModel(
    id: json["id"].toString(),
    userId: json["user_id"].toString(),
    planId: json["plan_id"].toString(),
    couponId: json["coupon_id"].toString(),
    planRecurringType: json["plan_recurring_type"].toString(),
    methodCode: json["method_code"].toString(),
    amount: json["amount"].toString(),
    methodCurrency: json["method_currency"],
    charge: json["charge"],
    rate: json["rate"],
    finalAmount: json["final_amount"],
    btcAmount: json["btc_amount"],
    btcWallet: json["btc_wallet"],
    trx: json["trx"],
    paymentTry: json["payment_try"].toString(),
    status: json["status"].toString(),
    fromApi: json["from_api"].toString(),
    adminFeedback: json["admin_feedback"],
    successUrl: json["success_url"],
    failedUrl: json["failed_url"],
    lastCron: json["last_cron"].toString(),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    gateway: json["gateway"] == null ? null : Gateway.fromJson(json["gateway"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "plan_id": planId,
    "coupon_id": couponId,
    "plan_recurring_type": planRecurringType,
    "method_code": methodCode,
    "amount": amount,
    "method_currency": methodCurrency,
    "charge": charge,
    "rate": rate,
    "final_amount": finalAmount,
    "btc_amount": btcAmount,
    "btc_wallet": btcWallet,
    "trx": trx,
    "payment_try": paymentTry,
    "status": status,
    "from_api": fromApi,
    "admin_feedback": adminFeedback,
    "success_url": successUrl,
    "failed_url": failedUrl,
    "last_cron": lastCron,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "gateway": gateway?.toJson(),
  };
}

class Gateway {
  String? id;
  String? formId;
  String? code;
  String? name;
  String? alias;
  String? image;
  String? status;
  SupportedCurrencies? supportedCurrencies;
  String? crypto;
  dynamic description;
  String? createdAt;
  String? updatedAt;

  Gateway({
    this.id,
    this.formId,
    this.code,
    this.name,
    this.alias,
    this.image,
    this.status,
    this.supportedCurrencies,
    this.crypto,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Gateway.fromRawJson(String str) => Gateway.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
    id: json["id"]?.toString(),
    formId: json["form_id"]?.toString(),
    code: json["code"]?.toString(),
    name: json["name"]?.toString(),
    alias: json["alias"]?.toString(),
    image: json["image"]?.toString(),
    status: json["status"]?.toString(),
    supportedCurrencies: json["supported_currencies"] == null
        ? null
        : SupportedCurrencies.fromJson(json["supported_currencies"]),
    crypto: json["crypto"]?.toString(),
    description: json["description"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "form_id": formId,
    "code": code,
    "name": name,
    "alias": alias,
    "image": image,
    "status": status,
    "supported_currencies": supportedCurrencies?.toJson(),
    "crypto": crypto,
    "description": description,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class SupportedCurrencies {
  String? usd;
  String? ngn;

  SupportedCurrencies({this.usd, this.ngn});

  factory SupportedCurrencies.fromRawJson(String str) => SupportedCurrencies.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SupportedCurrencies.fromJson(Map<String, dynamic> json) =>
      SupportedCurrencies(usd: json["USD"]?.toString(), ngn: json["NGN"]?.toString());

  Map<String, dynamic> toJson() => {"USD": usd, "NGN": ngn};
}
