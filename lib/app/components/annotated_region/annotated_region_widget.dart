import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnnotatedRegionWidget extends StatelessWidget {
  final Widget child;
  final Color statusBarColor;
  final Color systemNavigationBarColor;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
  final bool top;
  final bool bottom;

  final Brightness systemNavigationBarIconBrightness;
  final Color? systemNavigationBarDividerColor;
  final bool useDarkTheme;
  final EdgeInsets? padding;

  const AnnotatedRegionWidget({
    super.key,
    required this.child,
    this.statusBarColor = Colors.white,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
    this.systemNavigationBarIconBrightness = Brightness.dark,
    this.systemNavigationBarColor = Colors.white,
    this.systemNavigationBarDividerColor,
    this.useDarkTheme = false,
    this.padding,
    this.top = false,
    this.bottom = true,
  });

  @override
  Widget build(BuildContext context) {
    // Choose between dark and light themes
    final systemUiOverlayStyle = useDarkTheme
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: statusBarColor,
            statusBarBrightness: statusBarBrightness ?? Brightness.light,
            statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
            systemNavigationBarDividerColor: systemNavigationBarDividerColor,
          )
        : SystemUiOverlayStyle.light.copyWith(
            statusBarColor: statusBarColor,
            statusBarBrightness: statusBarBrightness ?? Brightness.light,
            statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
            systemNavigationBarDividerColor: systemNavigationBarDividerColor,
          );

    return Container(
      color: systemNavigationBarColor, // background for SafeArea padding
      child: Padding(
        padding: padding ?? EdgeInsets.zero, // Allows custom padding or defaults to zero
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiOverlayStyle,
          child: SafeArea(top: top, left: true, right: true, bottom: bottom, child: child),
        ),
      ),
    );
  }
}
