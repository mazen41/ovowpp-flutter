import 'dart:convert';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/utils/util.dart';
import '../../model/chat/chat_data_response_model.dart';
import '../../repo/chat/chat_repo.dart';
import '../../services/pusher_service.dart';
import 'chat_controller.dart';

class PusherChatServiceController extends GetxController {
  final ChatRepo repo;
  late final ChatController controller;

  PusherChatServiceController({required this.repo});

  @override
  void onInit() {
    super.onInit();
    controller = Get.find();
    PusherManager().addListener(onEvent);
  }

  void onEvent(PusherEvent event) {
    try {
      var msgData = jsonDecode(event.data);
      bool isNewMsg = msgData["data"]["newMessage"].toString() == "true";
      MessagesData msg = MessagesData.fromJson(msgData["data"]["message"]);

      bool messageExists = controller.messages.any((m) => m.id == msg.id);

      if (!messageExists && controller.conversationId == msg.conversationId && isNewMsg) {
        controller.messages.insert(0, msg);
        controller.update();
      }

      if (controller.conversationId == msg.conversationId && !isNewMsg) {
        controller.messages.firstWhereOrNull((e) => e.id == msg.id)?.status = msg.status;
        controller.update();
      }
    } catch (e) {
      printE("ChatService onEvent error: $e");
    }
  }

  @override
  void onClose() {
    PusherManager().removeListener(onEvent);
    super.onClose();
  }

  Future<void> ensureConnection(String channelName) async {
    await PusherManager().checkAndInitIfNeeded(channelName);
  }
}
