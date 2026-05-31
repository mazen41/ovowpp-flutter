import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import '../../core/utils/url_container.dart';
import '../../core/utils/util.dart';
import 'api_service.dart';

class PusherManager {
  static final PusherManager _instance = PusherManager._internal();
  factory PusherManager() => _instance;
  PusherManager._internal();

  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  final List<void Function(PusherEvent)> _listeners = [];

  Future<void> init(
    String channelName, {
    required String apiKey,
    required String cluster,
    required Future<dynamic> Function(String channelName, String socketId, dynamic options) onAuthorizer,
    Function(String message, int? code, dynamic e)? onError,
    Function(String message, dynamic e)? onSubscriptionError,
    Function(String channelName, dynamic data)? onSubscriptionSucceeded,
  }) async {
    await pusher.init(
      apiKey: apiKey,
      cluster: cluster,
      onConnectionStateChange: (_, _) {},
      onEvent: _dispatchEvent,
      onError: onError,
      onSubscriptionError: onSubscriptionError,
      onSubscriptionSucceeded: onSubscriptionSucceeded,
      onAuthorizer: onAuthorizer,
      onDecryptionFailure: (_, _) {},
      onMemberAdded: (_, _) {},
      onMemberRemoved: (_, _) {},
    );

    await pusher.subscribe(channelName: channelName);
    await pusher.connect();
  }

  void _dispatchEvent(PusherEvent event) {
    for (var listener in _listeners) {
      listener(event);
    }
  }

  void addListener(void Function(PusherEvent) listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
      printX("👂 Listener added. Total: ${_listeners.length}");
    }
  }

  void removeListener(void Function(PusherEvent) listener) {
    _listeners.remove(listener);
  }

  bool isConnected() => pusher.connectionState != 'disconnected';

  Future<void> checkAndInitIfNeeded(String channelName) async {
    printE(channelName);
    final state = pusher.connectionState;
    printE(state);
    if (state.toLowerCase() == 'disconnected' || state == 'disconnecting' || state == 'connecting') {
      printX("🔄 Pusher state: $state. Reinitializing...");

      final apiKey =
          SharedPreferenceService.getGeneralSettingData().data?.generalSetting?.pusherConfig?.pusherAppKey ?? "";
      final cluster =
          SharedPreferenceService.getGeneralSettingData().data?.generalSetting?.pusherConfig?.pusherAppCluster ?? "";
      printE(apiKey);
      printE(cluster);
      await init(
        channelName,
        apiKey: apiKey,
        cluster: cluster,
        onAuthorizer: (channelName, socketId, options) async {
          var authUrl = "${UrlContainer.baseUrl}${UrlContainer.pusherAuthApiURl}/$socketId/$channelName";
          var result = await ApiService.postRequest(authUrl, {});
          return result.responseJson;
        },
        onError: (msg, code, e) => printX("Pusher Error: ${e.toString()}"),
        onSubscriptionError: (msg, e) => printX("Sub Error: $msg"),
        onSubscriptionSucceeded: (channel, data) => printX("✅ Subscribed: $channel"),
      );
    } else {
      printX("✅ Pusher already connected: $state");

      // Check if channel is already subscribed
      final isSubscribed = pusher.getChannel(channelName) != null;
      if (!isSubscribed) {
        printX("📡 Subscribing to new channel: $channelName");
        await pusher.subscribe(channelName: channelName);
      } else {
        printX("🔁 Already subscribed to: $channelName");
      }
    }
  }
}
