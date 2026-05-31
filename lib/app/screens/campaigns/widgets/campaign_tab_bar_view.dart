import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';

import '../../../../data/controller/campaigns/campaigns_controller.dart';
import '../../../components/no_data.dart';
import '../../../components/shimmer/home_shimmer.dart';
import 'campaigns_item.dart';

class CampaignTarBarView extends StatelessWidget {
  const CampaignTarBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (controller) {
        if (controller.isGetCampaignLoader) {
          return const HomeShimmer();
        } else {
          return controller.campaignData.isEmpty
              ? NoDataWidget()
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final metrics = notification.metrics;

                      if (metrics.pixels >= metrics.maxScrollExtent - 100) {
                        if (!controller.isLoadingMore && controller.hasNext()) {
                          controller.getCampaignData(
                            loadMore: true,
                            status: controller.status,
                            searchQuery: controller.searchQuery,
                          );
                        }
                      }
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(childCount: controller.campaignData.length, (
                          context,
                          index,
                        ) {
                          final item = controller.campaignData[index];

                          return CampaignsItem(indexItem: item, index: index);
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: controller.isLoadingMore
                            ? CustomLoader(isPagination: true, loaderSize: 50.sp)
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
        }
      },
    );
  }
}
