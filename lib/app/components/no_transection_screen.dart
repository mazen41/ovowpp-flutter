import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import '../../core/utils/dimensions.dart';
import 'image/custom_svg_picture.dart';

class NoTransectionScreen extends StatefulWidget {
  final String message;
  final double paddingTop;
  final double imageHeight;
  final String message2;
  final String image;
  final Color imageColor;

  const NoTransectionScreen({
    super.key,
    this.message = MyStrings.noTransection,
    this.paddingTop = 6,
    this.imageHeight = .5,
    this.imageColor = MyColor.white,
    this.message2 = MyStrings.noTransectionsToShow,
    this.image = MyImages.noTransectionFound,
  });

  @override
  State<NoTransectionScreen> createState() => _NoTransectionScreenState();
}

class _NoTransectionScreenState extends State<NoTransectionScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * widget.imageHeight,
                  width: MediaQuery.of(context).size.width * .4,
                  child: CustomSvgPicture(image: widget.image, height: 100, width: 100, color: widget.imageColor),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 30, right: 30),
                    child: Column(
                      children: [
                        Text(
                          widget.message.tr,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: MyColor.getBodyTextColor(),
                            fontSize: Dimensions.space15,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
