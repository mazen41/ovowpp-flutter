import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/controller/customer_details/customer_details_controller.dart';

import '../../../../core/utils/util_exporter.dart';

class Tags extends StatelessWidget {
  const Tags({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<CustomerDetailsController>(
      builder: (controller) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            controller.tags.length,
            (index) => Container(
              margin: EdgeInsets.only(right: Dimensions.space8.w),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space5),
              decoration: BoxDecoration(
                border: Border.all(color: MyColor.getPrimaryColor()),
                color: MyColor.getCardBackgroundColor(),
                borderRadius: BorderRadius.circular(Dimensions.space8),
              ),
              child: Center(
                child: Text(
                  controller.tags[index].name ?? "",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: MyColor.getPrimaryColor(),
                    fontSize: Dimensions.space15.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
