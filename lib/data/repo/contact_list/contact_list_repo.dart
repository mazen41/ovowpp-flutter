import 'dart:io';

import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/chat/message_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class ContactListRepo {
  Future<ResponseModel> getContactListDataRepo(String page, String search) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.contactListDataEndPoint}?search=$search&page=$page';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> sendMessageRepo(MessageModel messageModel) async {
    final map = {'conversation_id': messageModel.chatId, 'message': messageModel.message};

    Map<String, File> attachmentFile = {};

    if (messageModel.file != null) {
      final filePath = messageModel.file!.path.toLowerCase();

      String key;
      if (filePath.endsWith('.jpg') ||
          filePath.endsWith('.jpeg') ||
          filePath.endsWith('.png') ||
          filePath.endsWith('.gif') ||
          filePath.endsWith('.webp')) {
        key = 'image';
      } else if (filePath.endsWith('.mp4')) {
        key = 'video';
      } else {
        key = 'file';
      }

      attachmentFile = {key: messageModel.file!};
    }

    String url = '${UrlContainer.baseUrl}${UrlContainer.sendMessageUrl}';
    final response = await ApiService.postMultiPartRequest(url, map, attachmentFile);
    return response;
  }
}
