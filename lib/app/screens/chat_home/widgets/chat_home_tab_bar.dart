import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/shimmer/home_shimmer.dart';
import '../../../../core/helper/date_converter.dart';
import '../../../../core/route/route.dart';
import '../../../../core/utils/app_permission.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/home/home_controller.dart';
import '../../../components/avatar/alphabet_avatar.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/image/my_network_image_widget.dart';
import '../../../components/no_data.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';
import '../../../components/text/default_text.dart';
import '../../contact/widgets/contact_item.dart';

class MySliverTabBarView extends StatelessWidget {
  final int index;

  const MySliverTabBarView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        if (controller.newChatLoader) {
          return HomeShimmer();
        }
        if (controller.newChatData.isEmpty) {
          return NoDataWidget();
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              final metrics = notification.metrics;

              if (metrics.pixels >= metrics.maxScrollExtent - 100) {
                if (!controller.isLoadingMore && controller.hasNext()) {
                  controller.newChatMethod(
                    loadMore: true,
                    status: controller.status,
                    searchQuery: controller.searchQuery,
                  );
                }
              }
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var item = controller.newChatData[index];
                  final tags = controller.newChatData[index].contact?.tags;
                  String? tag = (tags != null && tags.isNotEmpty) ? tags.first.name : null;

                  String previewText = '';
                  IconData? previewIcon;
                  final lastMsg = item.lastMessage;
                  if (lastMsg != null) {
                    final mediaType = lastMsg.mediaType?.toLowerCase() ?? '';
                    final msgType = lastMsg.messageType?.toString() ?? '';
                    final hasTemplate =
                        lastMsg.templateId != null && lastMsg.templateId!.isNotEmpty && lastMsg.templateId != '0';

                    // Keep special-message previews consistent with ChatScreen. These
                    // labels must take precedence over the raw message payload.
                    if (hasTemplate) {
                      previewText = AppStatus.template;
                      previewIcon = Icons.description_outlined;
                    } else if (msgType == AppStatus.URL_TYPE_MESSAGE) {
                      previewText = AppStatus.ctaUrl;
                      previewIcon = Icons.link_rounded;
                    } else if (msgType == AppStatus.LOCATION_TYPE_MESSAGE) {
                      previewText = AppStatus.location;
                      previewIcon = Icons.location_on_outlined;
                    } else if (msgType == AppStatus.LIST_TYPE_MESSAGE) {
                      previewText = AppStatus.listMessage;
                      previewIcon = Icons.format_list_bulleted_rounded;
                    } else if (mediaType == 'image' || msgType == AppStatus.IMAGE_TYPE_MESSAGE) {
                      previewText = MyStrings.sentAnImage.tr;
                      previewIcon = Icons.image_outlined;
                    } else if (mediaType == 'audio' || msgType == AppStatus.AUDIO_TYPE_MESSAGE) {
                      previewText = MyStrings.sentAnAudio.tr;
                      previewIcon = Icons.mic_outlined;
                    } else if (mediaType == 'video' || msgType == AppStatus.VIDEO_TYPE_MESSAGE) {
                      previewText = MyStrings.sentAVideo.tr;
                      previewIcon = Icons.videocam_outlined;
                    } else if (mediaType == 'document' || msgType == AppStatus.DOCUMENT_TYPE_MESSAGE) {
                      previewText = MyStrings.sentADocument.tr;
                      previewIcon = Icons.insert_drive_file_outlined;
                    } else if ((lastMsg.message ?? '').isNotEmpty) {
                      previewText = lastMsg.message!;
                    }
                  }

                  return InkWell(
                    onTap: () {
                      // 1️⃣ Permission check
                      if (!MyUtils.checkPermission(AppPermission.sendMessage)) {
                        CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                        return;
                      }

                      // 2️⃣ Data validation
                      if (item.id == null) {
                        CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
                        return;
                      }

                      // 3️⃣ Happy path
                      isContactFromChat = false;
                      controller.currentChatIndex = index;

                      Get.toNamed(RouteHelper.chatScreen, arguments: [item.id.toString(), item.createdAt.toString()]);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //// PROFILE IMAGE
                          Stack(
                            children: [
                              item.contact?.imageSrc != null
                                  ? Padding(
                                      padding: EdgeInsets.only(top: Dimensions.space5),
                                      child: MyNetworkImageWidget(
                                        boxFit: BoxFit.fill,
                                        height: 54.h,
                                        width: 54.w,
                                        radius: 100,
                                        imageUrl: item.contact?.imageSrc ?? '',
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(top: Dimensions.space5),
                                      child: AlphabetAvatar(
                                        firstname: item.contact?.firstname ?? "",
                                        lastName: item.contact?.lastname ?? "",
                                        size: 54.w,
                                      ),
                                    ),
                              (int.tryParse(item.unseenMessages ?? "0") ?? 0) > 0
                                  ? Positioned(
                                      top: 1,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(Dimensions.space4.w),
                                        decoration: BoxDecoration(
                                          color: MyColor.getPrimaryColor(),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          (int.tryParse(item.unseenMessages ?? "0") ?? 0) > 99
                                              ? "99+"
                                              : (item.unseenMessages ?? "0"),
                                          style: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(
                                            fontSize: Dimensions.space12.sp,
                                            color: MyColor.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),

                          //// PROFILE IMAGE END
                          spaceSide(Dimensions.space16.w),
                          // NAME AND LAST MESSAGE
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Name Text gets flexible space
                                    Expanded(
                                      child: DefaultText(
                                        text: "${item.contact?.firstname ?? ""} ${item.contact?.lastname ?? ""}",
                                        textStyle: MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
                                        textOverFlow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),

                                    // Time Text keeps its natural size
                                    if (item.lastMessageAt != null)
                                      DefaultText(
                                        text: DateConverter.convertUtcToLocalTime(item.lastMessageAt.toString()),
                                        textStyle: MyTextStyle.subHeading12W600().copyWith(
                                          color: MyColor.getBodyTextColor(),
                                        ),
                                        maxLines: 1,
                                      ),
                                  ],
                                ),

                                if (previewText.isNotEmpty) ...[
                                  spaceDown(Dimensions.space4.h),
                                  Row(
                                    children: [
                                      if (previewIcon != null) ...[
                                        Icon(
                                          previewIcon,
                                          size: Dimensions.space16.sp,
                                          color: MyColor.planStatusTextColor,
                                        ),
                                        spaceSide(Dimensions.space6.w),
                                      ],
                                      Expanded(
                                        child: DefaultText(
                                          text: previewText,
                                          textStyle: MyTextStyle.subHeading14W400().copyWith(
                                            color: MyColor.planStatusTextColor,
                                          ),
                                          textOverFlow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  spaceDown(Dimensions.space6.h),
                                ],
                                spaceDown(Dimensions.space6.h),
                                Row(
                                  children: [
                                    if (controller.tabController.index == 0) ...[
                                      if ((int.tryParse(item.status.toString()) == 1) ||
                                          (int.tryParse(item.status.toString()) == 2) ||
                                          (int.tryParse(item.status.toString()) == 3)) ...[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.space8.w,
                                            vertical: Dimensions.space4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (int.tryParse(item.status.toString()) == 1)
                                                ? MyColor.errorColor.withAlpha(MyColor.getAlpha(10))
                                                : (int.tryParse(item.status.toString()) == 2)
                                                ? MyColor.openColor.withAlpha(MyColor.getAlpha(10))
                                                : MyColor.campaignsRunning.withAlpha(MyColor.getAlpha(10)),
                                            borderRadius: BorderRadius.circular(Dimensions.space10.r),
                                          ),
                                          child: DefaultText(
                                            text: (int.tryParse(item.status.toString()) == 1)
                                                ? MyStrings.done.tr
                                                : (int.tryParse(item.status.toString()) == 2)
                                                ? MyStrings.pending.tr
                                                : (int.tryParse(item.status.toString()) == 3)
                                                ? MyStrings.important.tr
                                                : '',
                                            textStyle: MyTextStyle.subHeading14W600().copyWith(
                                              color: (int.tryParse(item.status.toString()) == 1)
                                                  ? MyColor.errorColor
                                                  : (int.tryParse(item.status.toString()) == 2)
                                                  ? MyColor.openColor
                                                  : MyColor.campaignsRunning,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],

                                      spaceSide(Dimensions.space8.w),
                                      (tag?.isNotEmpty == true)
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions.space8.w,
                                                vertical: Dimensions.space4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: MyColor.splashScreenBackground,
                                                borderRadius: BorderRadius.circular(Dimensions.space10.r),
                                              ),
                                              child: DefaultText(
                                                text: tag ?? ''.tr,
                                                textStyle: MyTextStyle.subHeading12W600().copyWith(
                                                  color: MyColor.splashTextColor,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: controller.newChatData.length),
              ),
              SliverToBoxAdapter(
                child: controller.isLoadingMore
                    ? CustomLoader(isPagination: true, loaderSize: 50.sp)
                    : SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
