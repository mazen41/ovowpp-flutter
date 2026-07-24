import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/text-field/custom_drop_down_button_with_text_field2.dart';
import 'package:ovowpp/app/screens/subscriptions/widgets/subscription_widgets.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/subscription/subscription_controller.dart';
import 'package:ovowpp/data/model/subscription/pricing_plan_response_model.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class SubscriptionPlansTab extends StatefulWidget {
  const SubscriptionPlansTab({super.key});

  @override
  State<SubscriptionPlansTab> createState() => _SubscriptionPlansTabState();
}

class _SubscriptionPlansTabState extends State<SubscriptionPlansTab> {
  final PageController _pageController = PageController(viewportFraction: .84);
  int _selectedBillingIndex = 0;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageChange)
      ..dispose();
    super.dispose();
  }

  void _handlePageChange() {
    if (!_pageController.hasClients) return;
    setState(() {
      _currentPage = _pageController.page ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (controller) => controller.isLoading
          ? const Center(child: CustomLoader())
          : controller.pricingPlanList.isEmpty
          ? const Center(child: NoDataWidget())
          : SingleChildScrollView(
              padding: EdgeInsets.only(bottom: Dimensions.space24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubscriptionSectionEyebrow(text: MyStrings.scaleYourVision.tr),
                  SizedBox(height: Dimensions.space10.h),
                  Text(
                    MyStrings.investmentForEveryStage.tr,
                    style: MyTextStyle.heading20W700().copyWith(
                      fontSize: 34.sp,
                      height: 1.12,
                      color: MyColor.regularHederColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.space18.h),
                  Center(
                    child: SubscriptionInlineSwitch(
                      items: [MyStrings.monthly.tr, MyStrings.yearly.tr],
                      selectedIndex: _selectedBillingIndex,
                      onChanged: (index) {
                        setState(() {
                          _selectedBillingIndex = index;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: Dimensions.space24.h),
                  ExpandablePageView.builder(
                    controller: _pageController,
                    itemCount: controller.pricingPlanList.length,
                    itemBuilder: (_, index) {
                      final double distance = (_currentPage - index).abs().clamp(0, 1);
                      final double scale = 1 - (distance * .08);
                      final double verticalPadding = 18 * distance;
                      final bool isCentered = distance < .5;

                      return AnimatedPadding(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: verticalPadding.h),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: scale, end: scale),
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutCubic,
                          builder: (_, value, child) => Transform.scale(scale: value, child: child),
                          child: SubscriptionPlanCard(
                            plan: controller.pricingPlanList[index],
                            isYearly: _selectedBillingIndex == 1,
                            isCentered: isCentered,
                            isCurrentPlan: controller.isCurrentPlan(controller.pricingPlanList[index].id),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.space16.h),
                  _CarouselDots(itemCount: controller.pricingPlanList.length, currentPage: _currentPage),
                  SizedBox(height: Dimensions.space10.h),
                ],
              ),
            ),
    );
  }
}

class _PlanLimitItem {
  final String title;
  final String value;

  const _PlanLimitItem({required this.title, required this.value});
}

class SubscriptionPlanCard extends StatelessWidget {
  final PricingPlan plan;
  final bool isYearly;
  final bool isCentered;
  final bool isCurrentPlan;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isYearly,
    required this.isCentered,
    required this.isCurrentPlan,
  });

  @override
  Widget build(BuildContext context) {
    final List<_PlanLimitItem> highlights = _buildHighlights();
    final controller = Get.find<SubscriptionController>();
    final String price = AppConverter.formatNumber(
      isYearly ? (plan.yearlyPrice ?? "0") : (plan.monthlyPrice ?? "0"),
      precision: 2,
    );
    final String suffix = isYearly ? '/yr' : '/mo';
    final bool isStarterRepurchaseBlocked = controller.isStarterPlanRepurchaseBlocked(plan);
    final String buttonText = isStarterRepurchaseBlocked
        ? MyStrings.alreadyPurchased
        : (isCurrentPlan ? MyStrings.renewNow : MyStrings.buyNow);
    final bool isPopular = (plan.isPopular ?? '0') == '1';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(Dimensions.space24.r),
        border: Border.all(
          color: isCentered ? MyColor.getPrimaryColor().withValues(alpha: .35) : MyColor.dashboardCardBorder,
          width: isCentered ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCentered ? MyColor.getPrimaryColor().withValues(alpha: .16) : Colors.black.withValues(alpha: .05),
            blurRadius: isCentered ? 30 : 18,
            offset: Offset(0, isCentered ? 16 : 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SubscriptionPillText(
                  text: plan.name ?? 'N/A',
                  backgroundColor: isCentered ? MyColor.helpCenterItemBgColor : MyColor.searchItemBgColor,
                  textColor: isCentered ? MyColor.customerText : MyColor.fieldTitleTextColor,
                ),
                const Spacer(),
                if (isPopular)
                  SubscriptionPillText(
                    text: MyStrings.popular,
                    backgroundColor: MyColor.getPrimaryColor().withValues(alpha: .12),
                    textColor: MyColor.getPrimaryColor(),
                  ),
              ],
            ),
            SizedBox(height: Dimensions.space16.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${SharedPreferenceService.getCurrencySymbol()}$price",
                    style: MyTextStyle.heading20W700().copyWith(fontSize: 32.sp, color: MyColor.regularHederColor),
                  ),
                  TextSpan(
                    text: suffix,
                    style: MyTextStyle.subHeading14W500().copyWith(color: MyColor.fieldTitleTextColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.space8.h),
            Text(
              (plan.description ?? '').tr,
              style: MyTextStyle.subHeading14W500().copyWith(height: 1.45),
              overflow: TextOverflow.fade,
            ),
            SizedBox(height: Dimensions.space18.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Dimensions.space16.r),
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.circular(Dimensions.space18.r),
                border: Border.all(color: MyColor.dashboardCardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyStrings.planLimits.tr,
                    style: MyTextStyle.heading14W600().copyWith(color: MyColor.regularHederColor),
                  ),
                  SizedBox(height: Dimensions.space14.h),
                  ...List.generate(
                    highlights.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: index == highlights.length - 1 ? 0 : Dimensions.space10.h),
                      child: _PlanLimitRow(item: highlights[index]),
                    ),
                  ),
                  SizedBox(height: Dimensions.space18.h),
                  SubscriptionPrimaryButton(
                    text: buttonText,
                    isMuted: isCurrentPlan,
                    onTap: () {
                      controller.preparePlanPurchase(plan, isYearly: isYearly);
                      _PlanPurchaseSheet.show(
                        context,
                        plan: plan,
                        isYearly: isYearly,
                        isRenewal: isCurrentPlan,
                        isStarterRepurchaseBlocked: isStarterRepurchaseBlocked,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_PlanLimitItem> _buildHighlights() {
    return [
      _PlanLimitItem(title: MyStrings.whatsappAccountLimit, value: _limitValue(plan.accountLimit)),
      _PlanLimitItem(title: MyStrings.agentLimit, value: _limitValue(plan.agentLimit)),
      _PlanLimitItem(title: MyStrings.contactLimit, value: _limitValue(plan.contactLimit)),
      _PlanLimitItem(title: MyStrings.templateLimit, value: _limitValue(plan.templateLimit)),
      _PlanLimitItem(title: MyStrings.automationFlowLimit, value: _limitValue(plan.flowLimit)),
      _PlanLimitItem(title: MyStrings.campaignLimit, value: _limitValue(plan.campaignLimit)),
      _PlanLimitItem(title: MyStrings.shortLinkLimit, value: _limitValue(plan.shortLinkLimit)),
      _PlanLimitItem(title: MyStrings.floaterLimit, value: _limitValue(plan.floaterLimit)),

      _PlanLimitItem(title: MyStrings.welcomeMessageAvailable, value: _yesNoValue(plan.welcomeMessage)),
      _PlanLimitItem(title: MyStrings.aiAssistance, value: _yesNoValue(plan.aiAssistance)),
      _PlanLimitItem(title: MyStrings.interactiveMessage, value: _yesNoValue(plan.interactiveMessage)),
      _PlanLimitItem(title: MyStrings.ecommerceAvailable, value: _yesNoValue(plan.ecommerceAvailable)),
      _PlanLimitItem(title: MyStrings.apiAvailable, value: _yesNoValue(plan.apiAvailable)),
    ];
  }

  String _yesNoValue(String? value) {
    return (value ?? '0') == '1' ? MyStrings.yes : MyStrings.no;
  }

  String _limitValue(String? value) {
    return (value ?? '0') == '-1' ? MyStrings.unlimited : (value ?? '0');
  }
}

class _PlanPurchaseSheet {
  static void show(
    BuildContext context, {
    required PricingPlan plan,
    required bool isYearly,
    required bool isRenewal,
    required bool isStarterRepurchaseBlocked,
  }) {
    final SubscriptionController subscriptionController = Get.find<SubscriptionController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlanPurchaseSheetBody(
        controller: subscriptionController,
        plan: plan,
        isYearly: isYearly,
        isRenewal: isRenewal,
        isStarterRepurchaseBlocked: isStarterRepurchaseBlocked,
      ),
    );
  }
}

class _PlanPurchaseSheetBody extends StatefulWidget {
  final SubscriptionController controller;
  final PricingPlan plan;
  final bool isYearly;
  final bool isRenewal;
  final bool isStarterRepurchaseBlocked;

  const _PlanPurchaseSheetBody({
    required this.controller,
    required this.plan,
    required this.isYearly,
    required this.isRenewal,
    required this.isStarterRepurchaseBlocked,
  });

  @override
  State<_PlanPurchaseSheetBody> createState() => _PlanPurchaseSheetBodyState();
}

class _PlanPurchaseSheetBodyState extends State<_PlanPurchaseSheetBody> {
  late final List<String> recurringOptions;
  late String? selectedRecurring;
  String selectedPaymentOption = 'wallet_payment';
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    recurringOptions = widget.controller.availableRecurringOptions(widget.plan);
    final preferredRecurring = widget.isYearly ? 'yearly' : 'monthly';
    selectedRecurring = recurringOptions.contains(preferredRecurring)
        ? preferredRecurring
        : (recurringOptions.isNotEmpty ? recurringOptions.first : null);
  }

  String get _selectedPrice {
    if (selectedRecurring == 'yearly') return widget.plan.yearlyPrice ?? '0';
    return widget.plan.monthlyPrice ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isStarterRepurchaseBlocked) {
      return _StarterPlanPurchasedSheet(planName: widget.plan.name ?? MyStrings.starter);
    }

    final bool isWalletSelected = selectedPaymentOption == 'wallet_payment';

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .88),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.space24.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 46.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: MyColor.dashboardCardBorder,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.space16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.isRenewal ? MyStrings.renewNow : MyStrings.buyNow).tr,
                          style: MyTextStyle.heading15W600().copyWith(color: MyColor.regularHederColor),
                        ),
                        SizedBox(height: Dimensions.space4.h),
                        Text(
                          widget.plan.name ?? '--',
                          style: MyTextStyle.subHeading14W500().copyWith(color: MyColor.fieldTitleTextColor),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: Icon(Icons.close_rounded, size: 20.sp, color: MyColor.fieldTitleTextColor),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.space16.h),
              SubscriptionSurfaceCard(
                backgroundColor: const Color(0xFFF8FBFF),
                radius: Dimensions.space20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PurchaseInfoTile(
                      label: MyStrings.planDetails,
                      value: widget.plan.name ?? '--',
                      trailing:
                          '${widget.controller.currencySymbol}${AppConverter.formatNumber(_selectedPrice, precision: 2)}',
                    ),
                    if (isWalletSelected) ...[
                      SizedBox(height: Dimensions.space12.h),
                      _PurchaseInfoTile(
                        label: MyStrings.currentBalance,
                        value: widget.controller.currencyCode,
                        trailing:
                            '${widget.controller.currencySymbol}${AppConverter.formatNumber(widget.controller.walletBalance, precision: 2)}',
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: Dimensions.space18.h),
              if (recurringOptions.isNotEmpty)
                CustomDropDownTextField2(
                  labelText: MyStrings.billingCycle,
                  hintText: MyStrings.billingCycle,
                  selectedValue: selectedRecurring,
                  textStyle: MyTextStyle.subHeading14W500().copyWith(color: MyColor.regularHederColor, fontSize: 14.sp),
                  onChanged: recurringOptions.length > 1
                      ? (value) {
                          setState(() {
                            selectedRecurring = value?.toString();
                          });
                        }
                      : null,
                  items: recurringOptions
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            (item == 'yearly' ? MyStrings.yearly : MyStrings.monthly).tr,
                            style: MyTextStyle.subHeading14W500().copyWith(
                              fontSize: 14.sp,
                              color: MyColor.regularHederColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                _PurchaseInfoTile(label: MyStrings.billingCycle, value: '--', trailing: '--'),
              SizedBox(height: Dimensions.space18.h),
              Text(MyStrings.paymentOption.tr, style: MyTextStyle.heading14W600()),
              SizedBox(height: Dimensions.space10.h),
              _PaymentModeTile(
                title: MyStrings.payFromWallet,
                subtitle:
                    '${MyStrings.walletBalance.tr}: ${widget.controller.currencySymbol}${AppConverter.formatNumber(widget.controller.walletBalance, precision: 2)}',
                icon: Icons.account_balance_wallet_rounded,
                isSelected: isWalletSelected,
                onTap: () {
                  setState(() {
                    selectedPaymentOption = 'wallet_payment';
                  });
                },
              ),
              SizedBox(height: Dimensions.space10.h),
              _PaymentModeTile(
                title: MyStrings.paymentGateway,
                subtitle: MyStrings.selectPaymentMethod,
                icon: Icons.credit_card_rounded,
                isSelected: !isWalletSelected,
                onTap: () {
                  setState(() {
                    selectedPaymentOption = 'gateway_payment';
                  });
                },
              ),
              SizedBox(height: Dimensions.space20.h),
              SubscriptionPrimaryButton(
                text: isWalletSelected ? MyStrings.payFromWallet : MyStrings.continueToGateway,
                onTap: isSubmitting || selectedRecurring == null
                    ? null
                    : () async {
                        setState(() {
                          isSubmitting = true;
                        });
                        await widget.controller.submitPlanPurchase(
                          plan: widget.plan,
                          selectedRecurring: selectedRecurring!,
                          paymentOption: selectedPaymentOption,
                        );
                        if (mounted) {
                          setState(() {
                            isSubmitting = false;
                          });
                        }
                      },
              ),
              if (isSubmitting) ...[SizedBox(height: Dimensions.space12.h), const Center(child: CustomLoader())],
            ],
          ),
        ),
      ),
    );
  }
}

