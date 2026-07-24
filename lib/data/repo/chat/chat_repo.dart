import 'dart:io';
import '../../../core/utils/url_container.dart';
import '../../../core/utils/util.dart';
import '../../model/chat/message_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class ChatRepo {
  // ─── Fetch messages ────────────────────────────────────────────────────────

  Future<ResponseModel> getChatsDataRepo(String conversationId, String page, String search) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.chatsDataEndPoint}$conversationId?page=$page&search=$search';
    return ApiService.getRequest(url);
  }

  /// Fetch inbox metadata: templates, CTA URLs, interactive lists.
  Future<ResponseModel> getInboxDataRepo() async {
    return ApiService.getRequest('${UrlContainer.baseUrl}${UrlContainer.inboxDataUrl}');
  }

  // ─── Message status ────────────────────────────────────────────────────────

  Future<ResponseModel> seenMessageRepo(String conversationId) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.seenMessageUrl}/$conversationId';
    return ApiService.getRequest(url);
  }

  // ─── Send message ──────────────────────────────────────────────────────────

  Future<ResponseModel> sendMessageRepo(MessageModel messageModel, String? chatId) async {
    final Map<String, dynamic> map = {};

    // Validate conversation_id for new messages
    if (chatId == null && messageModel.chatId.isEmpty) {
      return ResponseModel(
        isSuccess: false,
        message: 'Conversation ID is required',
        statusCode: 400,
        responseJson: {'status': 'error', 'message': ['Conversation ID is required']},
      );
    }

    if (chatId == null) {
      map.addAll({
        'conversation_id': messageModel.chatId,
        'message': messageModel.message,
      });
      if (messageModel.id != null && messageModel.id!.isNotEmpty) {
        map['wa_message_id'] = messageModel.id;
      }
    } else {
      map.addAll({'message_id': chatId});
    }

    Map<String, File> attachmentFile = {};

    if (messageModel.file != null) {
      final filePath = messageModel.file!.path.toLowerCase();
      printE("filePath $filePath");
      String key;
      if (filePath.endsWith('.jpg') ||
          filePath.endsWith('.jpeg') ||
          filePath.endsWith('.png') ||
          filePath.endsWith('.gif') ||
          filePath.endsWith('.webp')) {
        key = 'image';
      } else if (filePath.endsWith('.mp4') ||
          filePath.endsWith('.mov') ||
          filePath.endsWith('.webm')) {
        key = 'video';
      } else if (filePath.endsWith('.ogg') ||
          filePath.endsWith('.opus') ||
          filePath.endsWith('.m4a') ||
          filePath.endsWith('.mp3') ||
          filePath.endsWith('.wav') ||
          filePath.endsWith('.aac') ||
          filePath.endsWith('.mpeg') ||
          filePath.endsWith('.amr') ||
          filePath.endsWith('.flac') ||
          filePath.endsWith('.wma') ||
          filePath.endsWith('.aiff') ||
          filePath.endsWith('.alac')) {
        key = 'audio';
      } else {
        key = 'document';
      }

      attachmentFile = {key: messageModel.file!};
    }

    String url =
        '${UrlContainer.baseUrl}${chatId != null ? UrlContainer.resendMessageUrl : UrlContainer.sendMessageUrl}';
    printX('Sending message with data: $map');
    final response = await ApiService.postMultiPartRequest(url, map, attachmentFile);
    printW(response.responseJson);
    return response;
  }

  /// Send an approved message template.
  ///
  /// [mobileCode] and [mobile] must belong to the contact of the currently
  /// open conversation - the backend resolves/creates the recipient purely
  /// from these two fields, so passing the wrong number sends the template
  /// to the wrong (or a brand new) contact.
  Future<ResponseModel> sendTemplateMessageRepo(
    String conversationId,
    String templateId, {
    required String mobileCode,
    required String mobile,
  }) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.sendTemplateMessageUrl}';

    // Validate required parameters
    if (conversationId.isEmpty) {
      return ResponseModel(
        isSuccess: false,
        message: 'Conversation ID is required',
        statusCode: 400,
        responseJson: {'status': 'error', 'message': ['Conversation ID is required']},
      );
    }

    if (templateId.isEmpty) {
      return ResponseModel(
        isSuccess: false,
        message: 'Template ID is required',
        statusCode: 400,
        responseJson: {'status': 'error', 'message': ['Template ID is required']},
      );
    }

    if (mobileCode.isEmpty || mobile.isEmpty) {
      return ResponseModel(
        isSuccess: false,
        message: 'Recipient mobile number is required',
        statusCode: 400,
        responseJson: {'status': 'error', 'message': ['Recipient mobile number is required']},
      );
    }

    final requestData = {
      'conversation_id': conversationId,
      'template_id': templateId,
      // Left empty on purpose: the backend now auto-fills header/body
      // parameters from the template's stored media/example values so no
      // user input is required (see WhatsAppLib::sendTemplateMessage).
      'header_variables': [],
      'body_variables': [],
      'mobile_code': mobileCode,
      'mobile': mobile,
    };

    printX('Sending template with data: $requestData');
    return ApiService.postRequest(url, requestData);
  }

  /// Send a CTA URL message.
  Future<ResponseModel> sendCtaUrlMessageRepo(String conversationId, String ctaUrlId) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.sendMessageUrl}';
    return ApiService.postRequest(url, {
      'conversation_id': conversationId,
      'cta_url_id': ctaUrlId,
    });
  }

  /// Send an interactive list message.
  Future<ResponseModel> sendInteractiveListMessageRepo(String conversationId, String listId) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.sendMessageUrl}';
    return ApiService.postRequest(url, {
      'conversation_id': conversationId,
      'interactive_list_id': listId,
    });
  }

  /// Send a location message.
  Future<ResponseModel> sendLocationMessageRepo(
    String conversationId,
    double latitude,
    double longitude, {
    String name = '',
    String address = '',
  }) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.sendMessageUrl}';
    return ApiService.postRequest(url, {
      'conversation_id': conversationId,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'name': name,
      'address': address,
    });
  }

  // ─── Media ─────────────────────────────────────────────────────────────────

  Future<ResponseModel> downloadFileRepo(String mediaId, String filePath) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.downloadMediaDataEndPoint}$mediaId';
    return ApiService.downloadFile(url, filePath);
  }

  // ─── Conversation management ───────────────────────────────────────────────

  /// Clear all messages in a conversation (permanent).
  Future<ResponseModel> clearChatRepo(String conversationId) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.clearChatUrl}$conversationId';
    return ApiService.postRequest(url, {});
  }

  /// Block or unblock a contact.
  Future<ResponseModel> blockContactRepo(String contactId, bool isBlocked) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.blockContactUrl}$contactId';
    return ApiService.postRequest(url, {'is_blocked': isBlocked ? '1' : '0'});
  }
}

