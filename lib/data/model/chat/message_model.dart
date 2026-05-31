import 'dart:io';

class MessageModel {
  String chatId;
  String message;
  File? file;

  MessageModel({required this.chatId, required this.message, this.file});
}