class _StarterPlanPurchasedSheet extends StatelessWidget {
  final String planName;

  const _StarterPlanPurchasedSheet({required this.planName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.space24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46.w,
              height: 5.h,
              decoration: BoxDecoration(color: MyColor.dashboardCardBorder, borderRadius: BorderRadius.circular(999.r)),
            ),
            SizedBox(height: Dimensions.space18.h),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: Get.back,
                icon: Icon(Icons.close_rounded, size: 20.sp, color: MyColor.fieldTitleTextColor),
              ),
            ),
            MyAssetImageWidget(isSvg: true, assetPath: MyImages.noDataImage, height: 110.h, width: 110.w),
            SizedBox(height: Dimensions.space16.h),
            Text(
              MyStrings.starterPlanAlreadyPurchased.tr,
              textAlign: TextAlign.center,
              style: MyTextStyle.heading20W700().copyWith(color: MyColor.regularHederColor, fontSize: 22.sp),
            ),
            SizedBox(height: Dimensions.space10.h),
            Text(
              '${planName.tr}: ${MyStrings.starterPlanPurchasedMessage.tr}',
              textAlign: TextAlign.center,
              style: MyTextStyle.subHeading14W500().copyWith(color: MyColor.fieldTitleTextColor, height: 1.5),
            ),
            SizedBox(height: Dimensions.space22.h),
            SubscriptionPrimaryButton(text: MyStrings.close, onTap: Get.back),
          ],
        ),
      ),
    );
  }
}

