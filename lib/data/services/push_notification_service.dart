import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/url_container.dart';
import '../../firebase_options.dart';
import 'api_service.dart';

// ─── Singleton plugin instance — shared by the entire app ─────────────────────
// Export it so pusher_p2p_chat_service_controller can call showInAppMessageNotification.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferenceService.setBool(
      SharedPreferenceService.hasNewNotificationKey, true);
}

class PushNotificationService {
  PushNotificationService();

  static AndroidNotificationChannel _channel() =>
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        playSound: true,
        enableVibration: true,
        enableLights: true,
        importance: Importance.high,
      );

  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await _requestPermissions();

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final conversationId =
          message.data['conversation_id']?.toString() ?? '';
      if (conversationId.isNotEmpty) {
        Get.toNamed(RouteHelper.chatScreen,
            arguments: [conversationId, '']);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {});

    messaging.getToken().then((value) {});
    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  Future<void> registerNotificationListeners() async {
    final channel = _channel();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        try {
          final payloadString = response.payload;
          if (payloadString != null && payloadString.isNotEmpty) {
            final Map<dynamic, dynamic> payloadMap =
                jsonDecode(payloadString);
            final conversationId =
                payloadMap['conversation_id']?.toString() ?? '';
            if (conversationId.isNotEmpty) {
              await Future.delayed(const Duration(milliseconds: 300));
              Get.toNamed(RouteHelper.chatScreen,
                  arguments: [conversationId, '']);
            }
          }
        } catch (e) {
          if (kDebugMode) printE(e.toString());
        }
      },
    );

    // ── FCM foreground messages (server push notifications) ───────────────────
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      final notification = message!.notification;
      final android = message.notification?.android;
      if (notification != null && android != null) {
        late BigPictureStyleInformation bigPictureStyle;
        if (android.imageUrl != null) {
          final http.Response response =
              await http.get(Uri.parse(android.imageUrl!));
          final String localImagePath =
              await _saveImageLocally(response.bodyBytes);
          bigPictureStyle = BigPictureStyleInformation(
            FilePathAndroidBitmap(localImagePath),
            contentTitle: notification.title,
            summaryText: notification.body,
          );
        }

        flutterLocalNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              playSound: true,
              enableVibration: true,
              enableLights: true,
              fullScreenIntent: true,
              priority: Priority.high,
              styleInformation: android.imageUrl != null
                  ? bigPictureStyle
                  : const BigTextStyleInformation(''),
              importance: Importance.high,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  // ─── Call this from the Pusher handler to play sound + show banner ────────────
  // Works while the app is open (foreground) for real-time WhatsApp messages.
  static Future<void> showInAppMessageNotification({
    required String title,
    required String body,
    String? conversationId,
  }) async {
    final channel = _channel();
    final payload = conversationId != null
        ? jsonEncode({'conversation_id': conversationId})
        : null;

    await flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          priority: Priority.high,
          importance: Importance.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentBadge: true,
          presentAlert: true,
        ),
      ),
      payload: payload,
    );
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() => _channel();

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<String> _saveImageLocally(Uint8List bytes) async {
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/notification_image.png';
    final file = File(imagePath);
    await file.writeAsBytes(bytes);
    return imagePath;
  }

  Future<bool> sendUserToken() async {
    String deviceToken;
    if (SharedPreferenceService.containsKey(
        SharedPreferenceService.fcmDeviceKey)) {
      deviceToken = SharedPreferenceService.getString(
          SharedPreferenceService.fcmDeviceKey);
    } else {
      deviceToken = '';
    }

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    bool success = false;
    if (deviceToken.isEmpty) {
      firebaseMessaging.getToken().then((fcmDeviceToken) async {
        success = await sendUpdatedToken(fcmDeviceToken ?? '');
      });
    } else {
      firebaseMessaging.onTokenRefresh.listen((fcmDeviceToken) async {
        if (deviceToken == fcmDeviceToken) {
          success = true;
        } else {
          SharedPreferenceService.setString(
              SharedPreferenceService.fcmDeviceKey, fcmDeviceToken);
          success = await sendUpdatedToken(fcmDeviceToken);
        }
      });
    }
    return success;
  }

  Future<bool> sendUpdatedToken(String deviceToken) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.deviceTokenEndPoint}';
    Map<String, String> map = deviceTokenMap(deviceToken);
    ResponseModel model = await ApiService.postRequest(url, map);
    if (model.isSuccess) {
      return true;
    } else {
      return false;
    }
  }

  Map<String, String> deviceTokenMap(String deviceToken) {
    Map<String, String> map = {'token': deviceToken.toString()};
    return map;
  }
}
