import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/new_deposit_shimmer.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/withdraw/add_withdraw_screen/withdraw_bottomsheet.dart';
import 'package:get/get.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/withdraw/add_new_withdraw_controller.dart';
import '../../../../data/repo/withdraw/withdraw_repo.dart';
import '../../../components/app-bar/custom_app_bar.dart';
import '../../../components/text-field/custom_drop_down_button_with_text_field2.dart';
import 'info_widget.dart';

class AddWithdrawMethod extends StatefulWidget {
  const AddWithdrawMethod({super.key});

  @override
  State<AddWithdrawMethod> createState() => _AddWithdrawMethodState();
}

class _AddWithdrawMethodState extends State<AddWithdrawMethod> {
  @override
  void initState() {
    Get.put(WithdrawRepo());
    final controller = Get.put(AddNewWithdrawController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadWithdrawMethod();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<AddNewWithdrawController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(title: MyStrings.addWithdraw.tr),
          body: controller.isLoading
              ? const NewDepositShimmer()
              : SingleChildScrollView(
                  padding: Dimensions.screenPadding,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space20),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColor.dashboardCardBorder),
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTextField(
                          onTap: () {
                            WithdrawBottomsheet.withdrawBottomSheet(context, controller);
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
                            if (value.toString().isEmpty) {
                              controller.changeInfoWidgetValue(0);
                            } else {
                              double amount = double.tryParse(value.toString()) ?? 0;
                              controller.changeInfoWidgetValue(amount);
                            }
                            return;
                          },
                        ),
                        Visibility(
                          visible: controller.authorizationList.length > 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: Dimensions.space15),
                              CustomDropDownTextField2(
                                labelText: MyStrings.authorizationMethod.tr,
                                selectedValue: controller.selectedAuthorizationMode,
                                onChanged: (value) {
                                  controller.changeAuthorizationMode(value);
                                },
                                items: controller.authorizationList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      (value.toString()).tr,
                                      style: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        if (controller.mainAmount > 0) ...[const InfoWidget()],
                        const SizedBox(height: 35),
                        CustomElevatedBtn(
                          isLoading: controller.submitLoading,
                          text: MyStrings.submit,
                          onTap: () {
                            controller.submitWithdrawRequest();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
