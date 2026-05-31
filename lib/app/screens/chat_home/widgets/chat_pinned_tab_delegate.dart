import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/home/home_controller.dart';
import '../../../components/text/default_text.dart';
import '../../campaigns/widgets/search_single_item.dart';

class ChatPinnedTabDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 75.h;

  @override
  double get maxExtent => 75.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          color: MyColor.white,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TAB BAR
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
                      title: controller.tabsList[index],
                      isSelected: controller.tabController.index == index,
                      onTap: () {},
                    );
                  }),
                ),
              ),
              spaceDown(Dimensions.space8.h),

              controller.newChatLoader
                  ? MyShimmerWidget(
                      child: Container(height: Dimensions.space24.h, width: Dimensions.space110.w, color: Colors.grey),
                    )
                  : controller.newChatData.isNotEmpty
                  ? DefaultText(
                      text: '${MyStrings.results.tr} (${controller.newChatData.length.toString()})',
                      textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // IMPORTANT for GetX updates
  }
}
