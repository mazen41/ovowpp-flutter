import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/core/theme/my_theme.dart';
import 'package:ovowpp/core/translations/localization_controller.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:toastification/toastification.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/services/api_service.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/environment.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/messages.dart';
import 'package:ovowpp/data/services/push_notification_service.dart';
import 'core/di_service/di_services.dart' as di_service;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Stop Landscape
  MyUtils().stopLandscape();
  // init shared preference
  await SharedPreferenceService.init();
  // inti fcm services
  await PushNotificationService().setupInteractedMessage();
  //Api inits
  ApiService.init();
  //Dependency injection
  await di_service.initDependency();
  runApp(const OvoApp());
}

//APP ENTRY POINT
class OvoApp extends StatefulWidget {
  const OvoApp({super.key});

  @override
  State<OvoApp> createState() => _OvoAppState();
}

class _OvoAppState extends State<OvoApp> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final size = MediaQuery.of(context).size;
        Size designSize;
        if (size.width > 900) {
          designSize = orientation == Orientation.landscape ? const Size(1400, 900) : const Size(900, 1400);
        } else if (size.width > 600) {
          designSize = orientation == Orientation.landscape ? const Size(1200, 800) : const Size(800, 1200);
        } else if (size.width > 430) {
          designSize = orientation == Orientation.landscape
              ? const Size(1000, 450)
              : const Size(450, 1000);
        } else {
          designSize = orientation == Orientation.landscape ? const Size(812, 375) : const Size(375, 812);
        }

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          rebuildFactor: (old, data) => true,
          builder: (context, w) {
            return ToastificationWrapper(
              child: GetMaterialApp(
                title: Environment.appName,
                debugShowCheckedModeBanner: false,
                defaultTransition: Transition.noTransition,
                transitionDuration: const Duration(milliseconds: 200),
                initialRoute: RouteHelper.splashScreen,
                navigatorKey: Get.key,
                getPages: RouteHelper().routes,
                locale: LocalizationController().locale,
                translations: Messages(),
                // Always fall back to English so keys never show raw
                fallbackLocale: const Locale('en', 'US'),
                builder: (context, widget) {
                  bool themeIsLight = SharedPreferenceService.getThemeIsLight();
                  return Theme(
                    data: MyTheme.getThemeData(isLight: themeIsLight),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
                      child: widget!,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
