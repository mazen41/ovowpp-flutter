import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';

import '../../../core/utils/text_style.dart';
import '../../../core/utils/util_exporter.dart';

class MyCustomScaffold extends StatelessWidget {
  const MyCustomScaffold({
    super.key,
    this.isCenterFloating = true,
    this.pageTitle = "PageTitle",
    this.appBarHeight = 60,
    this.actionButton,
    this.transformValue,
    this.showAppBarContent = false,
    this.appBarContent,
    this.showBackButton = true,
    this.showAppBar = true,
    this.body,
    this.appBarBgColor = MyColor.white,
    this.screenBgColor = MyColor.white,
    this.padding,
    this.demo = false,
    this.onBackButtonTap,
    this.floatingActionButton,
    this.centerTitle = false,
    this.bottomNav,
    this.isScaffoldBgImage = false,
    this.appBarElevation = 0,
    this.appBarScrollElevation = 0,
    this.appBarShadowColor = Colors.transparent,
    this.screenBgImage = MyImages.chatBackground,
    this.titleFontSize = 24,
  });
  final String? pageTitle;
  final List<Widget>? actionButton;
  final Widget? body;
  final Color? appBarBgColor;
  final Color? screenBgColor;
  final EdgeInsetsGeometry? padding;
  final bool demo;
  final bool centerTitle;
  final bool showAppBar;
  final bool isCenterFloating;
  final bool showBackButton;
  final bool showAppBarContent;
  final VoidCallback? onBackButtonTap;
  final double? transformValue;
  final double? appBarHeight;
  final Widget? floatingActionButton;
  final Widget? appBarContent;
  final Widget? bottomNav;
  final bool isScaffoldBgImage;
  final double appBarElevation;
  final double appBarScrollElevation;
  final Color appBarShadowColor;
  final String screenBgImage;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AnnotatedRegionWidget(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,

      child: Scaffold(
        backgroundColor: screenBgColor ?? MyColor.getBackgroundColor(),
        appBar: showAppBar
            ? PreferredSize(
                preferredSize: Size.fromHeight(appBarHeight ?? 60.0.h),
                child: AppBar(
                  shadowColor: appBarShadowColor,
                  elevation: appBarElevation,
                  scrolledUnderElevation: appBarScrollElevation,
                  toolbarHeight: appBarHeight ?? 60.0.h,
                  surfaceTintColor: MyColor.transparent,
                  centerTitle: centerTitle,
                  backgroundColor: appBarBgColor ?? MyColor.getBackgroundColor(),
                  systemOverlayStyle: MyUtils.allScreen(),
                  leading: showBackButton
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: GestureDetector(
                            onTap: () {
                              if (onBackButtonTap != null) {
                                onBackButtonTap!();
                              } else {
                                Get.back();
                              }
                            },
                            child: MyAssetImageWidget(
                              height: Dimensions.space24.h,
                              width: Dimensions.space24.h,
                              assetPath: MyImages.arrowBack,
                              isSvg: true,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  titleSpacing: 0,
                  title: showAppBarContent
                      ? Transform(
                          transform: Matrix4.translationValues(transformValue ?? -30.0, 0.0, 0.0),
                          child: appBarContent,
                        )
                      : Transform(
                          transform: Matrix4.translationValues(showBackButton ? 0 : -30.0, 0.0, 0.0),
                          child: Text(
                            "$pageTitle",
                            style: MyTextStyle.heading20W700().copyWith(
                              color: MyColor.appBarTitleColor,
                              fontSize: titleFontSize.sp,
                            ),
                          ),
                        ),
                  actions: [
                    if (actionButton != null) ...[...actionButton!],
                    if (demo == true && actionButton == null)
                      TextButton(
                        style: TextButton.styleFrom(
                          overlayColor: MyColor.getPrimaryColor(), // Text color
                          textStyle: TextStyle(
                            fontSize: Dimensions.fontLarge,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: MyColor.getPrimaryColor(),
                          ),
                        ),
                        onPressed: () {},
                        child: Text("Demo Skip Button", style: theme.textTheme.bodyMedium),
                      ),
                  ],
                ),
              )
            : null,
        body: Container(
          height: double.infinity,
          padding: padding ?? EdgeInsetsDirectional.symmetric(horizontal: Dimensions.space16.w),
          decoration: isScaffoldBgImage
              ? BoxDecoration(image: DecorationImage(image: AssetImage(screenBgImage)))
              : null,
          child: body,
        ),
        floatingActionButtonLocation: isCenterFloating
            ? FloatingActionButtonLocation.centerDocked
            : FloatingActionButtonLocation.endDocked,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNav,
      ),
    );
  }
}
