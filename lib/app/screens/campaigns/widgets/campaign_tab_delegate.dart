import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/app/screens/campaigns/widgets/search_single_item.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/campaigns/campaigns_controller.dart';
import '../../../components/text/default_text.dart';

class CampaignTabDelegate extends SliverPersistentHeaderDelegate {
  final List items;
  CampaignTabDelegate(this.items);

  @override
  double get maxExtent => 76.h;
  @override
  double get minExtent => 76.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<CampaignsController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          color: MyColor.white,
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 34.h,
                child: TabBar(
                  controller: controller.tabController,
                  isScrollable: false,
                  tabAlignment: TabAlignment.fill,
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  tabs: List.generate(4, (index) {
                    return SearchSingleItem(
                      title: controller.campaignSearchItemList[index]['title'],
                      isSelected: controller.tabController.index == index,
                      onTap: () {},
                    );
                  }),
                ),
              ),

              // SizedBox(
              //   height: 35.h,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     physics: BouncingScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: items.length,
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : Dimensions.space8.w),
              //         child: SizedBox(
              //           width: 120.w, // must have fixed width
              //           child: SearchSingleItem(
              //             title: items[index]['title'],
              //             onTap: items[index]['onTap'],
              //             isSelected: items[index]['isSelected'],
              //           ),
              //         ),
              //       );
              //     },
              //   )
              //
              // ),
              spaceDown(Dimensions.space8.h),
              controller.isGetCampaignLoader
                  ? MyShimmerWidget(
                      child: Container(height: Dimensions.space24.h, width: Dimensions.space110.w, color: Colors.grey),
                    )
                  : DefaultText(
                      text: "${MyStrings.results.tr} (${controller.campaignData.length})",
                      textStyle: MyTextStyle.heading16W600UseTextColor(fontFamily: 'Nunito'),
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
