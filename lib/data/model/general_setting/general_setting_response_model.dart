// To parse this JSON data, do
//
//     final generalSettingResponseModel = generalSettingResponseModelFromJson(jsonString);

import 'dart:convert';

import '../../../core/helper/string_format_helper.dart';

GeneralSettingResponseModel generalSettingResponseModelFromJson(String str) =>
    GeneralSettingResponseModel.fromJson(json.decode(str));

String generalSettingResponseModelToJson(GeneralSettingResponseModel data) => json.encode(data.toJson());

class GeneralSettingResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  GeneralSettingResponseModel({this.remark, this.status, this.message, this.data});

  factory GeneralSettingResponseModel.fromJson(Map<String, dynamic> json) => GeneralSettingResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: (json["message"] as List<dynamic>).toStringList(),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"remark": remark, "status": status, "message": message, "data": data?.toJson()};
}

class Data {
  GeneralSetting? generalSetting;
  String? socialLoginRedirect;

  Data({this.generalSetting, this.socialLoginRedirect});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    generalSetting: json["general_setting"] == null ? null : GeneralSetting.fromJson(json["general_setting"]),
    socialLoginRedirect: json["social_login_redirect"],
  );

  Map<String, dynamic> toJson() => {
    "general_setting": generalSetting?.toJson(),
    "social_login_redirect": socialLoginRedirect,
  };
}

class GeneralSetting {
  int? id;
  String? siteName;
  String? curText;
  String? curSym;
  String? emailFrom;
  String? emailFromName;
  String? smsTemplate;
  String? smsFrom;
  String? pushTitle;
  String? pushTemplate;
  String? baseColor;
  String? secondaryColor;
  FirebaseConfig? firebaseConfig;
  GlobalShortcodes? globalShortcodes;
  PusherConfig? pusherConfig;
  String? kv;
  String? ev;
  String? en;
  String? sv;
  String? sn;
  String? pn;
  String? forceSsl;
  String? inAppPayment;
  String? maintenanceMode;
  String? securePassword;
  String? agree;
  String? multiLanguage;
  String? registration;
  String? activeTemplate;
  SocialiteCredentials? socialiteCredentials;
  String? lastCron;
  String? availableVersion;
  String? systemCustomized;
  String? paginateNumber;
  String? currencyFormat;
  dynamic createdAt;
  String? updatedAt;

  GeneralSetting({
    this.id,
    this.siteName,
    this.curText,
    this.curSym,
    this.emailFrom,
    this.emailFromName,
    this.smsTemplate,
    this.smsFrom,
    this.pushTitle,
    this.pusherConfig,
    this.pushTemplate,
    this.baseColor,
    this.secondaryColor,
    this.firebaseConfig,
    this.globalShortcodes,
    this.kv,
    this.ev,
    this.en,
    this.sv,
    this.sn,
    this.pn,
    this.forceSsl,
    this.inAppPayment,
    this.maintenanceMode,
    this.securePassword,
    this.agree,
    this.multiLanguage,
    this.registration,
    this.activeTemplate,
    this.socialiteCredentials,
    this.lastCron,
    this.availableVersion,
    this.systemCustomized,
    this.paginateNumber,
    this.currencyFormat,
    this.createdAt,
    this.updatedAt,
  });

