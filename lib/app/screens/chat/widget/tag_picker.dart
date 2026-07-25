import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';
import 'package:ovowpp/data/repo/contact_tag/contact_tag_list_repo.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/services/api_service.dart';

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

  // ── Inline "Create Tag" dialog ────────────────────────────────────────────
  static Future<void> _showCreateTagDialog(
      BuildContext context, ChatController controller) async {
    final nameController = TextEditingController();
    bool saving = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('Create Tag',
              style: MyTextStyle.heading16W600()
                  .copyWith(color: MyColor.getHeadingTextColor())),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Tag name',
              hintStyle: MyTextStyle.subHeading14W400()
                  .copyWith(color: MyColor.getBodyTextColor()),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style:
                      TextStyle(color: MyColor.getBodyTextColor())),
            ),
            TextButton(
              onPressed: saving
                  ? null
                  : () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;
                      setState(() => saving = true);
                      try {
                        final url =
                            '${UrlContainer.baseUrl}${UrlContainer.createContactTagUrl}';
                        final response =
                            await ApiService.postRequest(url, {'name': name});
                        if (response.statusCode == 200 &&
                            response.responseJson['status']
                                    ?.toString()
                                    .toLowerCase() ==
                                'success') {
                          Navigator.pop(ctx);
                          // Reload tags so new one appears immediately
                          await controller.loadTagsForPicker();
                        } else {
                          final msg =
                              (response.responseJson['message'] as List?)
                                      ?.first
                                      ?.toString() ??
                                  'Failed to create tag';
                          ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text(msg)));
                        }
                      } catch (_) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to create tag')));
                      } finally {
                        setState(() => saving = false);
                      }
                    },
              child: saving
                  ? SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: MyColor.getPrimaryColor()),
                    )
                  : Text('Save',
                      style: TextStyle(
                          color: MyColor.getPrimaryColor(),
                          fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
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

              // Header row with "Create Tag" button
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.label_outline_rounded,
                        color: MyColor.getPrimaryColor(), size: 20.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Assign Tag',
                        style: MyTextStyle.heading16W600()
                            .copyWith(color: MyColor.getHeadingTextColor()),
                      ),
                    ),
                    // ── "Create Tag" button ─────────────────────────────
                    TextButton.icon(
                      onPressed: () =>
                          _showCreateTagDialog(context, controller),
                      icon: Icon(Icons.add_rounded,
                          size: 18.sp, color: MyColor.getPrimaryColor()),
                      label: Text(
                        'Create Tag',
                        style: MyTextStyle.subHeading14W400().copyWith(
                            color: MyColor.getPrimaryColor(),
                            fontWeight: FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8.w)),
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
                  child: Column(
                    children: [
                      Text(
                        'No tags yet. Create your first tag.',
                        textAlign: TextAlign.center,
                        style: MyTextStyle.subHeading14W400()
                            .copyWith(color: MyColor.getBodyTextColor()),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _showCreateTagDialog(context, controller),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Create Tag'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.getPrimaryColor(),
                            foregroundColor: MyColor.white),
                      ),
                    ],
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
                                final newTagId =
                                    isSelected ? '' : tagId;
                                await controller.assignTag(newTagId);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
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
                        trailing: controller.assigningTag && isSelected
                            ? SizedBox(
                                width: 18.w,
                                height: 18.h,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: MyColor.getPrimaryColor()),
                              )
                            : isSelected
                                ? Icon(Icons.check_circle_rounded,
                                    color: MyColor.getPrimaryColor(),
                                    size: 20.sp)
                                : null,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                      );
                    },
                  ),
                ),

              SizedBox(
                  height:
                      MediaQuery.of(context).viewInsets.bottom + 16.h),
            ],
          ),
        );
      },
    );
  }
}
