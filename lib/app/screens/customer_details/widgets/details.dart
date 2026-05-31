import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/text-field/custom_drop_down_button_with_text_field2.dart';
import 'package:ovowpp/app/screens/customer_details/widgets/tags.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/customer_details/customer_details_controller.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<CustomerDetailsController>(
      builder: (controller) => Column(
        children: [
          spaceDown(Dimensions.space45.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              MyStrings.tags.tr,
              style: theme.textTheme.titleSmall?.copyWith(color: MyColor.getHeadingTextColor()),
            ),
          ),
          spaceDown(Dimensions.space4.h),
          Tags(),
          spaceDown(Dimensions.space15.h),
          CustomDropDownTextField2(
            radius: Dimensions.space10,
            labelText: MyStrings.selectStatus.tr,
            selectedValue: controller.conversation?.status == "2"
                ? "Pending"
                : controller.conversation?.status == "3"
                ? "Important"
                : controller.conversation?.status == "1"
                ? "Done"
                : "None",
            onChanged: (v) {
              controller.changeStatus(
                v == "Pending"
                    ? "2"
                    : v == "Important"
                    ? "3"
                    : v == "Done"
                    ? "1"
                    : "",
              );
            },
            items: controller.status.map((String value) {
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
    );
  }
}
