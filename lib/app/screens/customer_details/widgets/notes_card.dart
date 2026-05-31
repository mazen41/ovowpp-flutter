import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/alert-dialog/custom_alert_dialog.dart';
import 'package:ovowpp/app/components/alert-dialog/delete_dialogue.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/core/helper/date_converter.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/customer_details/customer_details_controller.dart';

class NotesCard extends StatelessWidget {
  final int index;
  const NotesCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<CustomerDetailsController>(
      builder: (controller) => Container(
        margin: EdgeInsets.only(bottom: Dimensions.space10),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.space8),
          color: MyColor.getCardBackgroundColor(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    controller.notes[index].note ?? "",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: MyColor.getHeadingTextColor(),
                    ),
                  ),
                ),
                controller.deletingIndex == index
                    ? CustomLoader(loaderColor: MyColor.getPrimaryColor())
                    : GestureDetector(
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            return CustomAlertDialog(
                              verticalPadding: 0,
                              isHorizontalPadding: true,
                              child: GetBuilder<CustomerDetailsController>(
                                builder: (controller) {
                                  return DeleteDialogue(
                                    isLoading: controller.deletingIndex == index,
                                    onTap: () {
                                      controller.deleteNote(index, controller.notes[index].id ?? "");
                                    },
                                  );
                                },
                              ),
                            ).customAlertDialog(context);
                          });
                        },
                        child: MyAssetImageWidget(
                          assetPath: MyImages.delete,
                          isSvg: true,
                          height: Dimensions.space16.h,
                          width: Dimensions.space16.h,
                        ),
                      ),
              ],
            ),
            spaceDown(Dimensions.space4.h),
            controller.conversation?.notes?[index].updatedAt != null
                ? Text(
                    DateConverter.convertUtcToLocalTime(controller.conversation?.notes?[index].createdAt ?? ""),
                    style: theme.textTheme.labelMedium,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
