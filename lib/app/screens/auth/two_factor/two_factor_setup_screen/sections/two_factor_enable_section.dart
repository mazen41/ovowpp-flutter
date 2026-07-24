import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/divider/custom_divider.dart';
import 'package:ovowpp/app/components/text/small_text.dart';
import 'package:ovowpp/app/screens/auth/two_factor/two_factor_setup_screen/widget/enable_qr_code_widget.dart';
import 'package:ovowpp/data/controller/auth/two_factor_controller.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/my_color.dart';
import '../../../../../../core/utils/my_strings.dart';

class TwoFactorEnableSection extends StatelessWidget {
  const TwoFactorEnableSection({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<TwoFactorController>(
      builder: (twoFactorController) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MyColor.getBorderColor()),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          MyStrings.addYourAccount.tr,
                          style: theme.textTheme.titleMedium?.copyWith(color: MyColor.getHeadingTextColor()),
                        ),
                      ),
                      const CustomDivider(),
                      Center(
                        child: Text(
                          MyStrings.useQRCODETips.tr,
                          style: theme.textTheme.titleMedium?.copyWith(color: MyColor.getHeadingTextColor()),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space17),
                      if (twoFactorController.twoFactorCodeModel.data?.qrCodeUrl != null) ...[
                        EnableQRCodeWidget(
                          qrImage: twoFactorController.twoFactorCodeModel.data?.qrCodeUrl ?? '',
                          secret: "${twoFactorController.twoFactorCodeModel.data?.secret}",
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                // enable
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MyColor.getBorderColor()),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          MyStrings.enable2Fa.tr,
                          style: theme.textTheme.titleMedium?.copyWith(color: MyColor.getHeadingTextColor()),
                        ),
                      ),
                      const CustomDivider(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .07),
                        child: SmallText(
                          text: MyStrings.twoFactorMsg.tr,
                          maxLine: 3,
                          textAlign: TextAlign.center,
                          textStyle: theme.textTheme.labelMedium!.copyWith(color: MyColor.getHeadingTextColor()),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                        child: MaterialPinField(
                          length: 6,
                          obscureText: false,
                          blinkWhenObscuring: false,
                          theme: MaterialPinTheme(
                            shape: MaterialPinShape.outlined,
                            cellSize: const Size(40, 40),
                            spacing: 8,
                            borderWidth: 1,
                            focusedBorderWidth: 1,
                            borderRadius: BorderRadius.circular(5),
                            borderColor: MyColor.getBorderColor(),
                            fillColor: MyColor.getTransparentColor(),
                            filledFillColor: MyColor.getTransparentColor(),
                            filledBorderColor: MyColor.getPrimaryColor(),
                            focusedFillColor: MyColor.getTransparentColor(),
                            focusedBorderColor: MyColor.getPrimaryColor(),
                            textStyle: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                            obscuringCharacter: '*',
                            cursorColor: MyColor.white,
                            entryAnimation: MaterialPinAnimation.fade,
                            animationDuration: const Duration(milliseconds: 100),
                          ),
                          keyboardType: TextInputType.number,
                          enablePaste: true,
                          onChanged: (value) {
                            twoFactorController.currentText = value;
                            twoFactorController.update();
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.space30),
                      CustomElevatedBtn(
                        isLoading: twoFactorController.submitLoading,
                        onTap: () {
                          twoFactorController.enable2fa(
                            twoFactorController.twoFactorCodeModel.data?.secret ?? '',
                            twoFactorController.currentText,
                          );
                        },
                        text: MyStrings.submit.tr,
                      ),
                      const SizedBox(height: Dimensions.space30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
