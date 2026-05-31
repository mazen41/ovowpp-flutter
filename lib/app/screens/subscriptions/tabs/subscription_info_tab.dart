import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/screens/subscriptions/widgets/subscription_widgets.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/subscription/subscription_controller.dart';
import 'package:ovowpp/data/model/subscription/pricing_plan_response_model.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class SubscriptionInfoTab extends StatelessWidget {
  const SubscriptionInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CustomLoader());
        }

        final PricingPlan? plan = controller.currentPricingPlan;
        if (controller.user == null &&
            controller.activePlan == null &&
            controller.purchaseData == null &&
            plan == null) {
          return const Center(child: NoDataWidget());
        }

        final List<_FeatureLimitData> features = _buildFeatures(controller);
        final String billingCycle = _resolveBillingCycle(controller.purchaseData, controller.activePlan);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: Dimensions.space24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubscriptionInfoCard(controller: controller, plan: plan),
              SizedBox(height: Dimensions.space24.h),
              Row(
                children: [
                  Text(MyStrings.featureLimits.tr, style: MyTextStyle.heading20W700().copyWith(fontSize: 24.sp)),
                  const Spacer(),
                  if (billingCycle.isNotEmpty)
                    Text(
                      billingCycle.toUpperCase(),
                      style: MyTextStyle.heading12W600().copyWith(color: MyColor.getPrimaryColor()),
                    ),
                ],
              ),
              SizedBox(height: Dimensions.space14.h),
              ...features.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.space10.h),
                  child: SubscriptionInfoListTile(data: item),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<_FeatureLimitData> _buildFeatures(SubscriptionController controller) {
    final user = controller.user;
    return [
      _FeatureLimitData(title: MyStrings.whatsappAccountLimit, value: _limitValue(user?.accountLimit)),
      _FeatureLimitData(title: MyStrings.agentLimit, value: _limitValue(user?.agentLimit)),
      _FeatureLimitData(title: MyStrings.contactLimit, value: _limitValue(user?.contactLimit)),
      _FeatureLimitData(title: MyStrings.templateLimit, value: _limitValue(user?.templateLimit)),
      _FeatureLimitData(
        title: MyStrings.automationFlowLimit,
        value: _limitValue(controller.currentPricingPlan?.flowLimit),
      ),
      _FeatureLimitData(
        title: MyStrings.campaignLimit,
        value: _limitValue(user?.campaignLimit ?? controller.currentPricingPlan?.campaignLimit),
      ),
      _FeatureLimitData(
        title: MyStrings.shortLinkLimit,
        value: _limitValue(user?.shortLinkLimit ?? controller.currentPricingPlan?.shortLinkLimit),
      ),
      _FeatureLimitData(
        title: MyStrings.floaterLimit,
        value: _limitValue(user?.floaterLimit ?? controller.currentPricingPlan?.floaterLimit),
      ),
      _FeatureLimitData(
        title: MyStrings.welcomeMessageAvailable,
        value: _yesNoValue(user?.welcomeMessage ?? controller.currentPricingPlan?.welcomeMessage),
      ),
      _FeatureLimitData(
        title: MyStrings.aiAssistance,
        value: _yesNoValue(user?.aiAssistance ?? controller.currentPricingPlan?.aiAssistance),
      ),
      _FeatureLimitData(
        title: MyStrings.interactiveMessage,
        value: _yesNoValue(controller.currentPricingPlan?.interactiveMessage),
      ),
      _FeatureLimitData(
        title: MyStrings.ecommerceAvailable,
        value: _yesNoValue(controller.currentPricingPlan?.ecommerceAvailable),
      ),
      _FeatureLimitData(title: MyStrings.apiAvailable, value: _yesNoValue(controller.currentPricingPlan?.apiAvailable)),
    ];
  }

  String _yesNoValue(String? value) {
    final normalized = _cleanValue(value) ?? '0';
    return normalized == '1' ? MyStrings.yes : MyStrings.no;
  }

  String _limitValue(String? value) {
    final normalized = _cleanValue(value);
    if (normalized == '-1') return MyStrings.unlimited;
    return normalized ?? '0';
  }

  String _resolveBillingCycle(PurchaseData? purchaseData, ActivePlan? activePlan) {
    final String value = _cleanValue(purchaseData?.billingCycle ?? activePlan?.billingCycle) ?? '';
    if (value.isEmpty) return '';
    return 'Billing: ${value.capitalizeFirst ?? value}';
  }

  String? _cleanValue(String? value) {
    final normalized = (value ?? '').trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') return null;
    return normalized;
  }
}

