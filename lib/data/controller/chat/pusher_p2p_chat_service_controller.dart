import 'dart:convert';
import 'package:flutter/widgets.dart';
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
      printX("ChatScrren onEvent: ${event.data}");
      var msgData = jsonDecode(event.data);
      bool isNewMsg = msgData["data"]["newMessage"].toString() == "true";
      MessagesData msg = MessagesData.fromJson(msgData["data"]["message"]);

      if (controller.conversationId == msg.conversationId && isNewMsg) {
        final shouldShowNewMessage = controller.isNearLatestMessage;
        final wasInserted = controller.insertMessageIfAbsent(msg);
        if (!wasInserted) return;
        controller.update(['chat_screen_main']);

        // A realtime callback can run while Flutter has no pending frame.
        // Explicitly request one so the message appears without a screen tap.
        WidgetsBinding.instance.ensureVisualUpdate();
        if (shouldShowNewMessage) {
          controller.scrollToLatestMessage();
        }
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
