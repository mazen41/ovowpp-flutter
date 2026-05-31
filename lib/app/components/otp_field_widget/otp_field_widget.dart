import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';

class OTPFieldWidget extends StatelessWidget {
  const OTPFieldWidget({super.key, required this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
        length: 6,
        textStyle: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
        obscureText: false,
        obscuringCharacter: '*',
        blinkWhenObscuring: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderWidth: 1,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 40,
          fieldWidth: 40,
          inactiveColor: MyColor.getBorderColor(),
          inactiveFillColor: MyColor.lightTextFieldFillColor.withValues(alpha: .80),
          activeFillColor: MyColor.getScaffoldBackgroundColor(),
          activeColor: MyColor.getPrimaryColor(),
          selectedFillColor: MyColor.getScaffoldBackgroundColor(),
          selectedColor: MyColor.getPrimaryColor(),
        ),
        cursorColor: MyColor.black,
        animationDuration: const Duration(milliseconds: 100),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        beforeTextPaste: (text) {
          return true;
        },
        onChanged: (value) => onChanged!(value),
      ),
    );
  }
}
