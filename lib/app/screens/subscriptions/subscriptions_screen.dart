import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/screens/subscriptions/tabs/subscription_history_tab.dart';
import 'package:ovowpp/app/screens/subscriptions/tabs/subscription_info_tab.dart';
import 'package:ovowpp/app/screens/subscriptions/tabs/subscription_plans_tab.dart';
import 'package:ovowpp/app/screens/subscriptions/widgets/subscription_widgets.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovowpp/data/controller/subscription/subscription_controller.dart';
import 'package:ovowpp/data/repo/subscription/subscription_repo.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  static const List<String> _tabs = [MyStrings.pricingPlans, MyStrings.subscriptionInfo, MyStrings.purchaseHistory];

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SubscriptionRepo>()) {
      Get.put(SubscriptionRepo());
    }
    if (!Get.isRegistered<SubscriptionController>()) {
      Get.put(SubscriptionController(subscriptionRepo: Get.find()));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<SubscriptionController>();
      controller.loadPricingPlans();
      controller.initPurchaseHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: SubscriptionsScreen._tabs.length,
      child: Scaffold(
        backgroundColor: MyColor.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
            child: Column(
              children: [
                SizedBox(height: Dimensions.space16.h),
                _SubscriptionHeader(),
                SizedBox(height: Dimensions.space16.h),
                const SubscriptionTopTabBar(tabs: SubscriptionsScreen._tabs),
                SizedBox(height: Dimensions.space20.h),
                const Expanded(
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [SubscriptionPlansTab(), SubscriptionInfoTab(), SubscriptionHistoryTab()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SubscriptionHeaderButton(icon: Icons.arrow_back_ios_new_rounded, onTap: Get.back),
        SizedBox(width: Dimensions.space12.w),
        Expanded(
          child: Text(
            MyStrings.subscriptions.tr,
            style: MyTextStyle.heading20W700().copyWith(color: MyColor.appBarTitleColor, fontWeight: FontWeight.w700),
          ),
        ),
        _ProfileAvatar(),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String initials = _resolveInitials();

    return Container(
      height: 42.w,
      width: 42.w,
      decoration: BoxDecoration(
        color: MyColor.getPrimaryColor().withValues(alpha: .14),
        shape: BoxShape.circle,
        border: Border.all(color: MyColor.getPrimaryColor().withValues(alpha: .25)),
      ),
      alignment: Alignment.center,
      child: Text(initials, style: MyTextStyle.heading14W600().copyWith(color: MyColor.getPrimaryColor())),
    );
  }

  String _resolveInitials() {
    if (!Get.isRegistered<DashboardController>()) return 'SU';

    final user = Get.find<DashboardController>().user;
    final first = (user?.firstname ?? '').trim();
    final last = (user?.lastname ?? '').trim();
    final values = [first, last].where((element) => element.isNotEmpty).toList();

    if (values.isEmpty) return 'SU';

    return values.map((name) => name[0].toUpperCase()).take(2).join();
  }
}
