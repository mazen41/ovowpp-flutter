import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/divider/line.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import '../../../../core/helper/date_converter.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/util.dart';
import '../../../../data/controller/customer_details/customer_details_controller.dart';
import '../../../components/alert-dialog/custom_alert_dialog.dart';
import '../../../components/alert-dialog/delete_dialogue.dart' show DeleteDialogue;
import '../../../components/bottom-sheet/bottom_sheet_close_button.dart';
import '../../../components/bottom-sheet/custom_bottom_sheet_plus.dart';
import '../../../components/buttons/custom_elevated_button.dart';
import '../../../components/text-field/custom_text_field.dart';

class NotesBottomSheet {
  static void viewNotesBottomSheet(BuildContext context, CustomerDetailsController controller) {
    //  controller.filteredNotes.clear();
    controller.filteredNotes = controller.notes;
    CustomBottomSheetPlus(
      isDismissable: false,
      enableDrag: true,
      bgColor: MyColor.white,
      barrierColor: Colors.white.withValues(alpha: 0.1),
      isNeedPadding: false,
      child: GetBuilder<CustomerDetailsController>(
        builder: (controller) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: Dimensions.space4.w),
            height: MediaQuery.of(context).size.height * .8,
            padding: EdgeInsets.only(
              top: Dimensions.space4.h,
              left: Dimensions.space20.w,
              right: Dimensions.space20.w,
              bottom: Dimensions.space20.w,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: MyColor.dashboardCardBorder),
              color: MyColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.space20.r),
                topRight: Radius.circular(20),
              ),
              boxShadow: MyUtils.getShadow(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceDown(Dimensions.space8.h),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        DefaultText(
                          text: MyStrings.notes.tr,
                          textStyle: MyTextStyle.heading20W700().copyWith(fontWeight: FontWeight.w600),
                        ),
                        BottomSheetCloseButton(
                          iconColor: MyColor.errorColor,
                          bgColor: MyColor.errorColor.withAlpha(MyColor.getAlpha(10)),
                        ),
                      ],
                    ),
                  ],
                ),
                spaceDown(Dimensions.space12.h),

                LabelTextField(
                  hintText: MyStrings.search.tr,
                  hideLabel: true,
                  onChanged: (value) {
                    controller.searchNotes(value);
                  },
                ),
                spaceDown(Dimensions.space12.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = controller.filteredNotes[index];
                      bool isLastIndex = index == controller.filteredNotes.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.space8.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DefaultText(
                                      text: note.note ?? "",
                                      textStyle: MyTextStyle.heading20W700().copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        color: MyColor.headingText,
                                      ),
                                    ),

                                    if (note.updatedAt != null)
                                      DefaultText(
                                        text: DateConverter.convertUtcToLocalTime(note.createdAt ?? ""),
                                        textStyle: MyTextStyle.subHeading12W600(),
                                      ),
                                  ],
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(Dimensions.space4),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(Dimensions.space4),
                                    onTap: () {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        return CustomAlertDialog(
                                          verticalPadding: 0,
                                          isHorizontalPadding: true,
                                          child: GetBuilder<CustomerDetailsController>(
                                            builder: (context) {
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
                                    child: Icon(Icons.delete, size: 20, color: MyColor.errorColor),
                                  ),
                                ),
                              ],
                            ),
                            spaceDown(Dimensions.space6.h),
                            isLastIndex ? SizedBox() : Line(),
                          ],
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

  static void addNotesBottomSheet(BuildContext context, CustomerDetailsController controller) {
    CustomBottomSheetPlus(
      isDismissable: false,
      enableDrag: true,
      bgColor: MyColor.white,
      barrierColor: Colors.white.withValues(alpha: 0.1),
      isNeedPadding: false,
      child: GetBuilder<CustomerDetailsController>(
        builder: (controller) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: Dimensions.space4.w),
            height: MediaQuery.of(context).size.height * .5,
            padding: EdgeInsets.symmetric(vertical: Dimensions.space20.h, horizontal: Dimensions.space20.w),
            decoration: BoxDecoration(
              border: Border.all(color: MyColor.dashboardCardBorder),
              color: MyColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.space20.r),
                topRight: Radius.circular(20),
              ),
              boxShadow: MyUtils.getShadow(),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          DefaultText(
                            text: MyStrings.addNote.tr,
                            textStyle: MyTextStyle.heading20W700().copyWith(fontWeight: FontWeight.w600),
                          ),
                          BottomSheetCloseButton(
                            iconColor: MyColor.errorColor,
                            bgColor: MyColor.errorColor.withAlpha(MyColor.getAlpha(10)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  spaceDown(Dimensions.space40.h),
                  CustomTextField(
                    labelText: MyStrings.addNote.tr,
                    needOutlineBorder: true,
                    fillColor: MyColor.getCardBackgroundColor(),
                    hintText: MyStrings.writeDescription.tr,
                    isPassword: false,
                    controller: controller.noteController,
                    maxLines: 4,
                    isShowSuffixIcon: false,
                    onSuffixTap: () {},
                    onChanged: (value) {},
                  ),
                  spaceDown(Dimensions.space25.h),
                  CustomElevatedBtn(
                    isLoading: controller.noteLoading,
                    text: MyStrings.add.tr,
                    onTap: () {
                      controller.addNote();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).show(context);
  }
}
