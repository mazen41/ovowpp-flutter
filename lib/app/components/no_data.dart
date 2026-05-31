import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class NoDataWidget extends StatelessWidget {
  final double margin;
  final String? text;
  const NoDataWidget({super.key, this.margin = 4, this.text});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      // margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / margin),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyAssetImageWidget(
              isSvg: true,
              assetPath: MyImages.noDataImage,
              height: Dimensions.space100.h,
              width: Dimensions.space100.w,
            ),
            const SizedBox(height: Dimensions.space3),
            Text(
              text ?? MyStrings.noDataToShow.tr,
              style: theme.textTheme.labelLarge?.copyWith(color: MyColor.getBodyTextColor()),
            ),
          ],
        ),
      ),
    );
  }
}
