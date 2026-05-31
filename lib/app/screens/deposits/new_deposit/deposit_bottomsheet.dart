import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/controller/deposit/add_new_deposit_controller.dart';
import 'package:ovowpp/app/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:ovowpp/app/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:ovowpp/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovowpp/app/components/card/bottom_sheet_card.dart';

class DepositBottomsheet {
  static void deposittBottomSheet(BuildContext context, AddNewDepositController controller) {
    ThemeData theme = Theme.of(context);
    CustomBottomSheetPlus(
      isDismissable: false,
      enableDrag: true,
      bgColor: Colors.grey,
      barrierColor: Colors.grey.withValues(alpha: 0.1),
      isNeedPadding: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          if (controller.methodList.isEmpty) {
            controller.methodList = controller.methods;
          }
          return Container(
            height: MediaQuery.of(context).size.height * .6,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: MyUtils.getShadow(),
            ),
            child: Column(
              children: [
                const Stack(
                  children: [
                    BottomSheetBar(),
                    Align(alignment: Alignment.centerRight, child: BottomSheetCloseButton()),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.builder(
                    itemCount: controller.methodList.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (controller.methodList[index].id != -1) {
                            controller.selectedPaymentMethodController.text = controller.methodList[index].name ?? '';
                            controller.setPaymentMethod(controller.methodList[index]);
                          }
                          Navigator.pop(context);
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        child: controller.methodList[index].id == -1
                            ? const SizedBox.shrink()
                            : BottomSheetCard(
                                bottomSpace: Dimensions.space10,
                                padding: 12,
                                bgColor: theme.cardColor,
                                boxShadow: const [],
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${controller.methodList[index].name}',
                                        style: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(end: Dimensions.space10),
                                      child: MyNetworkImageWidget(
                                        imageUrl:
                                            ("${controller.imagePath}/${controller.methodList[index].method?.image}"),
                                        height: Dimensions.space30,
                                        width: Dimensions.space30,
                                        boxFit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).show(context);
  }
}
