import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';

import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/all_contacts/all_contact_controller.dart';
import '../../../components/text/default_text.dart';
import '../../campaigns/widgets/search_single_item.dart';

class ContactTabDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 74.h;
  @override
  double get minExtent => 70.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<AllContactController>(
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
                  onTap: (value) {},
                  tabs: List.generate(3, (index) {
                    return SearchSingleItem(
                      title: controller.contactSearchItemList[index]['title'],
                      isSelected: controller.tabController.index == index,
                      onTap: () {},
                    );
                  }),
                ),
              ),
              spaceDown(Dimensions.space4.h),

              controller.isContactLoading
                  ? MyShimmerWidget(
                      child: Container(height: Dimensions.space24.h, width: Dimensions.space110.w, color: Colors.grey),
                    )
                  : controller.newAllContactsData.isNotEmpty
                  ? DefaultText(
                      text: "${MyStrings.results.tr} (${controller.newAllContactsData.length})",
                      textStyle: MyTextStyle.heading16W600(),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
