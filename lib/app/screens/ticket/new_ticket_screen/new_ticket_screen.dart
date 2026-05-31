import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/components/text/default_text.dart';
import 'package:ovowpp/app/screens/ticket/new_ticket_screen/section/attachment_section.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/support/new_ticket_controller.dart';
import 'package:ovowpp/data/repo/support/support_repo.dart';

import '../../../../core/utils/text_style.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key});

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  @override
  void initState() {
    Get.put(SupportRepo());
    Get.put(NewTicketController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<NewTicketController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.white,
        appBar: CustomAppBar(title: MyStrings.addNewTicket.tr),

        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(Dimensions.space15.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.space10.h),
                    color: MyColor.getCardBackgroundColor(),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.textToTextSpace),
                      LabelTextField(
                        labelText: MyStrings.subject.tr,
                        hintText: MyStrings.enterYourSubject.tr,
                        controller: controller.subjectController,
                        isPassword: false,
                        nextFocus: controller.messageFocusNode,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      DefaultText(text: MyStrings.priority.tr, textStyle: MyTextStyle.subHeading15W500FieldTitleColor),
                      const SizedBox(height: Dimensions.space5),

                      DropDownTextFieldContainer(
                        color: MyColor.getTransparentColor(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: DropdownButton<String>(
                            dropdownColor: MyColor.getCardBackgroundColor(),
                            value: controller.selectedPriority,
                            elevation: 8,
                            icon: SvgPicture.asset(MyImages.arrowDown),
                            iconDisabledColor: MyColor.getBorderColor(),
                            iconEnabledColor: MyColor.getPrimaryColor(),
                            isExpanded: true,
                            underline: Container(height: 0, color: MyColor.getInformationColor()),
                            onChanged: (String? newValue) {
                              controller.setPriority(newValue);
                            },
                            items: controller.priorityList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: theme.textTheme.labelMedium?.copyWith(fontSize: Dimensions.fontDefault),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      const SizedBox(height: Dimensions.textToTextSpace),

                      LabelTextField(
                        labelText: MyStrings.message.tr,
                        hintText: MyStrings.enterYourMessage.tr,
                        isPassword: false,
                        controller: controller.messageController,
                        maxLines: 5,
                        focusNode: controller.messageFocusNode,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      const SizedBox(height: Dimensions.textToTextSpace),
                      InkWell(
                        onTap: () {
                          controller.pickFile();
                        },
                        child: LabelTextField(
                          readOnly: true,
                          contentPadding: const EdgeInsets.all(Dimensions.space10),
                          isAttachment: true,
                          labelText: MyStrings.attachment.tr,
                          hintText: MyStrings.chooseAFile.tr,
                          inputAction: TextInputAction.done,
                          onChanged: (value) {
                            return;
                          },
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.pickFile();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space15,
                                vertical: Dimensions.space10,
                              ),
                              margin: const EdgeInsets.all(Dimensions.space5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: MyColor.getPrimaryColor(),
                              ),
                              child: Text(
                                MyStrings.upload,
                                style: theme.textTheme.labelMedium?.copyWith(color: MyColor.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space2),
                      Text(
                        "${MyStrings.supportedFileType.tr.toTitleCase()} ${MyStrings.ext.tr}",
                        style: theme.textTheme.bodySmall?.copyWith(color: MyColor.getBodyTextColor()),
                      ),
                      const SizedBox(height: Dimensions.space10),
                      const AttachmentSection(),
                      const SizedBox(height: 30),
                      Center(
                        child: CustomElevatedBtn(
                          isLoading: controller.submitLoading,
                          // isOutlined: true,
                          // isColorChange: true,
                          // verticalPadding: Dimensions.space15,
                          radius: Dimensions.space8,
                          bgColor: MyColor.getPrimaryColor(),
                          text: MyStrings.submit.tr,
                          onTap: () {
                            controller.submit();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class DropDownTextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const DropDownTextFieldContainer({super.key, required this.child, this.color = MyColor.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        border: Border.all(color: MyColor.getBorderColor(), width: .5),
      ),
      child: child,
    );
  }
}
