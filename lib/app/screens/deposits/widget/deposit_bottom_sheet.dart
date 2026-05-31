import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovowpp/app/components/column_widget/bottom_sheet_column.dart';
import 'package:ovowpp/app/components/custom_container/bottom_sheet_container.dart';
import 'package:ovowpp/app/components/row_widget/bottom_sheet_top_row.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:get/get.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/deposit/deposit_history_controller.dart';

class DepositBottomSheet {
  static void depositBottomSheet(BuildContext context, int index) {
    CustomBottomSheet(
      child: GetBuilder<DepositController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetTopRow(header: MyStrings.depositInfo),
            BottomSheetContainer(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BottomSheetColumn(
                          header: MyStrings.paymentMethod,
                          body: controller.depositList[index].gateway?.name ?? '',
                        ),
                      ),
                      Expanded(
                        child: BottomSheetColumn(
                          alignmentEnd: true,
                          header: MyStrings.amount,
                          body:
                              '${controller.curSymbol}${AppConverter.formatNumber(controller.depositList[index].amount ?? '')}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BottomSheetColumn(
                          header: MyStrings.depositCharge,
                          body:
                              '${controller.curSymbol}${AppConverter.formatNumber(controller.depositList[index].charge ?? '0')}',
                        ),
                      ),
                      Expanded(
                        child: BottomSheetColumn(
                          alignmentEnd: true,
                          header: MyStrings.payableAmount,
                          body:
                              '${controller.curSymbol}${AppConverter.sum(controller.depositList[index].amount ?? '0', controller.depositList[index].charge ?? '0')}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BottomSheetColumn(
                          header: MyStrings.conversionRate,
                          body:
                              "1 ${controller.currency}"
                              " = ${AppConverter.formatNumber(controller.depositList[index].rate ?? "")} ${controller.depositList[index].methodCurrency}",
                        ),
                      ),
                      Expanded(
                        child: BottomSheetColumn(
                          alignmentEnd: true,
                          header: MyStrings.finalAmount,
                          body:
                              '${controller.curSymbol}${AppConverter.formatNumber(controller.depositList[index].finalAmount ?? '')}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).customBottomSheet(context);
  }
}
