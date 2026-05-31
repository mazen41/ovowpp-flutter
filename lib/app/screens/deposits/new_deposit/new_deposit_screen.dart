import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/shimmer/new_deposit_shimmer.dart';

import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/deposits/new_deposit/deposit_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/deposit/add_new_deposit_controller.dart';
import '../../../../data/repo/deposit/deposit_repo.dart';
import 'info_widget.dart';

class NewDepositScreen extends StatefulWidget {
  const NewDepositScreen({super.key});

  @override
  State<NewDepositScreen> createState() => _NewDepositScreenState();
}

class _NewDepositScreenState extends State<NewDepositScreen> {
  @override
  void initState() {
    if (!Get.isRegistered<DepositRepo>()) {
      Get.put(DepositRepo());
    }
    if (Get.isRegistered<AddNewDepositController>()) {
      Get.delete<AddNewDepositController>(force: true);
    }
    final controller = Get.put(AddNewDepositController(depositRepo: Get.find()));
    controller.configureFromArguments(Get.arguments);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getDepositMethod();
    });
  }

  @override
  void dispose() {
    Get.find<AddNewDepositController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<AddNewDepositController>(
      builder: (controller) => AnnotatedRegionWidget(
        top: true,
        child: MyCustomScaffold(
          pageTitle: controller.isSubscriptionDeposit ? 'Make payment' : MyStrings.deposit.tr,
          body: controller.isLoading
              ? const NewDepositShimmer()
              : SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                    ),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.isSubscriptionDeposit) ...[
                            _SubscriptionPurchaseBanner(controller: controller),
                            const SizedBox(height: Dimensions.space15),
                          ],
                          LabelTextField(
                            onTap: () {
                              DepositBottomsheet.deposittBottomSheet(context, controller);
                            },
                            readOnly: true,
                            needOutline: true,
                            radius: Dimensions.defaultRadius,
                            labelText: MyStrings.selectPaymentMethod,
                            hintText: MyStrings.selectaMethod,
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            controller: controller.selectedPaymentMethodController,
                            onChanged: (value) {
                              return;
                            },
                            suffixIcon: UnconstrainedBox(
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.space2),
                                decoration: BoxDecoration(
                                  color: MyColor.getBodyTextColor().withValues(alpha: 0.22),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.keyboard_arrow_down_sharp, color: MyColor.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space15),
                          LabelTextField(
                            onTap: () {},
                            labelText: MyStrings.amount,
                            hintText: MyStrings.enterAmount.tr,
                            inputAction: TextInputAction.done,
                            controller: controller.amountController,
                            readOnly: controller.isSubscriptionDeposit,
                            textInputType: TextInputType.number,
                            suffixIcon: UnconstrainedBox(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space10,
                                  vertical: Dimensions.space8,
                                ),
                                margin: const EdgeInsets.only(right: Dimensions.space8),
                                decoration: BoxDecoration(
                                  color: MyColor.getBodyTextColor().withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(Dimensions.space8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.currency,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: MyColor.getPrimaryColor(),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (controller.isSubscriptionDeposit) {
                                return;
                              }
                              if (value.toString().isEmpty) {
                                controller.changeInfoWidgetValue(0);
                              } else {
                                double amount = double.tryParse(value.toString()) ?? 0;
                                controller.changeInfoWidgetValue(amount);
                              }
                              return;
                            },
                          ),
                          if (controller.paymentMethod?.id != -1) ...[const InfoWidget()],
                          const SizedBox(height: 35),
                          CustomElevatedBtn(
                            isLoading: controller.submitLoading,
                            text: MyStrings.submit,
                            onTap: () {
                              controller.submitDeposit();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _SubscriptionPurchaseBanner extends StatelessWidget {
  final AddNewDepositController controller;

  const _SubscriptionPurchaseBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.space16),
      decoration: BoxDecoration(
        color: MyColor.getPrimaryColor().withValues(alpha: .06),
        borderRadius: BorderRadius.circular(Dimensions.space16),
        border: Border.all(color: MyColor.getPrimaryColor().withValues(alpha: .18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyStrings.planDetails.tr,
            style: theme.textTheme.labelLarge?.copyWith(color: MyColor.getPrimaryColor(), fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: Dimensions.space10),
          _PurchaseInfoRow(label: MyStrings.plan, value: controller.subscriptionPlanName),
          const SizedBox(height: Dimensions.space8),
          _PurchaseInfoRow(label: MyStrings.billingCycle, value: controller.recurringLabel),
          const SizedBox(height: Dimensions.space8),
          _PurchaseInfoRow(
            label: MyStrings.amount,
            value:
                '${AppConverter.formatNumber(controller.amountController.text, precision: 2)} ${controller.currency}',
          ),
          if (controller.subscriptionCouponCode.isNotEmpty) ...[
            const SizedBox(height: Dimensions.space8),
            _PurchaseInfoRow(label: MyStrings.couponCode, value: controller.subscriptionCouponCode),
          ],
        ],
      ),
    );
  }
}

class _PurchaseInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _PurchaseInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(label.tr, style: theme.textTheme.labelMedium?.copyWith(color: MyColor.lightBodyText)),
        ),
        const SizedBox(width: Dimensions.space10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: theme.textTheme.labelMedium?.copyWith(
              color: MyColor.getBodyTextColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
