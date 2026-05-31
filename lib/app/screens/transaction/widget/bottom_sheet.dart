import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovowpp/app/components/row_widget/bottom_sheet_top_row.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/data/controller/transaction/transactions_controller.dart';
import 'package:get/get.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';

void showTrxBottomSheet(List<String>? list, int callFrom, String header, {required BuildContext context}) {
  ThemeData theme = Theme.of(context);
  if (list != null && list.isNotEmpty) {
    CustomBottomSheet(
      bgColor: MyColor.getScaffoldBackgroundColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BottomSheetTopRow(header: header, bgColor: MyColor.white),
          SizedBox(
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      String selectedValue = list[index];
                      final controller = Get.find<TransactionsController>();

                      if (callFrom == 1) {
                        controller.changeSelectedTrxType(selectedValue);
                        controller.filterData();
                      } else if (callFrom == 2) {
                        controller.changeSelectedRemark(selectedValue);
                        controller.filterData();
                      }

                      Navigator.pop(context);
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: theme.cardColor),
                      child: Text(
                        ' ${callFrom == 2 ? AppConverter.replaceUnderscoreWithSpace(list[index].capitalizeFirst ?? '') : list[index]}',
                        style: theme.textTheme.labelMedium?.copyWith(fontSize: Dimensions.fontDefault),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).customBottomSheet(context);
  }
}
