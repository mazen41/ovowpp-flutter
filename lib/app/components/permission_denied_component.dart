import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:ovowpp/app/components/text/default_text.dart';

import '../../core/utils/app_style.dart';
import '../../core/utils/dimensions.dart';
import '../../core/utils/my_color.dart';
import '../../core/utils/my_images.dart';
import '../../core/utils/my_strings.dart';
import '../../core/utils/text_style.dart';
import 'annotated_region/annotated_region_widget.dart';
import 'image/my_asset_widget.dart';

class PermissionDeniedComponent extends StatelessWidget {
  const PermissionDeniedComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      statusBarColor: MyColor.transparent,
      top: true,
      child: Scaffold(
        backgroundColor: MyColor.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyAssetImageWidget(assetPath: MyImages.unlock),
                spaceDown(Dimensions.space14),
                DefaultText(
                  text: MyStrings.permissionDenyMessage.tr,
                  textStyle: MyTextStyle.heading16W600(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
