import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/shimmer/customer_details_shimmer.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/chat/chat_person_details/notes_bottom_sheet.dart';
import 'package:ovowpp/app/screens/contact/widgets/contact_item.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/data/controller/customer_details/customer_details_controller.dart';
import 'package:ovowpp/data/controller/home/home_controller.dart';
import 'package:ovowpp/data/repo/customer_detais/customer_details_repo.dart';
import 'package:ovowpp/data/repo/home/home_repo.dart';
import '../../../components/text-field/custom_drop_down_button_with_text_field2.dart';
import '../widget/chat_person_details_item.dart';

class ChatPersonDetailsScreen extends StatefulWidget {
  const ChatPersonDetailsScreen({super.key});

  @override
  State<ChatPersonDetailsScreen> createState() => _ChatPersonDetailsScreenState();
}

class _ChatPersonDetailsScreenState extends State<ChatPersonDetailsScreen> with SingleTickerProviderStateMixin {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(CustomerDetailsRepo());
    final controller = Get.put(CustomerDetailsController(repo: Get.find()));

    super.initState();
    controller.tabController = TabController(length: 2, vsync: this);
    controller.id = Get.arguments[0];
    controller.tabController.addListener(() {
      if (controller.tabController.indexIsChanging) {
        controller.changeIndicator();
      } else if (controller.tabController.index != controller.tabController.previousIndex) {
        controller.changeIndicator();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.customerDetailsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<CustomerDetailsController>(
      builder: (controller) => AnnotatedRegionWidget(
        child: Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(title: MyStrings.customerDetails.tr, bgColor: MyColor.white, elevation: 0),
          body: controller.isLoading
              ? const CustomerDetailsShimmer()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spaceDown(Dimensions.space25.h),
                      Row(
                        children: [
                          controller.contact?.imageSrc != null
                              ? CircleAvatar(
                                  maxRadius: Dimensions.space35.r,
                                  backgroundImage: NetworkImage(controller.contact?.imageSrc ?? ''),
                                )
                              : AlphabetAvatar(
                                  size: Dimensions.space40.r,
                                  firstname: controller.contact?.firstname ?? "",
                                  lastName: controller.contact?.lastname ?? '',
                                ),

                          spaceSide(Dimensions.space16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DefaultText(
                                        text:
                                            "${controller.contact?.firstname ?? ""} ${controller.contact?.lastname ?? ""}",
                                        textStyle: MyTextStyle.heading16W500UseTextColor().copyWith(
                                          fontSize: Dimensions.space18.sp,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    spaceSide(Dimensions.space8.w),
                                    InkWell(
                                      onTap: () {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (isContactFromChat) {
                                            Get.put(HomeRepo());
                                            Get.put(HomeController(homeRepo: Get.find()));
                                          }
                                          final homeController = Get.find<HomeController>();
                                          Get.toNamed(
                                            RouteHelper.customerAccountScreen,
                                            arguments: [
                                              controller.imagePath,
                                              controller.contact,
                                              true,
                                              homeController.currentChatIndex,
                                              true,
                                            ],
                                          )?.then((_) {
                                            controller.customerDetailsData(forceLoad: false);
                                          });
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          MyAssetImageWidget(
                                            assetPath: MyImages.edit,
                                            isSvg: true,
                                            height: Dimensions.space16.h,
                                            width: Dimensions.space16.h,
                                          ),
                                          spaceSide(Dimensions.space4),
                                          Text(MyStrings.edit.tr, style: theme.textTheme.titleSmall),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                spaceDown(Dimensions.space4.h),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: controller.contact?.mobile ?? "")).then((_) {
                                      CustomSnackBar.success(successList: [MyStrings.contactCopiedToClipBoard.tr]);
                                    });
                                  },
                                  child: DefaultText(
                                    text: "+${controller.contact?.mobileCode}${controller.contact?.mobile ?? ""}",
                                    textStyle: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(fontSize: 15.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      spaceDown(Dimensions.space16.h),
                      ChatPersonDetailsItem(
                        iconPath: MyImages.editIcon.tr,
                        text: MyStrings.addNote.tr,
                        isLine: false,
                        onTap: () {
                          NotesBottomSheet.addNotesBottomSheet(context, controller);
                        },
                      ),
                      spaceDown(Dimensions.space8.h),
                      ChatPersonDetailsItem(
                        iconPath: MyImages.viewNotes,
                        text: MyStrings.viewNotes.tr,
                        isLine: false,
                        onTap: () {
                          NotesBottomSheet.viewNotesBottomSheet(context, controller);
                        },
                      ),

                      spaceDown(Dimensions.space16.h),

                      DefaultText(
                        text: MyStrings.conversationStatus.tr,
                        textStyle: MyTextStyle.subHeading15W500FieldTitleColor.copyWith(
                          fontSize: 16.sp,
                          color: MyColor.usdTextColor,
                        ),
                      ),
                      spaceDown(Dimensions.space8.h),
                      CustomDropDownTextField2(
                        radius: Dimensions.space10,
                        needLabel: false,
                        labelText: MyStrings.conversationStatus.tr,
                        selectedValue: controller.conversation?.status == "2"
                            ? "Pending"
                            : controller.conversation?.status == "3"
                            ? "Important"
                            : controller.conversation?.status == "1"
                            ? "Done"
                            : "None",
                        onChanged: (v) {
                          controller.changeStatus(
                            v == "Pending"
                                ? "2"
                                : v == "Important"
                                ? "3"
                                : v == "Done"
                                ? "1"
                                : "",
                          );
                        },
                        items: controller.status.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              (value.toString()).tr,
                              style: theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
