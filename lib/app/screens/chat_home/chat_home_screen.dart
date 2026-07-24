import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/permission_denied_component.dart';
import 'package:ovowpp/app/screens/chat_home/widgets/chat_home_header_content.dart';
import 'package:ovowpp/app/screens/chat_home/widgets/chat_home_tab_bar.dart';
import 'package:ovowpp/app/screens/chat_home/widgets/chat_pinned_tab_delegate.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import '../../../core/utils/app_permission.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/util.dart';
import '../../../data/controller/home/home_controller.dart';
import '../../../data/controller/home/pusher_home_service_controller.dart';
import '../../../data/repo/home/home_repo.dart';
import '../../components/no_data.dart';
import '../../components/shimmer/home_shimmer.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> with SingleTickerProviderStateMixin {
  final ScrollController chatHomeScreenController = ScrollController();

  void fetchData() {
    final controller = Get.find<HomeController>();
    if (controller.isLoadingMore || !controller.hasNext()) return;

    controller.newChatMethod(
      loadMore: true,
      status: controller.status, // ✅ keep same status
    );
  }

  @override
  void initState() {
    Get.put(HomeRepo());
    final controller = Get.put(HomeController(homeRepo: Get.find()));
    final pusherController = Get.put(PusherHomeServiceController());

    super.initState();

    controller.tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      int previousIndex = controller.tabController.index;
      controller.tabController.addListener(() async {
        if (controller.tabController.index != previousIndex) {
          previousIndex = controller.tabController.index;
          await controller.selectStatus(controller.tabController.index);
          controller.searchController.text = '';
          controller.searchQuery = '';
          FocusManager.instance.primaryFocus?.unfocus();
        }
      });

      if (MyUtils.checkPermission(AppPermission.viewInbox)) {
        bool hasData = controller.newChatData.isNotEmpty;
        // await controller.refreshGeneralSettings();
        await controller.homeData(shouldShowLoader: !hasData).then((v) {
          pusherController.ensureConnection("private-receive-message-${controller.selectedWpAccountNumber}");
        });
      }
    });
  }

  @override
  void dispose() {
    chatHomeScreenController.dispose();
    Get.find<HomeController>().tabController.dispose();
    Get.find<HomeController>().newChatData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        if (!MyUtils.checkPermission(AppPermission.viewInbox)) {
          return PermissionDeniedComponent();
        }
        return Container(
          width: double.infinity,
          color: MyColor.white,
          child: AnnotatedRegionWidget(
            statusBarColor: MyColor.white,
            systemNavigationBarColor: MyColor.transparent,
            top: true,
            child: Scaffold(
              backgroundColor: MyColor.white,
              body: controller.isHomeDataLoading
                  ? const HomeShimmer()
                  : controller.isHomeDataError
                  ? const NoDataWidget()
                  : controller.isHomeDataLoading
                  ? HomeShimmer()
                  : NestedScrollView(
                      controller: chatHomeScreenController,

                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            surfaceTintColor: MyColor.white,
                            backgroundColor: MyColor.white,
                            floating: true,
                            snap: true,
                            pinned: false,
                            toolbarHeight: 135.h,
                            flexibleSpace: FlexibleSpaceBar(
                              titlePadding: EdgeInsets.zero,
                              title: HeaderContent(controller),
                            ),
                          ),
                          SliverPersistentHeader(pinned: true, delegate: ChatPinnedTabDelegate()),
                        ];
                      },
                      body: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller.tabController,
                        children: [
                          RefreshIndicator(
                            onRefresh: () async => controller.newChatMethod(),
                            child: MySliverTabBarView(index: 0),
                          ),
                          // pending
                          RefreshIndicator(
                            onRefresh: () async =>
                                controller.newChatMethod(status: int.tryParse(AppStatus.PENDING_CONVERSATION)),
                            child: MySliverTabBarView(index: 2),
                          ),
                          // Done
                          RefreshIndicator(
                            onRefresh: () async =>
                                controller.newChatMethod(status: int.tryParse(AppStatus.DONE_CONVERSATION)),
                            child: MySliverTabBarView(index: 2),
                          ),
                          // important
                          RefreshIndicator(
                            onRefresh: () async =>
                                controller.newChatMethod(status: int.tryParse(AppStatus.IMPORTANT_CONVERSATION)),
                            child: MySliverTabBarView(index: 3),
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
