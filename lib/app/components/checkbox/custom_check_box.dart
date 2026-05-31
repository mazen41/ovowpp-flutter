import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class CustomCheckBox extends StatefulWidget {
  final List<String>? selectedValue;
  final List<String> list;
  final ValueChanged? onChanged;

  const CustomCheckBox({super.key, this.selectedValue, required this.list, this.onChanged});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (widget.list.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        Column(
          children: List<CheckboxListTile>.generate(widget.list.length, (int index) {
            List<String>? s = widget.selectedValue;
            bool selected_ = s != null ? s.contains(widget.list[index]) : false;
            return CheckboxListTile(
              value: selected_,
              activeColor: MyColor.getPrimaryColor(),
              title: Text(widget.list[index].tr, style: theme.textTheme.labelMedium?.copyWith(color: MyColor.black)),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    widget.onChanged!('${index}_$value');
                  }
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
