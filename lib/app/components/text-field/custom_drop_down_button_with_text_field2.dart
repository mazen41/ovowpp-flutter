import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

import '../text/label_text.dart';

class CustomDropDownTextField2 extends StatefulWidget {
  final dynamic selectedValue;
  final String? labelText;
  final String? arrowIcon;
  final String? hintText;
  final Function(dynamic)? onChanged;
  final List<DropdownMenuItem<dynamic>>? items;
  final Color? fillColor;
  final Color? focusColor;
  final Color? dropDownColor;
  final Color? iconColor;
  final double radius;
  final bool needLabel;
  final bool isUnderLined;
  final TextStyle? textStyle;

  const CustomDropDownTextField2({
    super.key,
    this.labelText,
    this.hintText,
    this.arrowIcon,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
    this.fillColor = Colors.transparent,
    this.focusColor = MyColor.white,
    this.dropDownColor = MyColor.white,
    this.iconColor = MyColor.black,
    this.radius = Dimensions.defaultRadius,
    this.needLabel = true,
    this.isUnderLined = false,
    this.textStyle,
  });

  @override
  State<CustomDropDownTextField2> createState() => _CustomDropDownTextField2State();
}

class _CustomDropDownTextField2State extends State<CustomDropDownTextField2> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.needLabel ? LabelText(text: widget.labelText.toString()) : const SizedBox(),
        widget.needLabel ? const SizedBox(height: Dimensions.textToTextSpace) : const SizedBox(),
        widget.isUnderLined
            ? SizedBox(
                height: 50,
                child: DropdownButtonFormField(
                  initialValue: widget.selectedValue,
                  dropdownColor: widget.dropDownColor,
                  focusColor: widget.focusColor,
                  style: widget.textStyle ?? theme.textTheme.headlineLarge,
                  alignment: Alignment.centerLeft,
                  decoration: InputDecoration(
                    hintText: widget.hintText.toString().tr,
                    filled: true,
                    fillColor: widget.fillColor,
                    hintStyle: theme.textTheme.titleSmall?.copyWith(color: MyColor.getBodyTextColor()),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: MyColor.getBorderColor())),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColor.getPrimaryColor())),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColor.getBorderColor())),
                  ),
                  isExpanded: true,
                  onChanged: widget.onChanged,
                  items: widget.items,
                  icon: Icon(Icons.arrow_drop_down, color: widget.iconColor),
                ),
              )
            : SizedBox(
                height: 50,
                child: DropdownButtonFormField(
                  initialValue: widget.selectedValue,
                  dropdownColor: widget.dropDownColor,
                  focusColor: widget.focusColor,
                  style: widget.textStyle ?? theme.textTheme.headlineLarge,
                  alignment: Alignment.centerLeft,
                  decoration: InputDecoration(
                    hintText: widget.hintText.toString(),
                    filled: true,
                    fillColor: widget.fillColor,
                    hintStyle: theme.textTheme.titleSmall?.copyWith(color: MyColor.getBodyTextColor()),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: BorderSide(color: MyColor.getBorderColor(), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: BorderSide(color: MyColor.getBorderColor(), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: BorderSide(color: MyColor.getPrimaryColor(), width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: BorderSide(color: MyColor.getErrorColor(), width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: BorderSide(color: MyColor.getBorderColor(), width: 1),
                    ),
                  ),
                  isExpanded: false,
                  onChanged: widget.onChanged,
                  items: widget.items,
                  icon: MyAssetImageWidget(
                    assetPath: widget.arrowIcon ?? MyImages.arrowDownSolid,
                    isSvg: true,
                    height: Dimensions.space16.h,
                    width: Dimensions.space16.h,
                  ),
                ),
              ),
      ],
    );
  }
}
