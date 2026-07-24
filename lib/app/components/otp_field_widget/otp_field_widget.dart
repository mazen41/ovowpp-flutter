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
          fillColor: MyColor.lightTextFieldFillColor.withValues(alpha: .80),
          filledFillColor: MyColor.getScaffoldBackgroundColor(),
          filledBorderColor: MyColor.getPrimaryColor(),
          focusedFillColor: MyColor.getScaffoldBackgroundColor(),
          focusedBorderColor: MyColor.getPrimaryColor(),
          textStyle: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
          obscuringCharacter: '*',
          cursorColor: MyColor.black,
          entryAnimation: MaterialPinAnimation.fade,
          animationDuration: const Duration(milliseconds: 100),
        ),
        keyboardType: TextInputType.number,
        enablePaste: true,
        onChanged: onChanged,
      ),
    );
  }
}
