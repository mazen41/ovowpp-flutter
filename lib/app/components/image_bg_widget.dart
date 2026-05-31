import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/my_color.dart';

import '../screens/onboard/widgets/onboard_transparent_image.dart';
import 'annotated_region/annotated_region_widget.dart';

class ImageBgWidget extends StatelessWidget {
  final Widget screen;
  final bool isAppBar;
  final PreferredSizeWidget? customAppBar;
  const ImageBgWidget({super.key, required this.screen, this.isAppBar = false, this.customAppBar});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      statusBarColor: Colors.transparent,
      child: Scaffold(
        backgroundColor: MyColor.loginScreenBackground,
        appBar: isAppBar ? customAppBar : null,

        body: Stack(
          children: [
            OnboardTransparentImageAndSkip(isShowSkip: false, skipTap: () {}),
            screen,
          ],
        ),
      ),
    );
  }
}
