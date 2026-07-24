import 'dart:io';

class MessageModel {
  String chatId;
  String? id;
  String message;
  File? file;

  MessageModel({required this.chatId, this.id, required this.message, this.file});
}
