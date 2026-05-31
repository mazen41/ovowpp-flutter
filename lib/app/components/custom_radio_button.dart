import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/util_exporter.dart';

class CustomRadioButton extends StatefulWidget {
  final String? title;
  final String? selectedValue;
  final int selectedIndex;
  final List<String> list;
  final ValueChanged? onChanged;

  const CustomRadioButton({
    super.key,
    this.title,
    this.selectedIndex = 0,
    this.selectedValue,
    required this.list,
    this.onChanged,
  });

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  late int _currentSelectedIndex;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(CustomRadioButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _currentSelectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (widget.list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        if (widget.title != null && widget.title!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(widget.title!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),

        // ✅ Radio Options using GestureDetector (No deprecation warnings)
        ...List<Widget>.generate(widget.list.length, (int index) {
          final isSelected = index == _currentSelectedIndex;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentSelectedIndex = index;
                });
                widget.onChanged?.call(index);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    // Custom Radio Button
                    Container(
                      width: 20.w,
                      height: 20.w,
                      margin: EdgeInsets.only(right: 12.w, left: 16.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? MyColor.getPrimaryColor()
                              : MyColor.black.withAlpha(MyColor.getAlpha(150)),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.getPrimaryColor()),
                              ),
                            )
                          : null,
                    ),

                    // Label
                    Expanded(
                      child: Text(
                        widget.list[index].tr,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: MyColor.black,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