  factory GeneralSetting.fromJson(Map<String, dynamic> json) => GeneralSetting(
    id: json["id"],
    siteName: json["site_name"].toString(),
    curText: json["cur_text"].toString(),
    curSym: json["cur_sym"].toString(),
    emailFrom: json["email_from"].toString(),
    emailFromName: json["email_from_name"].toString(),
    smsTemplate: json["sms_template"],
    smsFrom: json["sms_from"].toString(),
    pushTitle: json["push_title"].toString(),
    pusherConfig: json["pusher_config"] == null ? null : PusherConfig.fromJson(json["pusher_config"]),
    pushTemplate: json["push_template"].toString(),
    baseColor: json["base_color"].toString(),
    secondaryColor: json["secondary_color"].toString(),
    firebaseConfig: json["firebase_config"] == null ? null : FirebaseConfig.fromJson(json["firebase_config"]),
    globalShortcodes: json["global_shortcodes"] == null ? null : GlobalShortcodes.fromJson(json["global_shortcodes"]),
    kv: json["kv"].toString(),
    ev: json["ev"].toString(),
    en: json["en"].toString(),
    sv: json["sv"].toString(),
    sn: json["sn"].toString(),
    pn: json["pn"].toString(),
    forceSsl: json["force_ssl"].toString(),
    inAppPayment: json["in_app_payment"].toString(),
    maintenanceMode: json["maintenance_mode"].toString(),
    securePassword: json["secure_password"].toString(),
    agree: json["agree"].toString(),
    multiLanguage: json["multi_language"].toString(),
    registration: json["registration"].toString(),
    activeTemplate: json["active_template"].toString(),
    socialiteCredentials: json["socialite_credentials"] == null
        ? null
        : SocialiteCredentials.fromJson(json["socialite_credentials"]),
    lastCron: json["last_cron"].toString(),
    availableVersion: json["available_version"].toString(),
    systemCustomized: json["system_customized"].toString(),
    paginateNumber: json["paginate_number"].toString(),
    currencyFormat: json["currency_format"].toString(),
    createdAt: json["created_at"].toString(),
    updatedAt: json["updated_at"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "site_name": siteName,
    "cur_text": curText,
    "cur_sym": curSym,
    "email_from": emailFrom,
    "email_from_name": emailFromName,
    "sms_template": smsTemplate,
    "sms_from": smsFrom,
    "push_title": pushTitle,
    "push_template": pushTemplate,
    "base_color": baseColor,
    "pusher_config": pusherConfig?.toJson(),
    "secondary_color": secondaryColor,
    "firebase_config": firebaseConfig?.toJson(),
    "global_shortcodes": globalShortcodes?.toJson(),
    "kv": kv,
    "ev": ev,
    "en": en,
    "sv": sv,
    "sn": sn,
    "pn": pn,
    "force_ssl": forceSsl,
    "in_app_payment": inAppPayment,
    "maintenance_mode": maintenanceMode,
    "secure_password": securePassword,
    "agree": agree,
    "multi_language": multiLanguage,
    "registration": registration,
    "active_template": activeTemplate,
    "socialite_credentials": socialiteCredentials?.toJson(),
    "last_cron": lastCron,
    "available_version": availableVersion,
    "system_customized": systemCustomized,
    "paginate_number": paginateNumber,
    "currency_format": currencyFormat,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class PusherConfig {
  final String? pusherAppId;
  final String? pusherAppKey;
  final String? pusherAppSecret;
  final String? pusherAppCluster;

  PusherConfig({this.pusherAppId, this.pusherAppKey, this.pusherAppSecret, this.pusherAppCluster});

  factory PusherConfig.fromJson(Map<String, dynamic> json) => PusherConfig(
    pusherAppId: json["pusher_app_id"]?.toString(),
    pusherAppKey: json["pusher_app_key"]?.toString(),
    pusherAppSecret: json["pusher_app_secret"]?.toString(),
    pusherAppCluster: json["pusher_app_cluster"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "pusher_app_id": pusherAppId,
    "pusher_app_key": pusherAppKey,
    "pusher_app_secret": pusherAppSecret,
    "pusher_app_cluster": pusherAppCluster,
  };
}

class FirebaseConfig {
  String? apiKey;
  String? authDomain;
  String? projectId;
  String? storageBucket;
  String? messagingSenderId;
  String? appId;
  String? measurementId;
  String? serverKey;

  FirebaseConfig({
    this.apiKey,
    this.authDomain,
    this.projectId,
    this.storageBucket,
    this.messagingSenderId,
    this.appId,
    this.measurementId,
    this.serverKey,
  });

  factory FirebaseConfig.fromJson(Map<String, dynamic> json) => FirebaseConfig(
    apiKey: json["apiKey"].toString(),
    authDomain: json["authDomain"].toString(),
    projectId: json["projectId"].toString(),
    storageBucket: json["storageBucket"].toString(),
    messagingSenderId: json["messagingSenderId"].toString(),
    appId: json["appId"].toString(),
    measurementId: json["measurementId"].toString(),
    serverKey: json["serverKey"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "apiKey": apiKey,
    "authDomain": authDomain,
    "projectId": projectId,
    "storageBucket": storageBucket,
    "messagingSenderId": messagingSenderId,
    "appId": appId,
    "measurementId": measurementId,
    "serverKey": serverKey,
  };
}

class GlobalShortcodes {
  String? siteName;
  String? siteCurrency;
  String? currencySymbol;

  GlobalShortcodes({this.siteName, this.siteCurrency, this.currencySymbol});

  factory GlobalShortcodes.fromJson(Map<String, dynamic> json) => GlobalShortcodes(
    siteName: json["site_name"],
    siteCurrency: json["site_currency"],
    currencySymbol: json["currency_symbol"],
  );

  Map<String, dynamic> toJson() => {
    "site_name": siteName,
    "site_currency": siteCurrency,
    "currency_symbol": currencySymbol,
  };
}

class SocialiteCredentials {
  SocialiteCredentialsValue? google;
  SocialiteCredentialsValue? facebook;
  SocialiteCredentialsValue? linkedin;

  SocialiteCredentials({this.google, this.facebook, this.linkedin});

  factory SocialiteCredentials.fromJson(Map<String, dynamic> json) => SocialiteCredentials(
    google: json["google"] == null ? null : SocialiteCredentialsValue.fromJson(json["google"]),
    facebook: json["facebook"] == null ? null : SocialiteCredentialsValue.fromJson(json["facebook"]),
    linkedin: json["linkedin"] == null ? null : SocialiteCredentialsValue.fromJson(json["linkedin"]),
  );

  Map<String, dynamic> toJson() => {
    "google": google?.toJson(),
    "facebook": facebook?.toJson(),
    "linkedin": linkedin?.toJson(),
  };
}

class SocialiteCredentialsValue {
  String? clientId;
  String? clientSecret;
  String? status;

  SocialiteCredentialsValue({this.clientId, this.clientSecret, this.status});

  factory SocialiteCredentialsValue.fromJson(Map<String, dynamic> json) => SocialiteCredentialsValue(
    clientId: json["client_id"].toString(),
    clientSecret: json["client_secret"].toString(),
    status: json["status"].toString(),
  );

  Map<String, dynamic> toJson() => {"client_id": clientId, "client_secret": clientSecret, "status": status};
}
