// To parse this JSON data, do
//
//     final searchContactListResponseModel = searchContactListResponseModelFromJson(jsonString);

import 'dart:convert';

SearchContactListResponseModel searchContactListResponseModelFromJson(String str) =>
    SearchContactListResponseModel.fromJson(json.decode(str));

String searchContactListResponseModelToJson(SearchContactListResponseModel data) => json.encode(data.toJson());

class SearchContactListResponseModel {
  final String? remark;
  final String? status;
  final Data? data;

  SearchContactListResponseModel({this.remark, this.status, this.data});

  factory SearchContactListResponseModel.fromJson(Map<String, dynamic> json) => SearchContactListResponseModel(
    remark: json["remark"],
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"remark": remark, "status": status, "data": data?.toJson()};
}

class Data {
  final Contacts? contacts;
  final bool? more;

  Data({this.contacts, this.more});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(contacts: json["contacts"] == null ? null : Contacts.fromJson(json["contacts"]), more: json["more"]);

  Map<String, dynamic> toJson() => {"contacts": contacts?.toJson(), "more": more};
}

class Contacts {
  final String? currentPage;
  final List<AllContactDataList>? data;
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

  Contacts({
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

  factory Contacts.fromJson(Map<String, dynamic> json) => Contacts(
    currentPage: json["current_page"]?.toString(),
    data: json["data"] == null
        ? []
        : List<AllContactDataList>.from(json["data"]!.map((x) => AllContactDataList.fromJson(x))),
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

class AllContactDataList {
  final String? id;
  final String? userId;
  final String? firstname;
  final String? lastname;
  final String? mobileCode;
  final String? mobile;
  final String? image;
  final String? status;
  final dynamic details;
  final String? isCustomer;
  final String? createdAt;
  final String? updatedAt;

  AllContactDataList({
    this.id,
    this.userId,
    this.firstname,
    this.lastname,
    this.mobileCode,
    this.mobile,
    this.image,
    this.status,
    this.details,
    this.isCustomer,
    this.createdAt,
    this.updatedAt,
  });

  factory AllContactDataList.fromJson(Map<String, dynamic> json) => AllContactDataList(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    firstname: json["firstname"]?.toString(),
    lastname: json["lastname"]?.toString(),
    mobileCode: json["mobile_code"]?.toString(),
    mobile: json["mobile"]?.toString(),
    image: json["image"]?.toString(),
    status: json["status"]?.toString(),
    details: json["details"]?.toString(),
    isCustomer: json["is_customer"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "firstname": firstname,
    "lastname": lastname,
    "mobile_code": mobileCode,
    "mobile": mobile,
    "image": image,
    "status": status,
    "details": details,
    "is_customer": isCustomer,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
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
