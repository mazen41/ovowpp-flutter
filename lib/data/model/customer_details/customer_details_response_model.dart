import 'dart:convert';

CustomerDetailsResponseModel customerDetailsResponseModelFromJson(String str) =>
    CustomerDetailsResponseModel.fromJson(json.decode(str));

String customerDetailsResponseModelToJson(CustomerDetailsResponseModel data) => json.encode(data.toJson());

class CustomerDetailsResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CustomerDetailsResponseModel({this.remark, this.status, this.message, this.data});

  factory CustomerDetailsResponseModel.fromJson(Map<String, dynamic> json) => CustomerDetailsResponseModel(
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
  Conversation? conversation;
  String? imagePath;

  Data({this.conversation, this.imagePath});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    conversation: json["conversation"] == null ? null : Conversation.fromJson(json["conversation"]),
    imagePath: json["profilePath"]?.toString(),
  );

  Map<String, dynamic> toJson() => {"conversation": conversation?.toJson(), "profilePath": imagePath};
}

class Conversation {
  String? id;
  String? userId;
  String? contactId;
  String? status;
  String? lastMessageAt;
  String? createdAt;
  String? updatedAt;
  Contact? contact;
  List<Note>? notes;

  Conversation({
    this.id,
    this.userId,
    this.contactId,
    this.status,
    this.lastMessageAt,
    this.createdAt,
    this.updatedAt,
    this.contact,
    this.notes,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    contactId: json["contact_id"]?.toString(),
    status: json["status"]?.toString(),
    lastMessageAt: json["last_message_at"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    contact: json["contact"] == null ? null : Contact.fromJson(json["contact"]),
    notes: json["notes"] == null ? [] : List<Note>.from(json["notes"]!.map((x) => Note.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "contact_id": contactId,
    "status": status,
    "last_message_at": lastMessageAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "contact": contact?.toJson(),
    "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x.toJson())),
  };
}

class Contact {
  String? id;
  String? userId;
  String? firstname;
  String? lastname;
  String? mobileCode;
  String? mobile;
  String? image;
  String? imageSrc;
  String? status;
  Map<String, dynamic>? details;
  String? createdAt;
  String? updatedAt;
  List<AllContacts>? tags;
  List<AllContacts> lists;
  Address? address;

  Contact({
    this.id,
    this.userId,
    this.firstname,
    this.lastname,
    this.mobileCode,
    this.mobile,
    this.image,
    this.imageSrc,
    this.status,
    this.details,
    this.createdAt,
    this.updatedAt,
    List<AllContacts>? tags,
    List<AllContacts>? lists,
    this.address,
  }) : tags = tags ?? [],
       lists = lists ?? [];

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json["id"]?.toString(),
      userId: json["user_id"]?.toString(),
      firstname: json["firstname"]?.toString(),
      lastname: json["lastname"]?.toString(),
      mobileCode: json["mobile_code"]?.toString(),
      mobile: json["mobile"]?.toString(),
      image: json["image"]?.toString(),
      imageSrc: json["image_src"]?.toString(),
      status: json["status"]?.toString(),
      details: json["details"] == null || json["details"].toString() == "[]"
          ? null
          : Map<String, dynamic>.from(json["details"]),
      createdAt: json["created_at"]?.toString(),
      updatedAt: json["updated_at"]?.toString(),
      tags: json["tags"] == null ? [] : List<AllContacts>.from(json["tags"].map((x) => AllContacts.fromJson(x))),
      lists: json["lists"] == null ? [] : List<AllContacts>.from(json["lists"].map((x) => AllContacts.fromJson(x))),

      // ✅ Address handling (Map or JSON string)
      address: json["address"] == null
          ? null
          : Address.fromJson(
              json["address"] is String ? jsonDecode(json["address"]) : Map<String, dynamic>.from(json["address"]),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "firstname": firstname,
    "lastname": lastname,
    "mobile_code": mobileCode,
    "mobile": mobile,
    "image": image,
    "image_src": imageSrc,
    "status": status,
    "details": details,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "tags": tags?.map((x) => x.toJson()).toList(),
    "lists": lists.map((x) => x.toJson()).toList(),
    "address": address?.toJson(),
  };

  /// Helpers
  String getFullName() {
    final first = firstname?.trim() ?? "";
    final last = lastname?.trim() ?? "";
    return [first, last].where((e) => e.isNotEmpty).join(" ");
  }

  String getInitials() {
    final f = firstname?.trim();
    final l = lastname?.trim();
    return "${f?.isNotEmpty == true ? f![0].toUpperCase() : ""}"
        "${l?.isNotEmpty == true ? l![0].toUpperCase() : ""}";
  }
}

class Address {
  String? city;
  String? state;
  String? postCode;
  String? address;
  String? country;

  Address({this.city, this.state, this.postCode, this.address, this.country});

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    city: json["city"],
    state: json["state"],
    postCode: json["post_code"],
    address: json["address"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "state": state,
    "post_code": postCode,
    "address": address,
    "country": country,
  };
}

class AllContacts {
  String? id;
  String? userId;
  String? name;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  AllContacts({this.id, this.userId, this.name, this.createdAt, this.updatedAt, this.pivot});

  factory AllContacts.fromJson(Map<String, dynamic> json) => AllContacts(
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
  String? contactId;
  String? contactTagId;

  Pivot({this.contactId, this.contactTagId});

  factory Pivot.fromJson(Map<String, dynamic> json) =>
      Pivot(contactId: json["contact_id"]?.toString(), contactTagId: json["contact_tag_id"]?.toString());

  Map<String, dynamic> toJson() => {"contact_id": contactId, "contact_tag_id": contactTagId};
}

class Note {
  String? id;
  String? userId;
  String? conversationId;
  String? note;
  String? createdAt;
  String? updatedAt;

  Note({this.id, this.userId, this.conversationId, this.note, this.createdAt, this.updatedAt});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    conversationId: json["conversation_id"]?.toString(),
    note: json["note"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "conversation_id": conversationId,
    "note": note,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