class _FeatureLimitData {
  final String title;
  final String value;

  const _FeatureLimitData({required this.title, required this.value});
}

class SubscriptionInfoCard extends StatelessWidget {
  final SubscriptionController controller;
  final PricingPlan? plan;

  const SubscriptionInfoCard({super.key, required this.controller, required this.plan});

  @override
  Widget build(BuildContext context) {
    final ActivePlan? activePlan = controller.activePlan;
    final PurchaseData? purchaseData = controller.purchaseData;
    final String currencyCode = SharedPreferenceService.getCurrencyText().isEmpty
        ? MyStrings.usd
        : SharedPreferenceService.getCurrencyText();
    final String amount =
        _cleanValue(purchaseData?.total) ??
        _cleanValue(purchaseData?.amount) ??
        _resolvePlanAmount(activePlan, plan, purchaseData?.billingCycle ?? activePlan?.billingCycle) ??
        '0';
    final String planName = _cleanValue(activePlan?.name) ?? _cleanValue(plan?.name) ?? MyStrings.noData;
    final String billingCycle = _resolveBillingLabel(purchaseData?.billingCycle ?? activePlan?.billingCycle);
    final String purchaseDate = _formatDateTime(purchaseData?.purchaseAt ?? purchaseData?.createdAt);
    final String activatedDate = _formatDateTime(purchaseData?.activeAt ?? purchaseData?.createdAt);
    final String nextBillingDate = _formatDateTime(
      controller.user?.planExpiredAt ??
          purchaseData?.nextBillingAt ??
          purchaseData?.nextInvoiceAt ??
          purchaseData?.expiredAt ??
          activePlan?.expiredAt,
    );
    final String description = _cleanValue(activePlan?.description) ?? _cleanValue(plan?.description) ?? '';
    final String renewalText = _renewalHint(
      controller.user?.planExpiredAt ??
          purchaseData?.nextBillingAt ??
          purchaseData?.nextInvoiceAt ??
          purchaseData?.expiredAt ??
          activePlan?.expiredAt,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.space18.r),
      decoration: BoxDecoration(
        color: const Color(0xFF283129),
        borderRadius: BorderRadius.circular(Dimensions.space20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .10), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.space12.w, vertical: Dimensions.space8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(Dimensions.space10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 8.w,
                      width: 8.w,
                      decoration: const BoxDecoration(color: Color(0xFF3AED7C), shape: BoxShape.circle),
                    ),
                    SizedBox(width: Dimensions.space8.w),
                    Text(
                      'MY ACTIVE PLAN',
                      style: MyTextStyle.heading12W600().copyWith(color: MyColor.white, letterSpacing: .4),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(MyStrings.autoRenewal.tr, style: MyTextStyle.heading12W600().copyWith(color: MyColor.white)),
            ],
          ),
          SizedBox(height: Dimensions.space24.h),
          Text(
            planName.tr,
            style: MyTextStyle.heading20W700().copyWith(color: const Color(0xFF2AF06D), fontSize: 30.sp),
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: Dimensions.space6.h),
            Text(
              description.tr,
              style: MyTextStyle.subHeading14W500().copyWith(color: MyColor.white.withValues(alpha: .92), height: 1.35),
            ),
          ],
          SizedBox(height: Dimensions.space20.h),
          Divider(color: Colors.white.withValues(alpha: .16), height: 1),
          SizedBox(height: Dimensions.space18.h),
          _InfoRow(
            label: MyStrings.totalText,
            value: '${AppConverter.formatNumber(amount, precision: 2)} $currencyCode',
          ),
          SizedBox(height: Dimensions.space8.h),
          _InfoRow(label: MyStrings.billingCycle, value: billingCycle),
          SizedBox(height: Dimensions.space8.h),
          _InfoRow(label: MyStrings.purchaseAt, value: purchaseDate),
          SizedBox(height: Dimensions.space8.h),
          _InfoRow(label: MyStrings.activatedOn, value: activatedDate),
          SizedBox(height: Dimensions.space8.h),
          _InfoRow(label: MyStrings.nextBillingDate, value: nextBillingDate),
          SizedBox(height: Dimensions.space20.h),
          SizedBox(
            width: 150.w,
            child: SubscriptionPrimaryButton(
              text: MyStrings.renewNow,
              onTap: () => DefaultTabController.of(context).animateTo(0),
            ),
          ),
          if (renewalText.isNotEmpty) ...[
            SizedBox(height: Dimensions.space14.h),
            Text(
              renewalText,
              style: MyTextStyle.subHeading14W500().copyWith(
                color: const Color(0xFF79F3A6),
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF79F3A6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? _resolvePlanAmount(ActivePlan? activePlan, PricingPlan? plan, String? billingCycle) {
    final bool prefersYearly =
        (_cleanValue(billingCycle) ?? '').toLowerCase().contains('year') || (_cleanValue(billingCycle) ?? '') == '2';
    if (prefersYearly) {
      return _cleanValue(activePlan?.yearlyPrice) ??
          _cleanValue(plan?.yearlyPrice) ??
          _cleanValue(activePlan?.monthlyPrice) ??
          _cleanValue(plan?.monthlyPrice);
    }
    return _cleanValue(activePlan?.monthlyPrice) ??
        _cleanValue(plan?.monthlyPrice) ??
        _cleanValue(activePlan?.yearlyPrice) ??
        _cleanValue(plan?.yearlyPrice);
  }

  String _resolveBillingLabel(String? billingCycle) {
    final String value = (_cleanValue(billingCycle) ?? '').toLowerCase();
    if (value.contains('year')) return MyStrings.yearly.tr;
    if (value.contains('month')) return MyStrings.monthly.tr;
    return '--';
  }

  String _formatDateTime(String? value) {
    final String normalized = _cleanValue(value) ?? '';
    if (normalized.isEmpty) return '--';
    try {
      final parsed = DateTime.tryParse(normalized);
      if (parsed != null) {
        final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
        final minute = parsed.minute.toString().padLeft(2, '0');
        final period = parsed.hour >= 12 ? 'PM' : 'AM';
        return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year} ${hour.toString().padLeft(2, '0')}:$minute $period';
      }
      return normalized;
    } catch (_) {
      return normalized;
    }
  }

  String _renewalHint(String? value) {
    final String normalized = _cleanValue(value) ?? '';
    if (normalized.isEmpty) return '';
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) return '';
    final Duration diff = parsed.difference(DateTime.now());
    if (diff.isNegative) return '';

    final int days = diff.inDays;
    if (days >= 365) {
      final int years = (days / 365).floor();
      return '$years year${years > 1 ? 's' : ''} from now until renewal.';
    }
    if (days >= 30) {
      final int months = (days / 30).floor();
      return '$months month${months > 1 ? 's' : ''} from now until renewal.';
    }
    return '$days day${days > 1 ? 's' : ''} from now until renewal.';
  }

  String? _cleanValue(String? value) {
    final normalized = (value ?? '').trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') return null;
    return normalized;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label.tr, style: MyTextStyle.heading14W600().copyWith(color: MyColor.white)),
        ),
        SizedBox(width: Dimensions.space12.w),
        Flexible(
          child: Text(
            value.tr,
            textAlign: TextAlign.right,
            style: MyTextStyle.heading14W600().copyWith(color: const Color(0xFF2AF06D)),
          ),
        ),
      ],
    );
  }
}

class SubscriptionInfoListTile extends StatelessWidget {
  final _FeatureLimitData data;

  const SubscriptionInfoListTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String normalizedValue = data.value.toLowerCase();
    final bool isEnabled = normalizedValue == MyStrings.yes.toLowerCase();
    final bool isDisabled = normalizedValue == MyStrings.no.toLowerCase();

    final Color badgeBackground = isEnabled
        ? MyColor.helpCenterItemBgColor
        : isDisabled
        ? const Color(0xFFFFECEC)
        : MyColor.searchItemBgColor;

    final Color badgeTextColor = isEnabled
        ? MyColor.customerText
        : isDisabled
        ? MyColor.errorColor
        : MyColor.regularHederColor;

    return SubscriptionSurfaceCard(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.space14.w, vertical: Dimensions.space14.h),
      child: Row(
        children: [
          Expanded(child: Text(data.title.tr, style: MyTextStyle.heading14W600())),
          SizedBox(width: Dimensions.space12.w),
          SubscriptionPillText(text: data.value, backgroundColor: badgeBackground, textColor: badgeTextColor),
        ],
      ),
    );
  }
}
