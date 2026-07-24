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
  runApp(OvoApp(languages: {}));
}

//APP ENTRY POINT
class OvoApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const OvoApp({super.key, required this.languages});

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
          // **Tablets or Large Screens**
          designSize = orientation == Orientation.landscape ? const Size(1400, 900) : const Size(900, 1400);
        } else if (size.width > 600) {
          // **Medium-sized tablets**
          designSize = orientation == Orientation.landscape ? const Size(1200, 800) : const Size(800, 1200);
        } else if (size.width > 430) {
          // **Big Phones like Galaxy S24 Ultra, iPhone 15 Pro Max**
          designSize = orientation == Orientation.landscape
              ? const Size(1000, 450) // Adjust for landscape
              : const Size(450, 1000); // Adjust for portrait
        } else {
          // **Default mobile phones**
          designSize = orientation == Orientation.landscape ? const Size(812, 375) : const Size(375, 812);
        }

        return ScreenUtilInit(
          // todo add your (Xd / Figma) artboard size
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
                // initialRoute: RouteHelper.verifyPassCodeScreen,
                navigatorKey: Get.key,
                getPages: RouteHelper().routes,
                locale: LocalizationController().locale,
                translations: Messages(languages: widget.languages),
                fallbackLocale: Locale(
                  LocalizationController().locale.languageCode,
                  LocalizationController().locale.countryCode,
                ),
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
