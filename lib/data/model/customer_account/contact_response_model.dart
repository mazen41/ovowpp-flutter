// To parse this JSON data, do
//
//     final customerContactResponseModel = customerContactResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';

CustomerContactResponseModel customerContactResponseModelFromJson(String str) =>
    CustomerContactResponseModel.fromJson(json.decode(str));

String customerContactResponseModelToJson(CustomerContactResponseModel data) => json.encode(data.toJson());

class CustomerContactResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  CustomerContactResponseModel({this.remark, this.status, this.message, this.data});

  factory CustomerContactResponseModel.fromJson(Map<String, dynamic> json) => CustomerContactResponseModel(
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
  final Map<String, Country>? countries;
  final List<AllContacts>? contactLists;
  final List<AllContacts>? contactTags;

  Data({this.countries, this.contactLists, this.contactTags});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    countries: Map.from(json["countries"]!).map((k, v) => MapEntry<String, Country>(k, Country.fromJson(v))),
    contactLists: json["contact_lists"] == null
        ? []
        : List<AllContacts>.from(json["contact_lists"]!.map((x) => AllContacts.fromJson(x))),
    contactTags: json["contact_tags"] == null
        ? []
        : List<AllContacts>.from(json["contact_tags"]!.map((x) => AllContacts.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "countries": Map.from(countries!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "contact_lists": contactLists == null ? [] : List<dynamic>.from(contactLists!.map((x) => x.toJson())),
    "contact_tags": contactTags == null ? [] : List<dynamic>.from(contactTags!.map((x) => x.toJson())),
  };
}

class Country {
  final String? country;
  final String? dialCode;

  Country({this.country, this.dialCode});

  factory Country.fromJson(Map<String, dynamic> json) => Country(country: json["country"], dialCode: json["dial_code"]);

  Map<String, dynamic> toJson() => {"country": country, "dial_code": dialCode};
}
