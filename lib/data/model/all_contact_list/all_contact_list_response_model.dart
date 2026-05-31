// To parse this JSON data, do
//
//     final allContactListResponseModel = allContactListResponseModelFromJson(jsonString);

import 'dart:convert';

AllContactListResponseModel allContactListResponseModelFromJson(String str) =>
    AllContactListResponseModel.fromJson(json.decode(str));

String allContactListResponseModelToJson(AllContactListResponseModel data) => json.encode(data.toJson());

class AllContactListResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  AllContactListResponseModel({this.remark, this.status, this.message, this.data});

  factory AllContactListResponseModel.fromJson(Map<String, dynamic> json) => AllContactListResponseModel(
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
  final ContactLists? contactLists;

  Data({this.contactLists});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(contactLists: json["contact_lists"] == null ? null : ContactLists.fromJson(json["contact_lists"]));

  Map<String, dynamic> toJson() => {"contact_lists": contactLists?.toJson()};
}

class ContactLists {
  final String? currentPage;
  final List<AllContactData>? data;
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

  ContactLists({
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

  factory ContactLists.fromJson(Map<String, dynamic> json) => ContactLists(
    currentPage: json["current_page"]?.toString(),
    data: json["data"] == null ? [] : List<AllContactData>.from(json["data"]!.map((x) => AllContactData.fromJson(x))),
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

class AllContactData {
  final String? id;
  final String? userId;
  final String? name;
  final String? createdAt;
  final String? updatedAt;
  final List<Contact>? contact;

  AllContactData({this.id, this.userId, this.name, this.createdAt, this.updatedAt, this.contact});

  factory AllContactData.fromJson(Map<String, dynamic> json) => AllContactData(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    name: json["name"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    contact: json["contact"] == null ? [] : List<Contact>.from(json["contact"]!.map((x) => Contact.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "contact": contact == null ? [] : List<dynamic>.from(contact!.map((x) => x.toJson())),
  };
}

class Contact {
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
  final Pivot? pivot;

  Contact({
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
    this.pivot,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    firstname: json["firstname"]?.toString(),
    lastname: json["lastname"]?.toString(),
    mobileCode: json["mobile_code".toString()],
    mobile: json["mobile"]?.toString(),
    image: json["image"]?.toString(),
    status: json["status"]?.toString(),
    details: json["details"]?.toString(),
    isCustomer: json["is_customer"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
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
    "pivot": pivot?.toJson(),
  };
}

class Pivot {
  final String? contactListId;
  final String? contactId;

  Pivot({this.contactListId, this.contactId});

  factory Pivot.fromJson(Map<String, dynamic> json) =>
      Pivot(contactListId: json["contact_list_id"]?.toString(), contactId: json["contact_id"]?.toString());

  Map<String, dynamic> toJson() => {"contact_list_id": contactListId, "contact_id": contactId};
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
