import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/contact/widgets/contact_details_item.dart';
import 'package:ovowpp/app/screens/contact/widgets/recently_activiry_item.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import '../../../core/utils/text_style.dart';
import '../../../core/utils/util_exporter.dart';
import '../../../data/controller/all_contacts/all_contact_controller.dart';
import '../../components/avatar/alphabet_avatar.dart';
import '../../components/buttons/custom_elevated_button.dart';

class ContactDetailsScreen extends StatefulWidget {
  const ContactDetailsScreen({super.key});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    final Contact item = arguments['contact'];
    final String imagePath = arguments['imagePath'];
    return GetBuilder<AllContactController>(
      builder: (controller) {
        return AnnotatedRegionWidget(
          top: true,
          child: Scaffold(
            backgroundColor: MyColor.white,
            appBar: CustomAppBar(title: MyStrings.contactDetails.tr, elevation: 0, bgColor: Colors.white),
            body: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.image?.isNotEmpty ?? false) ...{
                        Image.network('$imagePath/${item.image}'),
                      } else ...{
                        AlphabetAvatar(firstname: item.firstname ?? "", lastName: item.lastname ?? ""),
                      },
                      spaceDown(Dimensions.space8.h),
                      DefaultText(
                        text: "${item.firstname ?? ""} ${item.lastname ?? ""}",
                        textStyle: MyTextStyle.heading16W600UseTextColor(fontFamily: 'Nunito'),
                      ),
                      DefaultText(text: ".....Here a box....."),
                      DefaultText(
                        text: "${MyStrings.lastActive.tr} 2h ago",
                        textStyle: MyTextStyle.subHeading12W400().copyWith(fontSize: 14.sp),
                      ),
                      spaceDown(Dimensions.space34.h),
                      ContactDetailsItem(
                        icon: MyImages.contactDetailsPhone,
                        title: MyStrings.phoneNumber.tr,
                        phoneNumber: "+${item.mobileCode ?? ""}${item.mobile ?? ""}",
                      ),
                      spaceDown(Dimensions.space12.h),
                      ContactDetailsItem(
                        icon: MyImages.contactDetailsEmail,
                        title: MyStrings.email.tr,
                        phoneNumber: "+${item.mobileCode ?? ""}${item.mobile ?? ""}",
                      ),
                      spaceDown(Dimensions.space12.h),
                      ContactDetailsItem(
                        icon: MyImages.contactDetailsNotes,
                        title: MyStrings.notes.tr,
                        phoneNumber: "+${item.mobileCode ?? ""}${item.mobile ?? ""}",
                      ),
                      spaceDown(Dimensions.space28.h),
                      CustomElevatedBtn(
                        text: MyStrings.sendMessages.tr,
                        onTap: () {
                          controller.contactId = item.id.toString();
                          controller.createConversation();
                        },
                      ),
                      spaceDown(Dimensions.space12.h),
                      CustomElevatedBtn(
                        text: MyStrings.viewCampaigns,
                        onTap: () {},
                        bgColor: MyColor.cancelElevatedBtnBgColor,
                      ),
                      spaceDown(Dimensions.space23.h),
                      Align(
                        alignment: Alignment.topLeft,
                        child: DefaultText(
                          text: MyStrings.recentActivity.tr,
                          textStyle: MyTextStyle.subHeading12W400().copyWith(
                            fontSize: 14.sp,
                            color: MyColor.recentActivityTextColor,
                          ),
                        ),
                      ),
                      RecentlyActivityItem(
                        icon: MyImages.messageIcon,
                        text: MyStrings.sendWelcomeMessage.tr,
                        subText: '2h ago',
                      ),
                      RecentlyActivityItem(
                        icon: MyImages.planStatus,
                        iconColor: MyColor.recentlyActivityIconColor,
                        text: MyStrings.addedToSummerSaleCampaign.tr,
                        subText: '2d ago',
                      ),
                      RecentlyActivityItem(
                        icon: MyImages.messageIcon,
                        text: MyStrings.receivedInquiry.tr,
                        subText: '3d ago',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
