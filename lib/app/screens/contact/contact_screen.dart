import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/contact/widgets/contact_screen_sliver_app_bar.dart';
import 'package:ovowpp/app/screens/contact/widgets/contact_tab_bar_view.dart';
import 'package:ovowpp/app/screens/contact/widgets/contact_tab_delegate.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import '../../../core/utils/util_exporter.dart';
import '../../../data/controller/all_contacts/all_contact_controller.dart';
import '../../../data/repo/all_contact/all_contact_repo.dart';
import '../../components/annotated_region/annotated_region_widget.dart';
import '../../components/permission_denied_component.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> with SingleTickerProviderStateMixin {
  final ScrollController contactScreenScroller = ScrollController();
  Timer? debounceTimer;

  void fetchData() {
    final controller = Get.find<AllContactController>();
    if (controller.isLoadingMore || !controller.hasNext()) return;

    controller.newGetContact(
      loadMore: true,
      status: controller.status, // ✅ keep same status
    );
  }

  bool isBackButton = false;
  bool isUpload = false;
  @override
  void initState() {
    Get.put(AllContactRepo());
    final controller = Get.put(AllContactController(repo: Get.find()));
    super.initState();
    controller.tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MyUtils.checkPermission(AppPermission.viewContact)) controller.newGetContact();
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
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      isBackButton = args['isBackButton'] ?? false;
      isUpload = args['isUpload'] ?? false;
    } else {
      isBackButton = false;
      isUpload = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllContactController>(
      builder: (controller) {
        if (!MyUtils.checkPermission(AppPermission.viewContact)) {
          return PermissionDeniedComponent();
        }

        return AnnotatedRegionWidget(
          statusBarColor: Colors.transparent,
          top: true,
          child: Scaffold(
            backgroundColor: MyColor.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
              child: NestedScrollView(
                controller: contactScreenScroller,
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
                        title: ContactScreenSliverAppBar(isBackButton: isBackButton, isUpload: isUpload),
                      ),
                    ),
                    SliverPersistentHeader(pinned: true, delegate: ContactTabDelegate()),
                  ];
                },
                //await controller.getCampaignData(searchQuery: controller.searchQuery);
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.newGetContact(searchQuery: controller.searchQuery, status: controller.status);
                      },
                      child: ContactTabBarView(),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.newGetContact(searchQuery: controller.searchQuery, status: controller.status);
                      },
                      child: ContactTabBarView(),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.newGetContact(searchQuery: controller.searchQuery, status: controller.status);
                      },
                      child: ContactTabBarView(),
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
