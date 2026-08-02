import 'dart:convert';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/utils/util.dart';
import '../../model/home/chat_list_response_model.dart';
import '../../services/push_notification_service.dart';
import '../../services/pusher_service.dart';
import '../chat/chat_controller.dart';
import 'home_controller.dart';

class PusherHomeServiceController extends GetxController {
  late final HomeController controller;

  @override
  void onInit() {
    super.onInit();
    controller = Get.find();
    PusherManager().addListener(onEvent);
  }

  void onEvent(PusherEvent event) async {
    try {
      // printX("HomeService onEvent: ${event.data}");
      if (event.data.toString() == "{}") return;
      var msgData = jsonDecode(event.data);
      bool isNewContact = msgData["data"]["newContact"].toString() == "true";
      bool isNewMsg = msgData["data"]["newMessage"]?.toString() == "true";
      String unseenMsgCount = msgData["data"]["unseenMessage"].toString();
      LastMessage msg = LastMessage.fromJson(msgData["data"]["message"]);

      if (isNewContact) {
        controller.homeData();
      } else {
        var currentList = controller.newChatData;
        int index = currentList.indexWhere((e) => e.lastMessage?.conversationId == msg.conversationId);

        if (index != -1) {
          currentList[index] = currentList[index].copyWith(
            lastMessage: msg,
            lastMessageAt: msg.createdAt,
            unseenMessages: unseenMsgCount,
          );
          controller.update();
        }

        // Show in-app notification if new message and user is not
        // already on the chat screen for this conversation
        if (isNewMsg && msg.type?.toString() == "2") {
          bool isOnThisChat = false;
          if (Get.isRegistered<ChatController>()) {
            final chatCtrl = Get.find<ChatController>();
            isOnThisChat = chatCtrl.conversationId.toString() == msg.conversationId.toString();
          }

          if (!isOnThisChat) {
            String contactName = 'New Message';
            if (currentList.isNotEmpty && index != -1) {
              final c = currentList[index].contact;
              final fn = c?.firstname?.trim() ?? '';
              final ln = c?.lastname?.trim() ?? '';
              final full = '$fn $ln'.trim();
              if (full.isNotEmpty) contactName = full;
            }
            final body = (msg.message?.trim().isNotEmpty == true)
                ? msg.message!
                : (msg.messageType != null ? '📎 Attachment' : 'New message');

            await PushNotificationService.showInAppMessageNotification(
              title: contactName,
              body: body,
              conversationId: msg.conversationId?.toString(),
            );
          }

        }
      }
    } catch (e) {
      printE("HomeService onEvent error: $e");
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
