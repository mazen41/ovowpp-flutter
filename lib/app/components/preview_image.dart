import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/controller/chat/chat_controller.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({super.key});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              IconButton(
                icon: controller.downloadingFile == true
                    ? SizedBox(
                        width: Dimensions.space20,
                        height: Dimensions.space20,
                        child: CircularProgressIndicator(color: MyColor.getPrimaryColor()),
                      )
                    : Icon(Icons.download, color: MyColor.black),
                onPressed: () {
                  controller.downloadAttachment(Get.arguments[1], Get.arguments[2], Get.arguments[3]);
                },
              ),
            ],
          ),
          body: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: Get.arguments[0].toString(),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  boxShadow: const [],
                  // borderRadius:  BorderRadius.circular(radius),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                ),
              ),
              placeholder: (context, url) => SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                  child: Center(
                    child: SpinKitFadingCube(
                      color: MyColor.getPrimaryColor().withValues(alpha: 0.3),
                      size: Dimensions.space20,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                  child: Center(child: Icon(Icons.image, color: MyColor.getBorderColor().withValues(alpha: 0.5))),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
