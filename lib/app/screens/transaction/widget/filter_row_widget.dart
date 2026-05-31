import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../../../../core/utils/my_color.dart';

class FilterRowWidget extends StatefulWidget {
  final String text;
  final bool fromTrx;
  final Color iconColor;
  final Callback onTap;
  final bool isFilterBtn;
  final Color bgColor;

  const FilterRowWidget({
    super.key,
    this.bgColor = MyColor.transparent,
    this.isFilterBtn = false,
    this.iconColor = MyColor.black,
    required this.text,
    required this.onTap,
    this.fromTrx = false,
  });

  @override
  State<FilterRowWidget> createState() => _FilterRowWidgetState();
}

class _FilterRowWidgetState extends State<FilterRowWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: widget.isFilterBtn ? MyColor.getPrimaryColor() : widget.bgColor,
          border: Border.all(color: MyColor.getBorderColor(), width: widget.isFilterBtn ? 0 : 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.fromTrx
                ? Expanded(
                    child: Text(
                      widget.text.tr,
                      style: theme.textTheme.labelMedium?.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: MyColor.black,
                      ),
                    ),
                  )
                : Expanded(
                    child: Text(
                      widget.text.tr,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: MyColor.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
            const SizedBox(width: 20),
            Icon(Icons.expand_more, color: widget.iconColor, size: 17),
          ],
        ),
      ),
    );
  }
}
