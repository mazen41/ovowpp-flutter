import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';

class TagPicker extends StatelessWidget {
  const TagPicker({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TagPicker(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (controller) {
        final tags = controller.availableTags;
        final isLoading = controller.loadingTags;
        final assignedTagId = controller.assignedTagId;

        return Container(
          decoration: BoxDecoration(
            color: MyColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: MyColor.lightBorder,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.label_outline_rounded,
                        color: MyColor.getPrimaryColor(), size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Assign Tag',
                      style: MyTextStyle.heading16W600()
                          .copyWith(color: MyColor.getHeadingTextColor()),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: MyColor.lightBorder),

              // Body
              if (isLoading)
                Padding(
                  padding: EdgeInsets.all(32.h),
                  child: const CustomLoader(),
                )
              else if (tags.isEmpty)
                Padding(
                  padding: EdgeInsets.all(32.h),
                  child: Text(
                    'No tags found. Create tags from the Contact Tags screen first.',
                    textAlign: TextAlign.center,
                    style: MyTextStyle.subHeading14W400()
                        .copyWith(color: MyColor.getBodyTextColor()),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: tags.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: MyColor.lightBorder),
                    itemBuilder: (context, index) {
                      final tag = tags[index];
                      final tagId = tag['id']?.toString() ?? '';
                      final tagName = tag['name']?.toString() ?? '';
                      final isSelected = assignedTagId == tagId;

                      return ListTile(
                        onTap: controller.assigningTag
                            ? null
                            : () async {
                                // Toggle off if already selected
                                final newTagId = isSelected ? '' : tagId;
                                await controller.assignTag(newTagId);
                                if (context.mounted) Navigator.pop(context);
                              },
                        leading: Icon(
                          Icons.label_rounded,
                          color: isSelected
                              ? MyColor.getPrimaryColor()
                              : MyColor.getBodyTextColor(),
                          size: 20.sp,
                        ),
                        title: Text(
                          tagName,
                          style: MyTextStyle.subHeading14W400().copyWith(
                            color: isSelected
                                ? MyColor.getPrimaryColor()
                                : MyColor.getBodyTextColor(),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle_rounded,
                                color: MyColor.getPrimaryColor(), size: 20.sp)
                            : null,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
