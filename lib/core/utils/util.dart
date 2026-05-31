import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovowpp/data/model/global/formdata/global_keyc_form_data.dart';
import 'package:ovowpp/environment.dart';

import 'my_strings.dart';

class MyUtils {
  static void splashScreen() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: MyColor.getPrimaryColor(),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MyColor.getPrimaryColor(),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  static SystemUiOverlayStyle allScreen() {
    return SystemUiOverlayStyle(
      statusBarColor: MyColor.getPrimaryColor(),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: MyColor.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  static dynamic getShadow({Color? color, Offset? offset, double? blurRadius, double? spreadRadius}) {
    return [
      BoxShadow(
        blurRadius: blurRadius ?? 15.0,
        offset: offset ?? const Offset(0, 25),
        color: color ?? MyColor.getBackgroundColor().withValues(alpha: 0.6),
        spreadRadius: spreadRadius ?? -35.0,
      ),
    ];
  }

  static dynamic getShadow2({double blurRadius = 8, Color? color, Offset? offset, double? spreadRadius}) {
    return [
      BoxShadow(
        blurRadius: blurRadius,
        offset: offset ?? const Offset(0, 25),
        color: color ?? MyColor.getBackgroundColor().withValues(alpha: 0.6),
        spreadRadius: spreadRadius ?? -35.0,
      ),
      BoxShadow(
        blurRadius: blurRadius,
        offset: offset ?? const Offset(0, 1),
        color: color ?? MyColor.getBackgroundColor().withValues(alpha: 0.6),
        spreadRadius: spreadRadius ?? 1,
      ),
    ];
  }

  static dynamic getBottomSheetShadow() {
    return [
      BoxShadow(
        color: MyColor.getBackgroundColor().withValues(alpha: 0.08),
        spreadRadius: 3,
        blurRadius: 4,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static Future<bool> checkAndRequestStoragePermission() async {
    if (Platform.isAndroid) {
      // Use device_info_plus to check Android version
      int androidVersion = 0;
      try {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        androidVersion = androidInfo.version.sdkInt;
      } catch (e) {
        androidVersion = 29; // Default to 0 if there's an error
      }
      if (androidVersion >= 30) {
        // For Android 11 and higher (SDK 30+)
        var status = await Permission.mediaLibrary.status;
        if (!status.isGranted) {
          status = await Permission.mediaLibrary.request();
        }
        return status.isGranted;
      } else {
        // For Android 10 and below
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      // On iOS, check photo library or media permissions
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    } else {
      // For other platforms (e.g., web, desktop), return true
      return true;
    }
  }

  Future<void> openFile(String path, String extension) async {
    final file = File(path);
    if (await file.exists()) {
      final result = await OpenFile.open(path);
      printE(result.type);
      if (result.type == ResultType.permissionDenied) {
        CustomSnackBar.success(successList: ['File saved at: $path']);
      }
      if (result.type != ResultType.done) {
        if (result.type == ResultType.noAppToOpen) {
          CustomSnackBar.error(errorList: [MyStrings.noDocOpenerApp, 'File saved at: $path']);
        }
      }
    } else {
      CustomSnackBar.error(errorList: [MyStrings.fileNotFound]);
    }
  }

  static dynamic getCardShadow() {
    return [
      BoxShadow(
        color: MyColor.getBackgroundColor().withValues(alpha: 0.05),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static String getOperationTitle(String value) {
    String number = value;
    RegExp regExp = RegExp(r'^(\d+)(\w+)$');
    Match? match = regExp.firstMatch(number);
    if (match != null) {
      String? num = match.group(1) ?? '';
      String? unit = match.group(2) ?? '';
      String title = '${MyStrings.last.tr} $num ${unit.capitalizeFirst}';
      return title.tr;
    } else {
      return value.tr;
    }
  }

  String maskSensitiveInformation(String input) {
    if (input.isEmpty) {
      return '';
    }

    final int maskLength = input.length ~/ 2; // Mask half of the characters.
    final String mask = '*' * maskLength;
    final String maskedInput = maskLength > 4
        ? input.replaceRange(5, maskLength, mask)
        : input.replaceRange(0, maskLength, mask);
    return maskedInput;
  }

  static List<GlobalFormModle> dynamicFormSelectValueFormatter(List<GlobalFormModle>? dynamicFormList) {
    List<GlobalFormModle> mainFormList = [];

    if (dynamicFormList != null && dynamicFormList.isNotEmpty) {
      mainFormList.clear();

      for (var element in dynamicFormList) {
        if (element.type == 'select') {
          bool? isEmpty = element.options?.isEmpty;
          bool empty = isEmpty ?? true;
          if (element.options != null && empty != true) {
            if (!element.options!.contains(MyStrings.selectOne)) {
              element.options?.insert(0, MyStrings.selectOne);
            }

            element.selectedValue = element.options?.first;
            mainFormList.add(element);
          }
        } else {
          mainFormList.add(element);
        }
      }
    }
    return mainFormList;
  }

  List<Row> makeTwoPairWidget({required List<Widget> widgets}) {
    List<Row> pairs = [];
    for (int i = 0; i < widgets.length; i += 2) {
      Widget first = widgets[i];
      Widget? second = (i + 1 < widgets.length) ? widgets[i + 1] : const SizedBox();

      pairs.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: first),
            const SizedBox(width: Dimensions.space15),
            Expanded(child: second),
          ],
        ),
      );
    }

    return pairs;
  }

  void stopLandscape() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static Future<void> launchUrlToBrowser(String downloadUrl) async {
    try {
      final Uri url = Uri.parse(downloadUrl);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      printX(e.toString());
    }
  }

  static bool isImage(String path) {
    if (path.contains('.jpg')) {
      return true;
    }
    if (path.contains('.png')) {
      return true;
    }
    if (path.contains('.jpeg')) {
      return true;
    }
    return false;
  }

  static bool isXlsx(String path) {
    if (path.contains('.xlsx')) {
      return true;
    }
    if (path.contains('.xls')) {
      return true;
    }
    if (path.contains('.xlx')) {
      return true;
    }
    return false;
  }

  static bool isDoc(String path) {
    if (path.contains('.doc')) {
      return true;
    }
    if (path.contains('.docs')) {
      return true;
    }
    return false;
  }

  static String getFileType(String path) {
    final lowerPath = path.toLowerCase();

    if (lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.gif') ||
        lowerPath.endsWith('.bmp') ||
        lowerPath.endsWith('.webp')) {
      return 'image';
    }

    if (lowerPath.endsWith('.xlsx') || lowerPath.endsWith('.xls') || lowerPath.endsWith('.xlx')) {
      return 'excel';
    }

    if (lowerPath.endsWith('.doc') || lowerPath.endsWith('.docx')) {
      return 'word';
    }

    if (lowerPath.endsWith('.mp4') ||
        lowerPath.endsWith('.avi') ||
        lowerPath.endsWith('.mov') ||
        lowerPath.endsWith('.wmv') ||
        lowerPath.endsWith('.flv') ||
        lowerPath.endsWith('.mkv') ||
        lowerPath.endsWith('.webm') ||
        lowerPath.endsWith('.3gp')) {
      return 'video';
    }

    if (lowerPath.endsWith('.mp3') ||
        lowerPath.endsWith('.wav') ||
        lowerPath.endsWith('.aac') ||
        lowerPath.endsWith('.m4a') ||
        lowerPath.endsWith('.ogg') ||
        lowerPath.endsWith('.opus') ||
        lowerPath.endsWith('.mpeg') ||
        lowerPath.endsWith('.amr') ||
        lowerPath.endsWith('.flac') ||
        lowerPath.endsWith('.wma') ||
        lowerPath.endsWith('.aiff') ||
        lowerPath.endsWith('.alac')) {
      return 'audio';
    }

    return 'unknown';
  }

  static IconData getIconForExtension(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Icons.image;

      case '.pdf':
        return Icons.picture_as_pdf;

      case '.doc':
      case '.docx':
        return Icons.description;

      case '.xls':
      case '.xlsx':
        return Icons.table_chart;

      case '.ppt':
      case '.pptx':
        return Icons.slideshow;

      case '.mp3':
      case '.wav':
        return Icons.audiotrack;

      case '.mp4':
      case '.avi':
      case '.mov':
        return Icons.videocam;

      case '.zip':
      case '.rar':
      case '.7z':
        return Icons.archive;

      case '.txt':
        return Icons.note;

      case '.html':
      case '.css':
      case '.js':
      case '.json':
        return Icons.code;

      default:
        return Icons.insert_drive_file;
    }
  }

  static bool isURL(String urlString) {
    Uri? uri = Uri.tryParse(urlString);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  static TextInputType getInputTextFieldType(String type) {
    if (type == "email") {
      return TextInputType.emailAddress;
    } else if (type == "number") {
      return TextInputType.number;
    } else if (type == "url") {
      return TextInputType.url;
    }
    return TextInputType.text;
  }

  static bool getTextInputType(String type) {
    if (type == "text") {
      return true;
    } else if (type == "email") {
      return true;
    } else if (type == "number") {
      return true;
    } else if (type == "url") {
      return true;
    } else if (type == "textarea") {
      return true;
    }
    return false;
  }

  static bool checkPermission(String permissionName) {
    return Get.find<DashboardController>().permissionList.contains(permissionName) ||
        Get.find<DashboardController>().user?.isAgent == "0";
  }
}

void printX(Object? object) {
  if (Environment.DEV_MODE) {
    // print(object);
    var logger = Logger();
    logger.i("$object");
  }
}

void printE(Object? object) {
  if (Environment.DEV_MODE) {
    // print(object);
    var logger = Logger();
    logger.e("$object");
  }
}

void printW(Object? object) {
  if (Environment.DEV_MODE) {
    // print(object);
    var logger = Logger();
    logger.w("$object");
  }
}
