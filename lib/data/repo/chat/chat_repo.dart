import 'dart:io';
import '../../../core/utils/url_container.dart';
import '../../../core/utils/util.dart';
import '../../model/chat/message_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class ChatRepo {
  Future<ResponseModel> getChatsDataRepo(String conversationId, String page, String search) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.chatsDataEndPoint}$conversationId?page=$page&search=$search';
    ResponseModel responseModel = await ApiService.getRequest(url);

    return responseModel;
  }

  Future<ResponseModel> seenMessageRepo(String conversationId) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.seenMessageEndPoint}$conversationId';
    ResponseModel responseModel = await ApiService.getRequest(url);

    return responseModel;
  }

  Future<ResponseModel> downloadFileRepo(String mediaId, String filePath) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.downloadMediaDataEndPoint}$mediaId';
    ResponseModel responseModel = await ApiService.downloadFile(url, filePath);

    return responseModel;
  }

  Future<ResponseModel> sendMessageRepo(MessageModel messageModel, String? chatId) async {
    final Map<String, dynamic> map = {};

    if (chatId == null) {
      map.addAll({'conversation_id': messageModel.chatId, 'message': messageModel.message});
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
      } else if (filePath.endsWith('.mp4')) {
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
    final response = await ApiService.postMultiPartRequest(url, map, attachmentFile);
    printW(response.responseJson);
    return response;
  }
}
