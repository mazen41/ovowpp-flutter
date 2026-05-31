import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/permission_denied_component.dart';
import 'package:ovowpp/app/screens/campaigns/widgets/campaign_tab_bar_view.dart' show CampaignTarBarView;
import 'package:ovowpp/app/screens/campaigns/widgets/campaign_tab_delegate.dart';
import 'package:ovowpp/app/screens/campaigns/widgets/user_banner_and_search_slivers.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import 'package:ovowpp/data/controller/campaigns/campaigns_controller.dart';
import '../../../core/utils/util_exporter.dart';
import '../../../data/repo/campaign/campaign_repo.dart';
import '../../components/annotated_region/annotated_region_widget.dart';
import 'package:get/get.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> with SingleTickerProviderStateMixin {
  final ScrollController campaignScreenController = ScrollController();
  void fetchData() {
    final controller = Get.find<CampaignsController>();
    if (controller.isLoadingMore || !controller.hasNext()) return;

    controller.getCampaignData(
      loadMore: true,
      status: controller.status, // ✅ keep same status
    );
  }

  @override
  void initState() {
    Get.put(CampaignRepo());
    final controller = Get.put(CampaignsController(repo: Get.find()));
    super.initState();
    controller.tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MyUtils.checkPermission(AppPermission.viewCampaign)) controller.getCampaignData();
      int previousIndex = controller.tabController.index;
      controller.tabController.addListener(() {
        if (controller.tabController.index != previousIndex) {
          previousIndex = controller.tabController.index;
          controller.selectStatus(controller.tabController.index);
          controller.searchController.text = '';
          controller.searchQuery = '';
          FocusScope.of(context).unfocus();
        }
      });
    });
  }

  @override
  void dispose() {
    campaignScreenController.dispose();
    Get.find<CampaignsController>().tabController.dispose();
    Get.find<CampaignsController>().campaignData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (controller) {
        if (!MyUtils.checkPermission(AppPermission.viewCampaign)) {
          return PermissionDeniedComponent();
        }
        return AnnotatedRegionWidget(
          statusBarColor: MyColor.transparent,
          top: true,
          child: Scaffold(
            backgroundColor: MyColor.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
              child: NestedScrollView(
                controller: campaignScreenController,

                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      surfaceTintColor: MyColor.white,
                      backgroundColor: MyColor.white,
                      floating: true,
                      snap: true,
                      pinned: false,
                      toolbarHeight: 130.h,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        title: UserBannerAndSearchSlivers(),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: CampaignTabDelegate(controller.campaignSearchItemList),
                    ),
                  ];
                },
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.getCampaignData(searchQuery: controller.searchQuery);
                      },
                      child: CampaignTarBarView(),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.getCampaignData(searchQuery: controller.searchQuery);
                      },
                      child: CampaignTarBarView(),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.getCampaignData(searchQuery: controller.searchQuery);
                      },
                      child: CampaignTarBarView(),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.getCampaignData(searchQuery: controller.searchQuery);
                      },
                      child: CampaignTarBarView(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
