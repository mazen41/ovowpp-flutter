import 'dart:convert';

ContactTagListResponseModel contactTagListResponseModelFromJson(String str) =>
    ContactTagListResponseModel.fromJson(json.decode(str));

String contactTagListResponseModelToJson(ContactTagListResponseModel data) => json.encode(data.toJson());

class ContactTagListResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  ContactTagListResponseModel({this.remark, this.status, this.message, this.data});

  factory ContactTagListResponseModel.fromJson(Map<String, dynamic> json) => ContactTagListResponseModel(
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
  final ContactTags? contactTags;

  Data({this.contactTags});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(contactTags: json["contact_tags"] == null ? null : ContactTags.fromJson(json["contact_tags"]));

  Map<String, dynamic> toJson() => {"contact_tags": contactTags?.toJson()};
}

class ContactTags {
  final String? currentPage;
  final List<AllContactTagsList>? data;
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

  ContactTags({
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

  factory ContactTags.fromJson(Map<String, dynamic> json) => ContactTags(
    currentPage: json["current_page"]?.toString(),
    data: json["data"] == null
        ? []
        : List<AllContactTagsList>.from(json["data"]!.map((x) => AllContactTagsList.fromJson(x))),
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

class AllContactTagsList {
  final String? id;
  final String? userId;
  final String? name;
  final String? createdAt;
  final String? updatedAt;
  final String? contactsCount;

  AllContactTagsList({this.id, this.userId, this.name, this.createdAt, this.updatedAt, this.contactsCount});

  factory AllContactTagsList.fromJson(Map<String, dynamic> json) => AllContactTagsList(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    name: json["name"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    contactsCount: json["contacts_count"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "contacts_count": contactsCount,
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
