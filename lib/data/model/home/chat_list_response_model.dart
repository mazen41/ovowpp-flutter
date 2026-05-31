// To parse this JSON data, do
//
//     final chatListResponseModel = chatListResponseModelFromJson(jsonString);

import 'dart:convert';

ChatListResponseModel chatListResponseModelFromJson(String str) => ChatListResponseModel.fromJson(json.decode(str));

String chatListResponseModelToJson(ChatListResponseModel data) => json.encode(data.toJson());

class ChatListResponseModel {
  final String? remark;
  final String? status;
  final List<String>? message;
  final Data? data;

  ChatListResponseModel({this.remark, this.status, this.message, this.data});

  factory ChatListResponseModel.fromJson(Map<String, dynamic> json) => ChatListResponseModel(
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
  final Conversations? conversations;
  final String? profilePath;

  Data({this.conversations, this.profilePath});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    conversations: json["conversations"] == null ? null : Conversations.fromJson(json["conversations"]),
    profilePath: json["profilePath"],
  );

  Map<String, dynamic> toJson() => {"conversations": conversations?.toJson(), "profilePath": profilePath};
}

class Conversations {
  final String? currentPage;
  final List<ConversationData>? data;
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

  Conversations({
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

  factory Conversations.fromJson(Map<String, dynamic> json) => Conversations(
    currentPage: json["current_page"]?.toString(),
    data: json["data"] == null
        ? []
        : List<ConversationData>.from(json["data"]!.map((x) => ConversationData.fromJson(x))),
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

class ConversationData {
  final String? id;
  final String? userId;
  final String? contactId;
  final String? status;
  final String? lastMessageAt;
  final String? createdAt;
  final String? updatedAt;
  final Contact? contact;
  final LastMessage? lastMessage;
  final String? unseenMessages;

  ConversationData({
    this.id,
    this.userId,
    this.contactId,
    this.status,
    this.lastMessageAt,
    this.createdAt,
    this.updatedAt,
    this.contact,
    this.lastMessage,
    this.unseenMessages,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) => ConversationData(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    contactId: json["contact_id"]?.toString(),
    status: json["status"]?.toString(),
    lastMessageAt: json["last_message_at"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    contact: json["contact"] == null ? null : Contact.fromJson(json["contact"]),
    lastMessage: json["last_message"] == null ? null : LastMessage.fromJson(json["last_message"]),
    unseenMessages: json["unseen_messages"]?.toString() ?? "0",
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
    "last_message": lastMessage?.toJson(),
    "unseen_messages": unseenMessages,
  };
  ConversationData copyWith({
    String? id,
    String? userId,
    String? contactId,
    String? status,
    String? lastMessageAt,
    String? createdAt,
    String? updatedAt,
    Contact? contact,
    LastMessage? lastMessage,
    String? unseenMessages,
  }) {
    return ConversationData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contactId: contactId ?? this.contactId,
      status: status ?? this.status,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contact: contact ?? this.contact,
      lastMessage: lastMessage ?? this.lastMessage,
      unseenMessages: unseenMessages ?? this.unseenMessages,
    );
  }
}

class Contact {
  final String? id;
  final String? userId;
  String? firstname;
  String? lastname;
  final String? mobileCode;
  String? mobile;
  final String? image;
  final String? imageSrc;
  final String? status;
  final Details? details;
  final String? createdAt;
  final String? updatedAt;
  List<Tag>? tags;

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
    this.tags,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    firstname: json["firstname"]?.toString(),
    lastname: json["lastname"]?.toString(),
    mobileCode: json["mobile_code"]?.toString(),
    mobile: json["mobile"]?.toString(),
    image: json["image"]?.toString(),
    imageSrc: json["image_src"]?.toString(),
    status: json["status"]?.toString(),
    //  details: json["details"] == null || json["details"] == [] ? null : Details.fromJson(json["details"]),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    tags: json["tags"] == null ? [] : (json["tags"] as List).map((e) => Tag.fromJson(e)).toList(),
  );

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
    "details": details?.toJson(),
    "created_at": createdAt,
    "updated_at": updatedAt,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toJson())),
  };
}

class Tag {
  int? id;
  int? userId;
  String? name;
  String? createdAt;
  String? updatedAt;
  TagPivot? pivot;

  Tag({this.id, this.userId, this.name, this.createdAt, this.updatedAt, this.pivot});

  factory Tag.fromRawJson(String str) => Tag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    pivot: json["pivot"] == null ? null : TagPivot.fromJson(json["pivot"]),
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

class TagPivot {
  int? contactId;
  int? contactTagId;

  TagPivot({this.contactId, this.contactTagId});

  factory TagPivot.fromRawJson(String str) => TagPivot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TagPivot.fromJson(Map<String, dynamic> json) =>
      TagPivot(contactId: json["contact_id"], contactTagId: json["contact_tag_id"]);

  Map<String, dynamic> toJson() => {"contact_id": contactId, "contact_tag_id": contactTagId};
}

class Details {
  final String? age;
  final String? designation;
  final String? nickname;
  final String? address;
  final String? hobby;

  Details({this.age, this.designation, this.nickname, this.address, this.hobby});

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    age: json["age"]?.toString(),
    designation: json["designation"]?.toString(),
    nickname: json["nickname"]?.toString(),
    address: json["address"]?.toString(),
    hobby: json["hobby"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "age": age,
    "designation": designation,
    "nickname": nickname,
    "address": address,
    "hobby": hobby,
  };
}

class LastMessage {
  final String? id;
  final String? userId;
  final String? whatsappAccountId;
  final String? whatsappMessageId;
  final String? campaignId;
  final String? chatbotId;
  final String? templateId;
  final String? conversationId;
  final String? message;
  final String? type;
  final String? messageType;
  final String? mediaId;
  final String? mediaUrl;
  final String? mediaType;
  final String? mimeType;
  final String? mediaCaption;
  final String? mediaPath;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  LastMessage({
    this.id,
    this.userId,
    this.whatsappAccountId,
    this.whatsappMessageId,
    this.campaignId,
    this.chatbotId,
    this.templateId,
    this.conversationId,
    this.message,
    this.type,
    this.messageType,
    this.mediaId,
    this.mediaUrl,
    this.mediaType,
    this.mimeType,
    this.mediaCaption,
    this.mediaPath,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    whatsappAccountId: json["whatsapp_account_id"]?.toString(),
    whatsappMessageId: json["whatsapp_message_id"]?.toString(),
    campaignId: json["campaign_id"]?.toString(),
    chatbotId: json["chatbot_id"]?.toString(),
    templateId: json["template_id"]?.toString(),
    conversationId: json["conversation_id"]?.toString(),
    message: json["message"]?.toString(),
    type: json["type"]?.toString(),
    messageType: json["message_type"]?.toString(),
    mediaId: json["media_id"]?.toString(),
    mediaUrl: json["media_url"]?.toString(),
    mediaType: json["media_type"]?.toString(),
    mimeType: json["mime_type"]?.toString(),
    mediaCaption: json["media_caption"]?.toString(),
    mediaPath: json["media_path"]?.toString(),
    status: json["status"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "whatsapp_account_id": whatsappAccountId,
    "whatsapp_message_id": whatsappMessageId,
    "campaign_id": campaignId,
    "chatbot_id": chatbotId,
    "template_id": templateId,
    "conversation_id": conversationId,
    "message": message,
    "type": type,
    "message_type": messageType,
    "media_id": mediaId,
    "media_url": mediaUrl,
    "media_type": mediaType,
    "mime_type": mimeType,
    "media_caption": mediaCaption,
    "media_path": mediaPath,
    "status": status,
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
