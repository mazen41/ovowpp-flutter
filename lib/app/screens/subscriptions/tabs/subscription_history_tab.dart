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
import 'package:ovowpp/data/model/subscription/purchase_history_response_model.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class SubscriptionHistoryTab extends StatefulWidget {
  const SubscriptionHistoryTab({super.key});

  @override
  State<SubscriptionHistoryTab> createState() => _SubscriptionHistoryTabState();
}

class _SubscriptionHistoryTabState extends State<SubscriptionHistoryTab> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<SubscriptionController>().hasNext()) {
        Get.find<SubscriptionController>().loadPaginationData();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (controller) {
        if (controller.isHistoryLoading) {
          return const Center(child: CustomLoader());
        }

        if (controller.purchaseHistoryList.isEmpty) {
          return const Center(child: NoDataWidget());
        }

        final String currencyCode = SharedPreferenceService.getCurrencyText().isEmpty
            ? MyStrings.usd
            : SharedPreferenceService.getCurrencyText();
        final String currencySymbol = SharedPreferenceService.getCurrencySymbol().isEmpty
            ? r'$'
            : SharedPreferenceService.getCurrencySymbol();
        final double totalSpent = controller.purchaseHistoryList.fold(
          0,
          (sum, item) => sum + (double.tryParse(item.amount ?? '0') ?? 0),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Text(MyStrings.billingOverview.tr.toUpperCase(), style: MyTextStyle.heading14W600().copyWith(color: MyColor.fieldTitleTextColor)),
            //     const Spacer(),
            //     Text(currencyCode, style: MyTextStyle.heading14W600().copyWith(color: MyColor.customerText)),
            //   ],
            // ),
            // SizedBox(height: Dimensions.space12.h),
            // Row(
            //   children: [
            //     Expanded(
            //       child: SubscriptionMetricCard(title: MyStrings.activeCredit, value: '$currencySymbol${totalSpent.toStringAsFixed(0)}', trailing: totalSpent.toStringAsFixed(2).split('.').last == '00' ? '' : '.${totalSpent.toStringAsFixed(2).split('.').last}', isHighlighted: false),
            //     ),
            //     SizedBox(width: Dimensions.space12.w),
            //     Expanded(
            //       child: SubscriptionMetricCard(title: MyStrings.status, value: controller.currentPricingPlan?.name ?? MyStrings.noData, trailing: '', isHighlighted: true),
            //     ),
            //   ],
            // ),
            SizedBox(height: Dimensions.space24.h),
            Text(
              MyStrings.recentTransactions.tr.toUpperCase(),
              style: MyTextStyle.heading14W600().copyWith(color: MyColor.fieldTitleTextColor),
            ),
            SizedBox(height: Dimensions.space14.h),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: Dimensions.space24.h),
                itemCount: controller.purchaseHistoryList.length + 1,
                separatorBuilder: (_, __) => SizedBox(height: Dimensions.space10.h),
                itemBuilder: (context, index) {
                  if (index == controller.purchaseHistoryList.length) {
                    return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                  }

                  final item = controller.purchaseHistoryList[index];
                  return SubscriptionTransactionTile(
                    data: item,
                    plan: _resolvePlan(controller, item.planId),
                    currencySymbol: currencySymbol,
                    controller: controller,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  PricingPlan? _resolvePlan(SubscriptionController controller, String? planId) {
    try {
      return controller.pricingPlanList.firstWhere((element) => element.id == planId);
    } catch (_) {
      return null;
    }
  }
}

class SubscriptionTransactionTile extends StatelessWidget {
  final PurchaseHistoryData data;
  final PricingPlan? plan;
  final String currencySymbol;
  final SubscriptionController controller;

  const SubscriptionTransactionTile({
    super.key,
    required this.data,
    required this.plan,
    required this.currencySymbol,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final String billingText = _billingText(data.recurringType);
    final bool isYearly = billingText.toLowerCase().contains('year');
    final Color backgroundColor = isYearly ? MyColor.helpCenterItemBgColor : MyColor.searchItemBgColor;
    final Color textColor = isYearly ? MyColor.customerText : MyColor.regularHederColor;
    final bool isDownloadingThisInvoice =
        controller.downloadingInvoice && controller.downloadingInvoiceId == (data.id ?? '');
    final String amount = _cleanValue(data.amount) ?? '0';

    return SubscriptionSurfaceCard(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.space14.w, vertical: Dimensions.space14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubscriptionIconTile(
                icon: isYearly ? Icons.workspace_premium_rounded : Icons.receipt_long_rounded,
                backgroundColor: backgroundColor,
                iconColor: textColor,
              ),
              SizedBox(width: Dimensions.space12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_title(), style: MyTextStyle.heading14W600()),
                    SizedBox(height: Dimensions.space4.h),
                    Text(_formatDate(data.createdAt), style: MyTextStyle.subHeading12W400()),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.space10.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$currencySymbol${AppConverter.formatNumber(amount, precision: 2) ?? '0'}',
                    style: MyTextStyle.heading16W600UseTextColor().copyWith(fontSize: 22.sp),
                  ),
                  Text(
                    " $billingText",
                    style: MyTextStyle.subHeading12W400().copyWith(color: MyColor.getPrimaryColor()),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Dimensions.space8.h),
          _HistoryMetaRow(label: MyStrings.expiryDate, value: _formatDate(data.expiredAt)),
          SizedBox(height: Dimensions.space4.h),
          _HistoryMetaRow(label: MyStrings.paymentMethod, value: _paymentMethod()),
          SizedBox(height: Dimensions.space8.h),
          InkWell(
            onTap: isDownloadingThisInvoice || (data.id ?? '').isEmpty
                ? null
                : () => controller.downloadInvoice(data.id ?? ''),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space10.w, vertical: Dimensions.space6.h),
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: MyColor.getPrimaryColor().withValues(alpha: .18)),
              ),
              child: isDownloadingThisInvoice
                  ? SizedBox(height: 16.h, width: 16.h, child: const CircularProgressIndicator(strokeWidth: 2))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_as_pdf_outlined, size: 16.sp, color: MyColor.getPrimaryColor()),
                        SizedBox(width: Dimensions.space4.w),
                        Text(
                          MyStrings.viewInvoice.tr,
                          style: MyTextStyle.subHeading12W600().copyWith(color: MyColor.getPrimaryColor()),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _title() {
    final String? planName = _cleanValue(plan?.name);
    if (planName != null) return planName;
    if ((data.planId ?? '').isNotEmpty) return 'Plan #${data.planId}';
    return 'Subscription Purchase';
  }

  String _paymentMethod() {
    final String paymentMethod = _cleanValue(data.paymentMethod) ?? '';
    final String? gatewayName = _cleanValue(data.gateway?.name);
    final String? gatewayMethodCode = _cleanValue(data.gatewayMethodCode);

    if (paymentMethod == '1') return MyStrings.wallet;
    if (paymentMethod == '2') return MyStrings.paymentGateway;
    if (gatewayName != null) return gatewayName;
    if (paymentMethod.isNotEmpty) return paymentMethod;
    if (gatewayMethodCode != null) return gatewayMethodCode;
    return '--';
  }

  String _billingText(String? value) {
    final String recurring = (value ?? '').toLowerCase();
    if (recurring == '2' || recurring.contains('year')) return MyStrings.yearly;
    if (recurring == '1' || recurring.contains('month')) return MyStrings.monthly;
    return recurring.isEmpty ? '--' : (recurring.capitalizeFirst ?? recurring);
  }

  String _formatDate(String? value) {
    final String normalized = _cleanValue(value) ?? '';
    if (normalized.isEmpty) return '--';
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) return normalized;
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}';
  }

  String? _cleanValue(String? value) {
    final normalized = (value ?? '').trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') return null;
    return normalized;
  }
}

class _HistoryMetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _HistoryMetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${label.tr}:', style: MyTextStyle.subHeading12W400().copyWith(color: MyColor.fieldTitleTextColor)),
        SizedBox(width: Dimensions.space6.w),
        Expanded(
          child: Text(
            value.tr,
            style: MyTextStyle.subHeading12W600().copyWith(color: MyColor.regularHederColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
