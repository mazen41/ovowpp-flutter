import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/text-field/search_text_field.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/app_style.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util.dart';
import '../../../../data/controller/deposit/deposit_history_controller.dart';
import '../../../components/text/label_text.dart';

class DepositHistoryTop extends StatefulWidget {
  const DepositHistoryTop({super.key});

  @override
  State<DepositHistoryTop> createState() => _DepositHistoryTopState();
}

class _DepositHistoryTopState extends State<DepositHistoryTop> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
          color: MyColor.white,
          boxShadow: MyUtils.getBottomSheetShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText(
              text: MyStrings.trxNo.tr,
              textStyle: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(fontSize: 14.sp),
            ),
            spaceDown(Dimensions.space8.h),

            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: Dimensions.space45.h,
                      width: MediaQuery.of(context).size.width,
                      child: SearchTextField(
                        needOutlineBorder: true,
                        controller: controller.searchController,
                        onChanged: (value) {
                          return;
                        },
                        hintText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.space10),
                  InkWell(
                    onTap: () {
                      controller.searchDepositTrx();
                    },
                    child: Container(
                      height: Dimensions.space45.h,
                      width: Dimensions.space45.w,
                      padding: EdgeInsets.all(Dimensions.space4.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: MyColor.getPrimaryColor(),
                      ),
                      child: Icon(Icons.search_outlined, color: MyColor.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
