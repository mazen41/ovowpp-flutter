import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/app/components/dialog/exit_dialog.dart';
import 'package:ovowpp/core/utils/text_style.dart';

import '../../../core/utils/util_exporter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isShowBackBtn;
  final Color? bgColor;
  final bool isShowActionBtn;
  final bool isTitleCenter;
  final bool fromAuth;
  final bool isProfileCompleted;
  final List<Widget>? action;
  final double elevation;
  final VoidCallback? backButtonOnPress;
  final double fontSize;

  const CustomAppBar({
    super.key,
    this.isProfileCompleted = false,
    this.fromAuth = false,
    this.isTitleCenter = false,
    this.bgColor,
    this.isShowBackBtn = true,
    required this.title,
    this.isShowActionBtn = false,
    this.action,
    this.backButtonOnPress,
    this.elevation = 0,
    this.fontSize = 24,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 60);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool hasNotification = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return widget.isShowBackBtn
        ? AppBar(
            scrolledUnderElevation: 0,
            elevation: widget.elevation,
            shadowColor: MyColor.black.withValues(alpha: 0.1),
            titleSpacing: 0,
            surfaceTintColor: MyColor.getTransparentColor(),
            leading: widget.isShowBackBtn
                ? InkWell(
                    onTap: () {
                      if (widget.backButtonOnPress == null) {
                        if (widget.fromAuth) {
                          Get.offAllNamed(RouteHelper.loginScreen);
                        } else if (widget.isProfileCompleted) {
                          showExitDialog();
                        } else {
                          String previousRoute = Get.previousRoute;
                          if (previousRoute == '/splash-screen') {
                            Get.offAndToNamed(RouteHelper.homeScreen);
                          } else {
                            Get.back();
                          }
                        }
                      } else {
                        widget.backButtonOnPress!();
                      }
                    },
                    child: MyAssetImageWidget(
                      height: 24.h,
                      width: 24.w,
                      isSvg: true,
                      assetPath: MyImages.arrowBack,
                      boxFit: BoxFit.scaleDown,
                    ),
                  )
                : const SizedBox.shrink(),
            backgroundColor: widget.bgColor ?? Colors.transparent,
            title: DefaultText(
              text: widget.title.tr,
              textStyle: MyTextStyle.heading20W700().copyWith(
                color: MyColor.appBarTitleColor,
                fontSize: widget.fontSize.sp,
              ),
            ),
            centerTitle: widget.isTitleCenter,
            actions: widget.action,
          )
        : AppBar(
            //  titleSpacing: 0,
            //  elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            title: DefaultText(
              text: widget.title.tr,
              textStyle: MyTextStyle.heading20W700().copyWith(color: MyColor.appBarTitleColor),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: MyColor.getPrimaryColor(),
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: MyColor.getPrimaryColor(),
              systemNavigationBarIconBrightness: theme.brightness,
            ),
            actions: widget.action,
            automaticallyImplyLeading: false,
          );
  }
}
