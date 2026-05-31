import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/alert-dialog/custom_alert_dialog.dart';
import '../../../components/image/my_asset_widget.dart' show MyAssetImageWidget;
import '../../../components/text/default_text.dart';
import '../../all_contact/widgets/upload_csv_dialogue.dart';

class UserProfileBanner extends StatelessWidget {
  final Widget? trailingWidget;
  final String title, subTitle;
  final bool isBackButton;
  final bool isUpload;
  const UserProfileBanner({
    super.key,
    this.trailingWidget,
    required this.title,
    required this.subTitle,
    this.isBackButton = false,
    this.isUpload = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isBackButton
            ? InkWell(
                onTap: () {
                  Get.back();
                },
                child: MyAssetImageWidget(
                  isSvg: true,
                  boxFit: BoxFit.scaleDown,
                  height: 20.h,
                  width: 20.w,
                  assetPath: MyImages.arrowBack,
                ),
              )
            : SizedBox.shrink(),
        isBackButton ? spaceSide(Dimensions.space12.w) : SizedBox.shrink(),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                text: title,
                textStyle: MyTextStyle.heading20W700().copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
              ),
              DefaultText(
                text: subTitle.tr,
                textStyle: MyTextStyle.subHeading16W400().copyWith(fontSize: 14, color: MyColor.appBarSmallText),
                maxLines: 1,
              ),
            ],
          ),
        ),
        spaceSide(Dimensions.space8.w),
        if (trailingWidget != null) ...[
          isUpload
              ? Material(
                  color: MyColor.white,
                  borderRadius: BorderRadius.circular(Dimensions.space50.r),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.space50.r),

                    onTap: () {
                      CustomAlertDialog(
                        verticalPadding: 0,
                        isHorizontalPadding: false,
                        child: UploadCsvDialogue(),
                      ).customAlertDialog(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      height: Dimensions.space44.w,
                      width: Dimensions.space44.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.space50.r),
                        color: MyColor.getPrimaryColor(),
                      ),
                      child: Icon(Icons.file_upload_outlined, color: MyColor.white, size: 25.sp),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          trailingWidget!,
        ] else ...[
          SizedBox.shrink(),
        ],
      ],
    );
  }
}
