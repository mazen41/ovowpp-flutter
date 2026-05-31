import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/app/screens/auth/profile_complete/widget/build_circle_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ovowpp/app/components/circle_image_button.dart';
import 'package:ovowpp/data/controller/my_account/my_account_controller.dart';
import '../../../../../../../core/utils/my_color.dart';
import '../../../../../../../core/utils/my_images.dart';

class CustomerProfileWidget extends StatefulWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  const CustomerProfileWidget({super.key, required this.imagePath, required this.onClicked, this.isEdit = false});

  @override
  State<CustomerProfileWidget> createState() => _CustomerProfileWidgetState();
}

class _CustomerProfileWidgetState extends State<CustomerProfileWidget> {
  XFile? imageFile;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            !widget.isEdit
                ? ClipOval(
                    child: Material(
                      color: MyColor.getTransparentColor(),
                      child: const CircleImageWidget(imagePath: MyImages.profile, width: 90, height: 90, isAsset: true),
                    ),
                  )
                : buildImage(),
            widget.isEdit
                ? Positioned(
                    bottom: 0,
                    right: -4,
                    child: GestureDetector(
                      onTap: () {
                        _openGallery(context);
                      },
                      child: BuildCircleWidget(
                        padding: 3,
                        color: Colors.white,
                        child: BuildCircleWidget(
                          padding: 8,
                          color: MyColor.getPrimaryColor(),
                          child: Icon(widget.isEdit ? Icons.add_a_photo : Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    final Object image;

    if (imageFile != null) {
      image = FileImage(File(imageFile!.path));
    } else if (widget.imagePath.contains('http')) {
      image = NetworkImage(widget.imagePath);
    } else {
      image = const AssetImage(MyImages.profile);
    }

    bool isAsset = widget.imagePath.contains('http') == true ? false : true;
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: MyColor.getScaffoldBackgroundColor(), width: 1),
      ),
      child: ClipOval(
        child: Material(
          color: theme.cardColor,
          child: imageFile != null
              ? Ink.image(
                  image: image as ImageProvider,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                  child: InkWell(onTap: widget.onClicked),
                )
              : CircleImageWidget(
                  onTap: () {},
                  isAsset: isAsset,
                  imagePath: isAsset ? MyImages.profile : widget.imagePath,
                  height: 100,
                  width: 100,
                ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );
    setState(() {
      Get.find<MyAccountController>().imageFile = File(result!.files.single.path!);
      imageFile = XFile(result.files.single.path!);
    });
  }
}
