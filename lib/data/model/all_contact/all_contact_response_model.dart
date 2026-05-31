// To parse this JSON data, do
//
//     final allContactResponseModel = allContactResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';

AllContactResponseModel allContactResponseModelFromJson(String str) =>
    AllContactResponseModel.fromJson(json.decode(str));

String allContactResponseModelToJson(AllContactResponseModel data) => json.encode(data.toJson());

class AllContactResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  AllContactResponseModel({this.remark, this.status, this.message, this.data});

  factory AllContactResponseModel.fromJson(Map<String, dynamic> json) => AllContactResponseModel(
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
  final AllContactsListModel? contacts;
  final List<ContactTag>? contactTags;
  final String? profilePath;

  Data({this.contacts, this.contactTags, this.profilePath});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    contacts: json["contacts"] == null ? null : AllContactsListModel.fromJson(json["contacts"]),
    contactTags: json["contact_tags"] == null
        ? []
        : List<ContactTag>.from(json["contact_tags"]!.map((x) => ContactTag.fromJson(x))),
    profilePath: json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "contacts": contacts?.toJson(),
    "contact_tags": contactTags == null ? [] : List<dynamic>.from(contactTags!.map((x) => x.toJson())),
    "profile_path": profilePath,
  };
}

class ContactTag {
  final String? id;
  final String? userId;
  final String? name;
  final String? createdAt;
  final String? updatedAt;
  final Pivot? pivot;

  ContactTag({this.id, this.userId, this.name, this.createdAt, this.updatedAt, this.pivot});

  factory ContactTag.fromJson(Map<String, dynamic> json) => ContactTag(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    name: json["name"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "pivot": pivot?.toJson(),
  };
}

class Pivot {
  final String? contactId;
  final String? contactListId;
  final String? contactTagId;

  Pivot({this.contactId, this.contactListId, this.contactTagId});

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    contactId: json["contact_id"]?.toString(),
    contactListId: json["contact_list_id"]?.toString(),
    contactTagId: json["contact_tag_id"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "contact_id": contactId,
    "contact_list_id": contactListId,
    "contact_tag_id": contactTagId,
  };
}

class AllContactsListModel {
  final String? currentPage;
  final List<Contact>? data;
  final String? firstPageUrl;
  final String? from;
  final String? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final String? perPage;
  final String? prevPageUrl;
  final String? to;
  final String? total;

  AllContactsListModel({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory AllContactsListModel.fromJson(Map<String, dynamic> json) => AllContactsListModel(
    currentPage: json["current_page"]?.toString(),
    data: json["data"] == null ? [] : List<Contact>.from(json["data"]!.map((x) => Contact.fromJson(x))),
    firstPageUrl: json["first_page_url"]?.toString(),
    from: json["from"]?.toString(),
    lastPage: json["last_page"]?.toString(),
    lastPageUrl: json["last_page_url"]?.toString(),
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
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
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class DetailsClass {
  final String? address;
  final String? company;

  DetailsClass({this.address, this.company});

  factory DetailsClass.fromJson(Map<String, dynamic> json) =>
      DetailsClass(address: json["Address"]?.toString(), company: json["Company"]?.toString());

  Map<String, dynamic> toJson() => {"Address": address, "Company": company};
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"]?.toString(), label: json["label"]?.toString(), active: json["active"]);

  Map<String, dynamic> toJson() => {"url": url, "label": label, "active": active};
}
