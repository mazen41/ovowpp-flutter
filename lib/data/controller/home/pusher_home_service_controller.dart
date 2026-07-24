import 'dart:convert';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/utils/util.dart';
import '../../model/home/chat_list_response_model.dart';
import '../../services/pusher_service.dart';
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
