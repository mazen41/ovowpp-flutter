import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/app/components/multiple_select_dropdown.dart';
import 'package:ovowpp/app/components/shimmer/edit_customer_profile_shimmer.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/components/text/label_text.dart';
import 'package:ovowpp/app/screens/customer_account/widget/customer_profile.dart';
import 'package:ovowpp/app/screens/customer_account/widget/show_mobile_contact_bottom_sheet.dart';
import 'package:ovowpp/app/screens/global/widgets/country_bottom_sheet.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/controller/my_account/my_account_controller.dart';
import 'package:ovowpp/data/model/country_model/country_model.dart';
import 'package:ovowpp/data/repo/customer_account/customer_account_repo.dart';
import 'package:ovowpp/environment.dart';
import '../../components/app-bar/custom_app_bar.dart';
import '../../components/text-field/field_shadow.dart';

class CustomerAccountScreen extends StatefulWidget {
  const CustomerAccountScreen({super.key});

  @override
  State<CustomerAccountScreen> createState() => _CustomerAccountScreenState();
}

class _CustomerAccountScreenState extends State<CustomerAccountScreen> with SingleTickerProviderStateMixin {
  String comeFrom = '';
  bool isChatEdit = false;

  @override
  void initState() {
    Get.put(CustomerAccountRepo());
    final controller = Get.put(MyAccountController(myAccountRepo: Get.find()));
    controller.imagePath = Get.arguments[0] ?? '';
    controller.contact = Get.arguments[1];
    controller.isUpdate = Get.arguments[2] ?? false;
    controller.editIndex = Get.arguments[3] ?? -1;
    isChatEdit = Get.arguments[4] ?? false;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProfileInfo(forceLoad: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<MyAccountController>(
      builder: (controller) => AnnotatedRegionWidget(
        child: Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(
            elevation: 0,
            bgColor: Colors.white,
            title: controller.isUpdate ? MyStrings.updateContact.tr : MyStrings.addContact.tr,
          ),

          body: controller.isLoading
              ? const EditCustomerProfileShimmer()
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                    child: Column(
                      children: [
                        CustomerProfileWidget(isEdit: true, imagePath: controller.imageUrl, onClicked: () async {}),
                        LabelTextField(
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
                          isShadow: true,
                          fillColor: MyColor.searchFieldColor,
                        ),
                        spaceDown(Dimensions.space15.h),
                        LabelTextField(
                          controller: controller.lastNameController,
                          labelText: MyStrings.lastName.tr,
                          hintText: MyStrings.enterYourLastName.tr,
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
                          isShadow: true,
                          fillColor: MyColor.searchFieldColor,
                        ),
                        spaceDown(Dimensions.space15.h),
                        LabelTextField(
                          isRequired: true,
                          suffixIcon: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: MyColor.getTransparentColor(),
                                builder: (context) => ContactPickerBottomSheet(
                                  onContactSelected: (contact) {
                                    final phoneNumber = contact.phones.first.number;
                                    final name = contact.displayName;
                                    controller.mobileNoController = TextEditingController(text: phoneNumber.toString());
                                    controller.firstNameController = TextEditingController(text: name.toString());

                                    controller.update();
                                  },
                                ),
                              );
                            },
                            child: Icon(Icons.call, color: MyColor.getBodyTextColor()),
                          ),
                          labelText: (MyStrings.phoneNo).replaceAll('.', '').tr,
                          // hintText: MyStrings.enterYourPhoneNumber,
                          controller: controller.mobileNoController,
                          focusNode: controller.mobileNoFocusNode,
                          textInputType: TextInputType.phone,
                          inputAction: TextInputAction.next,
                          prefixIcon: SizedBox(
                            width: 120,
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
                          onChanged: (v) {},
                          onTap: () {},
                          isShadow: true,
                          fillColor: MyColor.searchFieldColor,
                        ),
                        spaceDown(Dimensions.space15.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: LabelText(
                            text: MyStrings.contactTags.tr,
                            textStyle: MyTextStyle.subHeading15W500FieldTitleColor,
                          ),
                        ),
                        spaceDown(Dimensions.textToTextSpace),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.searchFieldColor,
                            borderRadius: BorderRadius.circular(Dimensions.cardMargin),
                            border: Border.all(color: MyColor.socialContainerBorder),
                            boxShadow: [fieldShadow],
                          ),
                          child: TagSelector(tags: controller.tags),
                        ),
                        spaceDown(Dimensions.space15.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: LabelText(
                            text: MyStrings.contactList.tr,
                            textStyle: MyTextStyle.subHeading15W500FieldTitleColor,
                          ),
                        ),
                        spaceDown(Dimensions.textToTextSpace),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.searchFieldColor,
                            borderRadius: BorderRadius.circular(Dimensions.cardMargin),
                            border: Border.all(color: MyColor.socialContainerBorder),
                            boxShadow: [fieldShadow],
                          ),
                          child: TagSelector(tags: controller.contactTags, isContact: true),
                        ),
                        spaceDown(Dimensions.space15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: LabelText(
                                text: MyStrings.customAttributes.tr,
                                textStyle: MyTextStyle.subHeading15W500FieldTitleColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.customAttributeControllers.add({
                                  'key': TextEditingController(),
                                  'value': TextEditingController(),
                                });
                                controller.update();
                              },
                              child: MyAssetImageWidget(
                                assetPath: MyImages.add,
                                isSvg: true,
                                height: Dimensions.space25.w,
                                width: Dimensions.space25.w,
                              ),
                            ),
                          ],
                        ),
                        spaceDown(Dimensions.space15.h),
                        ListView.separated(
                          separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
                          itemCount: controller.customAttributeControllers.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final attribute = controller.customAttributeControllers[index];
                            return Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: LabelTextField(
                                    controller: attribute['key'],
                                    labelText: "",
                                    hideLabel: true,
                                    hintText: MyStrings.fieldName.tr,
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
                                    fillColor: MyColor.searchFieldColor,
                                    isShadow: true,
                                  ),
                                ),
                                spaceSide(Dimensions.space10.w),
                                Expanded(
                                  flex: 5,
                                  child: LabelTextField(
                                    controller: attribute['value'],
                                    labelText: "",
                                    hideLabel: true,
                                    hintText: MyStrings.fieldValue.tr,
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
                                    fillColor: MyColor.searchFieldColor,
                                    isShadow: true,
                                  ),
                                ),
                                spaceSide(Dimensions.space10.w),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: InkWell(
                                    onTap: () {
                                      controller.customAttributeControllers.removeAt(index);
                                      controller.update();
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: MyColor.getErrorColor(),
                                        borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                                      ),
                                      width: 40,
                                      child: Icon(Icons.delete, color: MyColor.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        spaceDown(Dimensions.space15.h),
                        spaceDown(Dimensions.space16.h),
                        CustomElevatedBtn(
                          isLoading: controller.saving,
                          text: controller.isUpdate ? MyStrings.update.tr : MyStrings.saveContact.tr,
                          onTap: () {
                            controller.saveContact(controller.editIndex ?? -1, isChatEdit);
                          },
                        ),
                        spaceDown(Dimensions.space12.h),
                        CustomElevatedBtn(
                          text: MyStrings.cancel.tr,
                          onTap: () {
                            Get.back();
                          },
                          bgColor: MyColor.cancelElevatedBtnBgColor,
                        ),
                        spaceDown(Dimensions.space23.h),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
