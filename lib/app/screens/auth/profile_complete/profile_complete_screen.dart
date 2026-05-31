import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/app/screens/global/widgets/country_bottom_sheet.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/account/profile_complete_controller.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/repo/account/profile_repo.dart';
import 'package:ovowpp/data/services/push_notification_service.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/components/will_pop_widget.dart';
import 'package:get/get.dart';
import 'package:ovowpp/environment.dart';
import '../../../../core/utils/my_images.dart';
import '../../../../core/utils/url_container.dart';
import '../../../components/image_bg_widget.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  @override
  void initState() {
    Get.put(ProfileRepo());
    Get.put(ProfileCompleteController(profileRepo: Get.find()));
    Get.put(PushNotificationService());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopWidget(
      nextRoute: '',
      child: ImageBgWidget(
        isAppBar: true,
        customAppBar: CustomAppBar(
          fromAuth: true,
          isShowBackBtn: true,
          title: MyStrings.profileComplete.tr,
          bgColor: Colors.transparent,
        ),
        screen: GetBuilder<ProfileCompleteController>(
          builder: (controller) => Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(MyImages.chatBackground))),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: Dimensions.screenPadding,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.space15),
                    LabelTextField(
                      isRequired: true,
                      labelText: MyStrings.username.tr,
                      hintText: MyStrings.enterYourUsername.tr,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      focusNode: controller.usernameFocusNode,
                      controller: controller.usernameController,
                      nextFocus: controller.mobileNoFocusNode,
                      validator: (value) {
                        if ((value as String).trim().isEmpty) {
                          return MyStrings.kUsernameIsRequired.tr;
                        } else if (value.length < 6) {
                          return MyStrings.kShortUserNameError.tr;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: Dimensions.space25),
                    LabelTextField(
                      onChanged: (v) {},
                      labelText: (MyStrings.phoneNo).replaceAll('.', '').tr,
                      hintText: MyStrings.enterYourPhoneNumber,
                      controller: controller.mobileNoController,
                      focusNode: controller.mobileNoFocusNode,
                      nextFocus: controller.addressFocusNode,
                      textInputType: TextInputType.phone,
                      inputAction: TextInputAction.next,
                      prefixIcon: SizedBox(
                        width: 100,
                        child: FittedBox(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  CountryBottomSheet.countryBottomSheet(
                                    context,
                                    onSelectedData: (Countries data) {
                                      controller.selectACountry(countryDataValue: data);
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: Dimensions.space12),
                                  decoration: BoxDecoration(
                                    color: MyColor.getTransparentColor(),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      MyNetworkImageWidget(
                                        imageUrl: UrlContainer.countryFlagImageLink.replaceAll(
                                          "{countryCode}",
                                          (controller.countryData.countryCode ?? Environment.defaultCountryCode)
                                              .toLowerCase(),
                                        ),
                                        height: Dimensions.space25,
                                        width: Dimensions.space40 + 2,
                                      ),
                                      const SizedBox(width: Dimensions.space5),
                                      Text(
                                        "+${controller.countryData.dialCode ?? ''}",
                                        style: theme.textTheme.labelLarge,
                                      ),
                                      const SizedBox(width: Dimensions.space3),
                                      Icon(Icons.arrow_drop_down_rounded, color: MyColor.getAccent1Color()),
                                      Container(width: 2, height: Dimensions.space12, color: MyColor.getBorderColor()),
                                      const SizedBox(width: Dimensions.space8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      validator: (value) {
                        if ((value as String).trim().isEmpty) {
                          return MyStrings.kPhoneNumberIsRequired.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: Dimensions.space25),
                    LabelTextField(
                      labelText: MyStrings.address,
                      hintText: MyStrings.enterYourAddress,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      focusNode: controller.addressFocusNode,
                      controller: controller.addressController,
                      nextFocus: controller.stateFocusNode,
                      onChanged: (value) {
                        return;
                      },
                    ),
                    const SizedBox(height: Dimensions.space25),
                    LabelTextField(
                      labelText: MyStrings.state,
                      hintText: MyStrings.enterState,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      focusNode: controller.stateFocusNode,
                      controller: controller.stateController,
                      nextFocus: controller.cityFocusNode,
                      onChanged: (value) {
                        return;
                      },
                    ),
                    const SizedBox(height: Dimensions.space25),
                    LabelTextField(
                      labelText: MyStrings.city.tr,
                      hintText: MyStrings.enterCity.tr,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      focusNode: controller.cityFocusNode,
                      controller: controller.cityController,
                      nextFocus: controller.zipCodeFocusNode,
                      onChanged: (value) {
                        return;
                      },
                    ),
                    const SizedBox(height: Dimensions.space25),
                    LabelTextField(
                      labelText: MyStrings.zipCode.tr,
                      hintText: MyStrings.enterZipCode,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      focusNode: controller.zipCodeFocusNode,
                      controller: controller.zipCodeController,
                      onChanged: (value) {
                        return;
                      },
                    ),
                    const SizedBox(height: Dimensions.space35),
                    CustomElevatedBtn(
                      isLoading: controller.submitLoading,
                      text: MyStrings.updateProfile.tr,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          controller.profileCompleteSubmit();
                        }
                      },
                    ),

                    spaceDown(Dimensions.space20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
