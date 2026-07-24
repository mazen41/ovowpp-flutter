import 'dart:convert';

import '../customer_details/customer_details_response_model.dart';

ChatDataResponseModel chatDataResponseModelFromJson(String str) => ChatDataResponseModel.fromJson(json.decode(str));

String chatDataResponseModelToJson(ChatDataResponseModel data) => json.encode(data.toJson());

class ChatDataResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  ChatDataResponseModel({this.remark, this.status, this.message, this.data});

  factory ChatDataResponseModel.fromJson(Map<String, dynamic> json) => ChatDataResponseModel(
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
  Messages? messages;
  Contact? contact;
  String? profilePath;
  String? filePath;
  String? mediaBasePath;
  String? whatsappAccountId;

  Data({this.messages, this.contact, this.profilePath, this.filePath, this.mediaBasePath, this.whatsappAccountId});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    messages: json["messages"] == null ? null : Messages.fromJson(json["messages"]),
    contact: json["contact"] == null ? null : Contact.fromJson(json["contact"]),
    profilePath: json["profilePath"]?.toString(),
    mediaBasePath: json["mediaBasePath"]?.toString(),
    filePath: json["file_path"]?.toString(),
    whatsappAccountId: json["whatsapp_account_id"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "messages": messages?.toJson(),
    "contact": contact?.toJson(),
    "profilePath": profilePath,
    "file_path": filePath,
    "mediaBasePath": mediaBasePath,
    "whatsapp_account_id": whatsappAccountId,
  };
}

class Messages {
  String? currentPage;
  List<MessagesData>? data;
  String? firstPageUrl;
  String? from;
  String? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  String? perPage;
  String? prevPageUrl;
  String? to;
  String? total;

  Messages({
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

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    currentPage: json["current_page"]?.toString(),
    data: json["data"] == null ? [] : List<MessagesData>.from(json["data"]!.map((x) => MessagesData.fromJson(x))),
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

class MessagesData {
  String? id;
  String? userId;
  String? whatsappMessageId;
  MessageReplayTo? replayTo;
  String? whatsappAccountId;
  String? campaignId;
  String? chatbotId;
  String? templateId;
  String? conversationId;
  String? message;
  String? type;
  String? messageType;
  String? mediaId;
  String? mediaUrl;
  String? mediaFilename;
  String? mediaType;
  String? mimeType;
  String? mediaCaption;
  String? mediaPath;
  String? status;
  String? createdAt;
  String? updatedAt;

  MessagesData({
    this.id,
    this.userId,
    this.whatsappMessageId,
    this.replayTo,
    this.whatsappAccountId,
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
    this.mediaFilename,
    this.mimeType,
    this.mediaCaption,
    this.mediaPath,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MessagesData.fromJson(Map<String, dynamic> json) => MessagesData(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    whatsappMessageId: json["whatsapp_message_id"]?.toString(),
    replayTo: json["reply_to"] == null ? null : MessageReplayTo.fromJson(json["reply_to"]),
    whatsappAccountId: json["whatsapp_account_id"]?.toString(),
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
    mediaFilename: json["media_filename"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "whatsapp_message_id": whatsappMessageId,
    "reply_to": replayTo?.toJson(),
    "whatsapp_account_id": whatsappAccountId,
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
    "media_filename": mediaFilename,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class MessageReplayTo {
  String? id;
  String? userId;
  String? whatsappMessageId;
  String? replyTo;
  String? whatsappAccountId;
  String? campaignId;
  String? chatbotId;
  String? templateId;
  String? conversationId;
  String? agentId;
  String? ctaUrlId;
  String? interactiveListId;
  String? message;
  String? type;
  String? messageType;
  String? mediaId;
  String? mediaUrl;
  String? mediaType;
  String? mimeType;
  String? mediaCaption;
  String? mediaFilename;
  String? mediaPath;
  String? location;
  String? productData;
  String? listReply;
  String? sendAt;
  String? status;
  String? ordering;
  String? aiReply;
  String? flowId;
  String? flowNodeId;
  String? errorMessage;
  String? channel;
  String? createdAt;
  String? updatedAt;

  MessageReplayTo({
    this.id,
    this.userId,
    this.whatsappMessageId,
    this.replyTo,
    this.whatsappAccountId,
    this.campaignId,
    this.chatbotId,
    this.templateId,
    this.conversationId,
    this.agentId,
    this.ctaUrlId,
    this.interactiveListId,
    this.message,
    this.type,
    this.messageType,
    this.mediaId,
    this.mediaUrl,
    this.mediaType,
    this.mimeType,
    this.mediaCaption,
    this.mediaFilename,
    this.mediaPath,
    this.location,
    this.productData,
    this.listReply,
    this.sendAt,
    this.status,
    this.ordering,
    this.aiReply,
    this.flowId,
    this.flowNodeId,
    this.errorMessage,
    this.channel,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageReplayTo.fromRawJson(String str) => MessageReplayTo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageReplayTo.fromJson(Map<String, dynamic> json) => MessageReplayTo(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    whatsappMessageId: json["whatsapp_message_id"]?.toString(),
    replyTo: json["reply_to"]?.toString(),
    whatsappAccountId: json["whatsapp_account_id"]?.toString(),
    campaignId: json["campaign_id"]?.toString(),
    chatbotId: json["chatbot_id"]?.toString(),
    templateId: json["template_id"]?.toString(),
    conversationId: json["conversation_id"]?.toString(),
    agentId: json["agent_id"]?.toString(),
    ctaUrlId: json["cta_url_id"]?.toString(),
    interactiveListId: json["interactive_list_id"]?.toString(),
    message: json["message"]?.toString(),
    type: json["type"]?.toString(),
    messageType: json["message_type"]?.toString(),
    mediaId: json["media_id"]?.toString(),
    mediaUrl: json["media_url"]?.toString(),
    mediaType: json["media_type"]?.toString(),
    mimeType: json["mime_type"]?.toString(),
    mediaCaption: json["media_caption"]?.toString(),
    mediaFilename: json["media_filename"]?.toString(),
    mediaPath: json["media_path"]?.toString(),
    location: json["location"]?.toString(),
    productData: json["product_data"]?.toString(),
    listReply: json["list_reply"]?.toString(),
    sendAt: json["send_at"]?.toString(),
    status: json["status"]?.toString(),
    ordering: json["ordering"]?.toString(),
    aiReply: json["ai_reply"]?.toString(),
    flowId: json["flow_id"]?.toString(),
    flowNodeId: json["flow_node_id"]?.toString(),
    errorMessage: json["error_message"]?.toString(),
    channel: json["channel"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "whatsapp_message_id": whatsappMessageId,
    "reply_to": replyTo,
    "whatsapp_account_id": whatsappAccountId,
    "campaign_id": campaignId,
    "chatbot_id": chatbotId,
    "template_id": templateId,
    "conversation_id": conversationId,
    "agent_id": agentId,
    "cta_url_id": ctaUrlId,
    "interactive_list_id": interactiveListId,
    "message": message,
    "type": type,
    "message_type": messageType,
    "media_id": mediaId,
    "media_url": mediaUrl,
    "media_type": mediaType,
    "mime_type": mimeType,
    "media_caption": mediaCaption,
    "media_filename": mediaFilename,
    "media_path": mediaPath,
    "location": location,
    "product_data": productData,
    "list_reply": listReply,
    "send_at": sendAt,
    "status": status,
    "ordering": ordering,
    "ai_reply": aiReply,
    "flow_id": flowId,
    "flow_node_id": flowNodeId,
    "error_message": errorMessage,
    "channel": channel,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
