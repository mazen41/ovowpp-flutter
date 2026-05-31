import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/global/widgets/country_bottom_sheet.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/controller/manage_agent/add_new_agent_controller.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/repo/manage_agent/add_new_agent_repo.dart';
import 'package:ovowpp/environment.dart';

class AddNewAgentScreen extends StatefulWidget {
  const AddNewAgentScreen({super.key});

  @override
  State<AddNewAgentScreen> createState() => AddNewAgentScreenState();
}

class AddNewAgentScreenState extends State<AddNewAgentScreen> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    Get.put(AddNewAgentRepo());
    final controller = Get.put(AddNewAgentController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadAgentInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<AddNewAgentController>(
      builder: (controller) => AnnotatedRegionWidget(
        child: Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(title: MyStrings.addAgent.tr, bgColor: MyColor.white, elevation: 0),

          body: controller.isLoading
              ? const CustomLoader()
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: LabelTextField(
                                  isRequired: true,
                                  controller: controller.firstNameController,
                                  labelText: MyStrings.firstName.tr,
                                  hintText: MyStrings.enterYourFirstName.tr,
                                  onChanged: (value) {},
                                  // focusNode: controller.emailFocusNode,
                                  // nextFocus: controller.passwordFocusNode,
                                  textInputType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  radius: Dimensions.largeRadius,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              spaceSide(10.w),
                              Expanded(
                                child: LabelTextField(
                                  isRequired: true,
                                  controller: controller.lastNameController,
                                  labelText: MyStrings.lastName.tr,
                                  hintText: MyStrings.enterYourLastName.tr,
                                  onChanged: (value) {},
                                  textInputType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  radius: Dimensions.largeRadius,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          spaceDown(Dimensions.space15.h),
                          LabelTextField(
                            isRequired: true,
                            controller: controller.userNameController,
                            labelText: MyStrings.username.tr,
                            hintText: MyStrings.username.tr,
                            onChanged: (value) {},
                            textInputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
                            radius: Dimensions.largeRadius,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return MyStrings.fieldErrorMsg.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          spaceDown(Dimensions.space15.h),
                          LabelTextField(
                            isRequired: true,
                            controller: controller.emailController,
                            labelText: MyStrings.email.tr,
                            hintText: MyStrings.email.tr,
                            onChanged: (value) {},
                            textInputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
                            radius: Dimensions.largeRadius,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return MyStrings.fieldErrorMsg.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          spaceDown(Dimensions.space15.h),
                          LabelTextField(
                            isRequired: true,
                            onChanged: (v) {},
                            labelText: (MyStrings.phoneNo).replaceAll('.', '').tr,
                            // hintText: MyStrings.enterYourPhoneNumber,
                            controller: controller.mobileNoController,
                            focusNode: controller.mobileNoFocusNode,
                            textInputType: TextInputType.phone,
                            inputAction: TextInputAction.next,
                            prefixIcon: SizedBox(
                              width: 100,
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
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
                                                (controller.countryData?.countryCode ?? Environment.defaultCountryCode)
                                                    .toLowerCase(),
                                              ),
                                              height: Dimensions.space25,
                                              width: Dimensions.space40,
                                            ),
                                            const SizedBox(width: Dimensions.space5),
                                            Text(
                                              "+${controller.countryData?.dialCode ?? ''}",
                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                color: MyColor.getBodyTextColor(),
                                              ),
                                            ),
                                            const SizedBox(width: Dimensions.space3),
                                            Icon(Icons.arrow_drop_down_rounded, color: MyColor.getAccent1Color()),
                                            Container(
                                              width: 2,
                                              height: Dimensions.space12,
                                              color: MyColor.getBorderColor(),
                                            ),
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
                          spaceDown(Dimensions.space15.h),
                          Row(
                            children: [
                              Expanded(
                                child: LabelTextField(
                                  isRequired: true,
                                  controller: controller.cityController,
                                  labelText: MyStrings.city.tr,
                                  hintText: MyStrings.city.tr,
                                  onChanged: (value) {},
                                  textInputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  radius: Dimensions.largeRadius,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              spaceSide(Dimensions.space10),
                              Expanded(
                                child: LabelTextField(
                                  isRequired: true,
                                  controller: controller.stateController,
                                  labelText: MyStrings.state.tr,
                                  hintText: MyStrings.state.tr,
                                  onChanged: (value) {},
                                  textInputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  radius: Dimensions.largeRadius,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          spaceDown(Dimensions.space15.h),
                          Row(
                            children: [
                              Expanded(
                                child: LabelTextField(
                                  isRequired: true,
                                  controller: controller.zipCodeController,
                                  labelText: MyStrings.zipCode.tr,
                                  hintText: MyStrings.zipCode.tr,
                                  onChanged: (value) {},
                                  textInputType: TextInputType.number,
                                  inputAction: TextInputAction.next,
                                  radius: Dimensions.largeRadius,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              spaceSide(Dimensions.space10),
                              Expanded(
                                child: LabelTextField(
                                  isRequired: true,
                                  controller: controller.addressController,
                                  labelText: MyStrings.address.tr,
                                  hintText: MyStrings.address.tr,
                                  onChanged: (value) {},
                                  textInputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  radius: Dimensions.largeRadius,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          spaceDown(Dimensions.space30.h),
                          CustomElevatedBtn(
                            isLoading: controller.isUpdateAgentLoading,
                            text: MyStrings.saveAgent.tr,
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                controller.addAgent();
                              }
                            },
                          ),
                          spaceDown(Dimensions.space50),
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
