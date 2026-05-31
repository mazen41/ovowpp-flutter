import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ovowpp/app/components/circle_image_button.dart';
import 'package:ovowpp/core/route/route.dart';
import '../../../../../data/controller/account/profile_controller.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/image/my_network_image_widget.dart';
import '../../../components/text/default_text.dart';
import '../../dashboard/widget/round_icon_with_bg_color.dart';

class ProfileWidget extends StatefulWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;
  final VoidCallback? onEditTap;

  const ProfileWidget({
    super.key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false,
    this.onEditTap,
  });

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  XFile? imageFile;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            buildImage(),
            !widget.isEdit
                ? Positioned(
                    bottom: 0,
                    right: -4,
                    child: RoundIconWithBgColor(
                      onTap: () {
                        _openGallery(context);
                      },
                      borderColor: MyColor.dashboardCardBorder,
                      isOnTap: true,
                      bgColor: MyColor.white,
                      icon: MyImages.camera,
                      iconColor: MyColor.black,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        Material(
          color: widget.isEdit == true ? MyColor.getPrimaryColor() : MyColor.campaignFieldFillColor,
          borderRadius: BorderRadius.circular(Dimensions.space12.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(Dimensions.space12.r),
            onTap: () {
              widget.isEdit ? Get.toNamed(RouteHelper.profileEditForm) : Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.space20.w, vertical: Dimensions.space6.h),
              decoration: BoxDecoration(
                color: widget.isEdit ? MyColor.getPrimaryColor() : MyColor.lightSectionBackground,
                border: Border.all(
                  color: widget.isEdit == true ? MyColor.getPrimaryColor() : MyColor.notificationLineColor,
                ),

                borderRadius: BorderRadius.circular(Dimensions.space12.r),
              ),
              child: DefaultText(
                text: widget.isEdit == true ? MyStrings.edit.tr : MyStrings.cancel.tr,
                textStyle: MyTextStyle.heading16W600().copyWith(
                  color: widget.isEdit == true ? MyColor.white : MyColor.dark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImage() {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: MyColor.getScaffoldBackgroundColor(), width: 1),
        image: const DecorationImage(image: AssetImage(MyImages.background), fit: BoxFit.cover),
      ),
      child: ClipOval(
        child: Material(color: theme.cardColor, child: _buildProfileImageContent()),
      ),
    );
  }

  Widget _buildProfileImageContent() {
    // 1️⃣ Picked image
    if (imageFile != null && File(imageFile!.path).existsSync()) {
      return Ink.image(
        image: FileImage(File(imageFile!.path)),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        child: InkWell(onTap: widget.onClicked),
      );
    }

    // 2️⃣ Network image with fallback handled internally
    if (widget.imagePath.isNotEmpty && widget.imagePath.startsWith('http')) {
      return MyNetworkImageWidget(
        isProfile: true,
        imageUrl: widget.imagePath,
        height: 100,
        width: 100,
        radius: 100,
        boxFit: BoxFit.cover,
      );
    }

    // 3️⃣ Asset fallback
    return CircleImageWidget(
      onTap: widget.onClicked,
      isAsset: true,
      imagePath: MyImages.profile,
      height: 100,
      width: 100,
    );
  }

  void _openGallery(BuildContext context) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );
    setState(() {
      Get.find<ProfileController>().imageFile = File(result!.files.single.path!);
      imageFile = XFile(result.files.single.path!);
    });
  }
}
