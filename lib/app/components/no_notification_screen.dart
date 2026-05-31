import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import '../../core/utils/dimensions.dart';
import 'image/custom_svg_picture.dart';

class NoNotificationScreen extends StatefulWidget {
  final String message;
  final double paddingTop;
  final double imageHeight;
  final String message2;
  final String image;

  const NoNotificationScreen({
    super.key,
    this.message = MyStrings.noNotification,
    this.paddingTop = 6,
    this.imageHeight = .5,
    this.message2 = MyStrings.noNotificationToShow,
    this.image = MyImages.noNotificationFound,
  });

  @override
  State<NoNotificationScreen> createState() => _NoNotificationScreenState();
}

class _NoNotificationScreenState extends State<NoNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MyCustomScaffold(
      showAppBar: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center vertically
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSvgPicture(image: widget.image, height: 150, width: 100, color: MyColor.getBodyTextColor()),
              const SizedBox(height: 20),
              Text(
                widget.message.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: MyColor.getBodyTextColor(),
                  fontSize: Dimensions.fontDefault,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.message2,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: MyColor.getBodyTextColor(),
                  fontSize: Dimensions.fontLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
