import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/data/controller/campaigns/campaigns_controller.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../../components/text/default_text.dart';
import '../../../campaigns/widgets/campaigns_item.dart';

class RecentCampaign extends StatefulWidget {
  final Function(int navIndex)? onMenuTap;

  const RecentCampaign({super.key, this.onMenuTap});

  @override
  State<RecentCampaign> createState() => _RecentCampaignState();
}

class _RecentCampaignState extends State<RecentCampaign> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (controller) {
        if (controller.isGetCampaignLoader) {
          return MyShimmerWidget(
            child: Container(
              height: Dimensions.space60.h,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(Dimensions.space8.r)),
            ),
          );
        }
        if (controller.campaignData.isEmpty) {
          return SizedBox.shrink();
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultText(
                  text: MyStrings.recentCampaign.tr,
                  textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.splashTextColor),
                ),
                InkWell(
                  onTap: widget.onMenuTap != null ? () => widget.onMenuTap!(2) : null,
                  child: Row(
                    children: [
                      DefaultText(
                        text: MyStrings.viewAll.tr,
                        textStyle: MyTextStyle.subHeading16W400(
                          fontFamily: 'Nunito',
                        ).copyWith(color: MyColor.getPrimaryColor(), fontSize: 14.sp),
                      ),
                      MyAssetImageWidget(
                        assetPath: MyImages.arrowForward,
                        isSvg: true,
                        height: 18.h,
                        width: 18.w,
                        color: MyColor.getPrimaryColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            spaceDown(Dimensions.space12.h),
            Column(
              children: List.generate(controller.campaignData.length > 3 ? 3 : controller.campaignData.length, (index) {
                final item = controller.campaignData[index];
                return CampaignsItem(indexItem: item, index: index);
              }),
            ),

            // Material(
            //   color: MyColor.white,
            //   borderRadius: BorderRadius.circular(Dimensions.space16.r),
            //   child: InkWell(
            //     borderRadius: BorderRadius.circular(Dimensions.space16.r),
            //     onTap: () {},
            //     child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w, vertical: Dimensions.space10.h),
            //       decoration: BoxDecoration(
            //         border: Border.all(color: MyColor.dashboardCardBorder),
            //         borderRadius: BorderRadius.circular(Dimensions.space16.r),
            //       ),
            //       child: Row(
            //         children: [
            //           RoundIconWithBgColor(bgColor: MyColor.recentActivityIconBgColor, icon: MyImages.newCampaign),
            //           spaceSide(Dimensions.space12.w),
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               DefaultText(
            //                 text: MyStrings.campaignEidPromo,
            //                 textStyle: MyTextStyle.regularW400Style().copyWith(color: MyColor.regularHederColor),
            //               ),
            //               DefaultText(
            //                 text: "230 ${MyStrings.messagesSent}",
            //                 textStyle: MyTextStyle.regularW400Style().copyWith(color: MyColor.recentActivityCardValue),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
