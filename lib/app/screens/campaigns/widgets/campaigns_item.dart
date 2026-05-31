import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/model/campaign/campaign_model.dart';
import '../../../../core/helper/date_converter.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/campaigns/campaigns_controller.dart';
import '../../../components/divider/line.dart';
import '../../../components/text/default_text.dart';

class CampaignsItem extends StatelessWidget {
  final CampaignsDatum indexItem;
  final int index;

  const CampaignsItem({super.key, required this.indexItem, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Line(),
            spaceDown(Dimensions.space12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.tabController.index == 0) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.space12.w, vertical: Dimensions.space6.h),
                    decoration: BoxDecoration(
                      color: indexItem.status == "3"
                          ? MyColor.campaignsRunning.withAlpha(MyColor.getAlpha(10))
                          : indexItem.status == "2"
                          ? MyColor.campaignsScheduled.withAlpha(MyColor.getAlpha(10))
                          : MyColor.error.withAlpha(MyColor.getAlpha(10)),
                      borderRadius: BorderRadius.circular(Dimensions.space50.r),
                    ),
                    child: DefaultText(
                      text: indexItem.status == "3"
                          ? MyStrings.statusSchedule.tr
                          : indexItem.status == "2"
                          ? MyStrings.running.tr
                          : MyStrings.completed.tr,
                      textStyle: MyTextStyle.subHeading12W600().copyWith(
                        color: indexItem.status == "3"
                            ? MyColor.campaignsRunning
                            : indexItem.status == "2"
                            ? MyColor.campaignsScheduled
                            : MyColor.error,
                      ),
                    ),
                  ),
                ],
                DefaultText(
                  text: DateConverter.convertIsoToString(indexItem.createdAt ?? ''),
                  textStyle: MyTextStyle.subHeading14W600(),
                ),
              ],
            ),
            spaceDown(Dimensions.space6.h),
            DefaultText(
              text: indexItem.title ?? '',
              textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
            ),
            spaceDown(Dimensions.space6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                itemKeyValue(key: MyStrings.sent.tr, value: indexItem.totalSend ?? 0.toString()),
                itemKeyValue(key: MyStrings.successSpace.tr, value: indexItem.totalSuccess ?? 0.toString()),
                itemKeyValue(key: MyStrings.failed.tr, value: indexItem.totalFailed ?? 0.toString()),
                SizedBox(),
                SizedBox(),
                SizedBox(),
              ],
            ),
            spaceDown(Dimensions.space6.h),
            (indexItem.createdAt != null || (indexItem.createdAt?.isNotEmpty ?? false))
                ? Row(
                    children: [
                      DefaultText(
                        text: MyStrings.schedule.tr,
                        textStyle: MyTextStyle.subHeading14W600FieldTitleColor(),
                      ),
                      DefaultText(
                        text: DateConverter.convertIsoToString(indexItem.sendAt ?? ''),
                        textStyle: MyTextStyle.subHeading14W600FieldTitleColor(),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            spaceDown(Dimensions.space6.h),
            DefaultText(
              text: "${MyStrings.updated.tr} ${DateConverter.convertIsoToString(indexItem.updatedAt ?? '')}",
              textStyle: MyTextStyle.subHeading12W400().copyWith(color: MyColor.updatedTextColor),
            ),
            spaceDown(Dimensions.space12.h),
          ],
        );
      },
    );
  }

  Row itemKeyValue({String? key, String? value}) {
    return Row(
      children: [
        DefaultText(text: key ?? '', textStyle: MyTextStyle.subHeading12W400()),
        DefaultText(
          text: value ?? '',
          textStyle: MyTextStyle.subHeading12W400().copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