class _PurchaseInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String trailing;

  const _PurchaseInfoTile({required this.label, required this.value, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.tr, style: MyTextStyle.heading12W600().copyWith(color: MyColor.fieldTitleTextColor)),
              SizedBox(height: Dimensions.space4.h),
              Text(value.tr, style: MyTextStyle.heading14W600().copyWith(color: MyColor.regularHederColor)),
            ],
          ),
        ),
        SizedBox(width: Dimensions.space12.w),
        Text(trailing, style: MyTextStyle.heading16W600UseTextColor().copyWith(fontSize: 18.sp)),
      ],
    );
  }
}

class _PaymentModeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentModeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.space16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.all(Dimensions.space14.r),
          decoration: BoxDecoration(
            color: isSelected ? MyColor.getPrimaryColor().withValues(alpha: .08) : MyColor.searchItemBgColor,
            borderRadius: BorderRadius.circular(Dimensions.space16.r),
            border: Border.all(color: isSelected ? MyColor.getPrimaryColor() : MyColor.dashboardCardBorder),
          ),
          child: Row(
            children: [
              Container(
                height: 42.w,
                width: 42.w,
                decoration: BoxDecoration(
                  color: isSelected ? MyColor.getPrimaryColor().withValues(alpha: .14) : MyColor.white,
                  borderRadius: BorderRadius.circular(Dimensions.space12.r),
                ),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: isSelected ? MyColor.getPrimaryColor() : MyColor.fieldTitleTextColor,
                ),
              ),
              SizedBox(width: Dimensions.space12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title.tr, style: MyTextStyle.heading14W600().copyWith(color: MyColor.regularHederColor)),
                    SizedBox(height: Dimensions.space4.h),
                    Text(
                      subtitle.tr,
                      style: MyTextStyle.subHeading12W400().copyWith(color: MyColor.fieldTitleTextColor),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: isSelected ? MyColor.getPrimaryColor() : MyColor.fieldTitleTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanLimitRow extends StatelessWidget {
  final _PlanLimitItem item;

  const _PlanLimitRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final String normalizedValue = item.value.toLowerCase();
    final bool isEnabled = normalizedValue == MyStrings.yes.toLowerCase();
    final bool isDisabled = normalizedValue == MyStrings.no.toLowerCase();
    final Color valueColor = isEnabled
        ? MyColor.customerText
        : isDisabled
        ? MyColor.errorColor
        : MyColor.regularHederColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            item.title.tr,
            style: MyTextStyle.subHeading14W500().copyWith(color: MyColor.fieldTitleTextColor, height: 1.3),
          ),
        ),
        SizedBox(width: Dimensions.space5.w),
        Flexible(
          child: Text(
            item.value.tr,
            textAlign: TextAlign.right,
            style: MyTextStyle.heading14W600().copyWith(color: valueColor),
          ),
        ),
      ],
    );
  }
}

class _CarouselDots extends StatelessWidget {
  final int itemCount;
  final double currentPage;

  const _CarouselDots({required this.itemCount, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final bool isSelected = currentPage.round() == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: isSelected ? 24.w : 8.w,
          decoration: BoxDecoration(
            color: isSelected ? MyColor.getPrimaryColor() : MyColor.dashboardCardBorder,
            borderRadius: BorderRadius.circular(Dimensions.space50.r),
          ),
        );
      }),
    );
  }
}
