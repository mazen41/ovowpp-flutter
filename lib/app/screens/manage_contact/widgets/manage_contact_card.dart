import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:ovowpp/app/components/card/custom_app_card.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class ManageContactCard extends StatelessWidget {
  final String title;
  final String image;
  final Callback? onTap;
  const ManageContactCard({super.key, this.onTap, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomAppCard(
        backgroundColor: MyColor.searchFieldColor,
        borderColor: MyColor.dashboardCardBorder,
        width: double.infinity,
        radius: Dimensions.space10,
        child: Row(
          children: [
            MyAssetImageWidget(
              assetPath: image,
              isSvg: true,
              height: Dimensions.space25,
              width: Dimensions.space25,
              color: MyColor.splashTextColor,
            ),
            spaceSide(Dimensions.space10.h),
            Text(title, style: MyTextStyle.heading16W600UseTextColor().copyWith(color: MyColor.headingText)),
          ],
        ),
      ),
    );
  }
}
