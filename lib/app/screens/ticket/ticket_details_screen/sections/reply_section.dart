import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/circle_icon_button.dart';
import 'package:ovowpp/app/components/image/custom_svg_picture.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/controller/support/ticket_details_controller.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/my_icons.dart';

class ReplySection extends StatelessWidget {
  const ReplySection({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<TicketDetailsController>(
      builder: (controller) => Column(
        children: [
          LabelTextField(
            controller: controller.replyController,
            maxLines: 5,
            contentPadding: const EdgeInsets.all(Dimensions.space10),
            isAttachment: true,
            labelText: MyStrings.message,
            hintText: "",
            inputAction: TextInputAction.done,
            onChanged: (value) {
              return;
            },
          ),
          const SizedBox(height: 20),
          controller.attachmentList.isNotEmpty ? const SizedBox(height: 20) : const SizedBox.shrink(),
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
              suffixIcon: InkWell(
                onTap: () {
                  controller.pickFile();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space10),
                  margin: const EdgeInsets.all(Dimensions.space5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: MyColor.getPrimaryColor()),
                  child: Text(MyStrings.upload, style: theme.textTheme.labelMedium?.copyWith(color: MyColor.white)),
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space2),
          Text(
            "${MyStrings.supportedFileType.tr} ${MyStrings.ext}",
            style: theme.textTheme.bodySmall?.copyWith(color: MyColor.getBodyTextColor()),
          ),
          const SizedBox(height: Dimensions.space20),
          controller.attachmentList.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(
                          controller.attachmentList.length,
                          (index) => Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(Dimensions.space5),
                                    decoration: const BoxDecoration(),
                                    child: MyUtils.isImage(controller.attachmentList[index].path)
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                            child: Image.file(
                                              controller.attachmentList[index],
                                              width: context.width / 5,
                                              height: context.width / 5,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : MyUtils.isDoc(controller.attachmentList[index].path)
                                        ? Container(
                                            width: context.width / 5,
                                            height: context.width / 5,
                                            decoration: BoxDecoration(
                                              color: MyColor.white,
                                              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                              border: Border.all(color: MyColor.getBorderColor(), width: 1),
                                            ),
                                            child: const Center(
                                              child: CustomSvgPicture(image: MyIcons.doc, height: 45, width: 45),
                                            ),
                                          )
                                        : Container(
                                            width: context.width / 5,
                                            height: context.width / 5,
                                            decoration: BoxDecoration(
                                              color: MyColor.white,
                                              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                              border: Border.all(color: MyColor.getBorderColor(), width: 1),
                                            ),
                                            child: const Center(
                                              child: CustomSvgPicture(image: MyIcons.pdfFile, height: 45, width: 45),
                                            ),
                                          ),
                                  ),
                                  CircleIconButton(
                                    onTap: () {
                                      controller.removeAttachmentFromList(index);
                                    },
                                    height: Dimensions.space20,
                                    width: Dimensions.space20,
                                    backgroundColor: MyColor.getErrorColor(),
                                    child: Icon(Icons.close, color: MyColor.white, size: Dimensions.space15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: Dimensions.space30),
          CustomElevatedBtn(
            isLoading: controller.submitLoading,
            // isOutlined: true,
            // isColorChange: true,
            // verticalPadding: Dimensions.space15,
            // cornerRadius: Dimensions.space8,
            // color: MyColor.black,
            text: MyStrings.reply.tr,
            onTap: () {
              controller.submitReply();
            },
          ),
          const SizedBox(height: Dimensions.space30),
        ],
      ),
    );
  }
}
