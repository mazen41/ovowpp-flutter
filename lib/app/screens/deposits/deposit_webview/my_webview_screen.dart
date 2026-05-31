import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../components/app-bar/custom_app_bar.dart';
import 'webview_widget.dart';

class MyWebViewScreen extends StatefulWidget {
  final String redirectUrl;

  const MyWebViewScreen({super.key, required this.redirectUrl});

  @override
  State<MyWebViewScreen> createState() => _MyWebViewScreenState();
}

class _MyWebViewScreenState extends State<MyWebViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: MyStrings.payNow.tr, isShowBackBtn: true),
        body: MyWebViewWidget(url: widget.redirectUrl),
        floatingActionButton: favoriteButton(),
      ),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      backgroundColor: MyColor.getErrorColor(),
      onPressed: () async {
        Get.back();
      },
      child: Icon(Icons.cancel, color: MyColor.white, size: 30),
    );
  }

  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.microphone,
      Permission.mediaLibrary,
      Permission.camera,
      Permission.storage,
    ].request();

    return statuses;
  }
}
