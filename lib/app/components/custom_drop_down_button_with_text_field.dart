import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:get/get.dart';

class CustomDropDownWithTextField extends StatefulWidget {
  final String? title, selectedValue;
  final List<String>? list;
  final ValueChanged? onChanged;
  final TextStyle? selectedTextStyle;
  final TextStyle? itemTextStyle;
  final double borderWidth;

  CustomDropDownWithTextField({
    super.key,
    this.title,
    this.selectedValue,
    this.list,
    this.onChanged,
    this.itemTextStyle,
    this.selectedTextStyle,
    this.borderWidth = 1.0,
  }) : assert(
         list != null && list.contains(selectedValue),
         "Selected value must be from the list & list can't be empty",
       );

  @override
  State<CustomDropDownWithTextField> createState() => _CustomDropDownWithTextFieldState();
}

class _CustomDropDownWithTextFieldState extends State<CustomDropDownWithTextField> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    widget.list?.removeWhere((element) => element.isEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: MyColor.getTransparentColor(),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: MyColor.getBorderColor(), width: widget.borderWidth),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            child: DropdownButton(
              isExpanded: true,
              underline: Container(),
              hint: Text(
                widget.selectedValue?.tr ?? '',
                style: widget.selectedTextStyle ?? theme.textTheme.labelMedium?.copyWith(color: MyColor.black),
              ), // Not necessary for Option 1
              value: widget.selectedValue,
              dropdownColor: MyColor.white,
              onChanged: widget.onChanged,
              items: widget.list!.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Row(
                    children: [
                      Text(
                        value.tr,
                        style: widget.itemTextStyle ?? theme.textTheme.labelMedium?.copyWith(color: MyColor.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
