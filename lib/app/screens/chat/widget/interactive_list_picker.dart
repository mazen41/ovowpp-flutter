import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';

class InteractiveListPicker extends StatelessWidget {
  const InteractiveListPicker({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InteractiveListPicker(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (controller) {
        final lists = controller.interactiveLists;
        return Container(
          decoration: BoxDecoration(
            color: MyColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: MyColor.borderColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: Row(
                  children: [
                    Icon(Icons.format_list_bulleted_rounded,
                        color: MyColor.getPrimaryColor(), size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Interactive List',
                      style: MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: Get.back,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: MyColor.borderColor),
              controller.loadingTemplates
                  ? Padding(
                      padding: EdgeInsets.all(32.w),
                      child: const CustomLoader(),
                    )
                  : lists.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(32.w),
                          child: Text(
                            'No interactive lists found.',
                            style: MyTextStyle.subHeading14W400()
                                .copyWith(color: MyColor.getBodyTextColor()),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 360.h),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            itemCount: lists.length,
                            separatorBuilder: (_, __) => Divider(height: 1, color: MyColor.borderColor),
                            itemBuilder: (context, i) {
                              final item = lists[i];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 18.r,
                                  backgroundColor: MyColor.getPrimaryColor().withAlpha(30),
                                  child: Icon(Icons.format_list_bulleted_rounded,
                                      color: MyColor.getPrimaryColor(), size: 18.sp),
                                ),
                                title: Text(
                                  item['title'] ?? item['name'] ?? 'List',
                                  style: MyTextStyle.subHeading14W500()
                                      .copyWith(color: MyColor.usdTextColor),
                                ),
                                trailing: controller.sendingMessage
                                    ? const CustomLoader(loaderSize: 5)
                                    : Icon(Icons.send_rounded,
                                        color: MyColor.getPrimaryColor(), size: 20.sp),
                                onTap: () async {
                                  Get.back();
                                  await controller.sendInteractiveListMessage(
                                      item['id'].toString());
                                },
                              );
                            },
                          ),
                        ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16.h),
            ],
          ),
        );
      },
    );
  }
}
