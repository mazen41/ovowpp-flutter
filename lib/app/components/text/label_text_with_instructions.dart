import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class LabelTextInstruction extends StatelessWidget {
  final bool isRequired;
  final String text;
  final String? instructions;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const LabelTextInstruction({
    super.key,
    required this.text,
    this.textAlign,
    this.textStyle,
    this.isRequired = false,
    this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

    return isRequired
        ? Row(
            children: [
              Text(
                text.tr,
                textAlign: textAlign,
                style: textStyle ?? theme.textTheme.titleSmall?.copyWith(color: MyColor.getBodyTextColor()),
              ),
              const SizedBox(width: 2),
              if (instructions != null) ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: Dimensions.space2, end: Dimensions.space10),
                  child: Tooltip(
                    key: tooltipKey,
                    message: "$instructions",
                    child: GestureDetector(
                      onTap: () {
                        tooltipKey.currentState?.ensureTooltipVisible();
                      },
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: Dimensions.space15,
                        color: Theme.of(context).textTheme.titleLarge!.color?.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ],
              Text('*', style: theme.textTheme.titleSmall?.copyWith(color: MyColor.getErrorColor())),
            ],
          )
        : Row(
            children: [
              Text(
                text.tr,
                textAlign: textAlign,
                style: textStyle ?? theme.textTheme.titleSmall?.copyWith(color: MyColor.getBodyTextColor()),
              ),
              if (instructions != null) ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: Dimensions.space2, end: Dimensions.space10),
                  child: Tooltip(
                    key: tooltipKey,
                    message: "$instructions",
                    child: GestureDetector(
                      onTap: () {
                        tooltipKey.currentState?.ensureTooltipVisible();
                      },
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: Dimensions.space15,
                        color: MyColor.getBodyTextColor().withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
  }
}
