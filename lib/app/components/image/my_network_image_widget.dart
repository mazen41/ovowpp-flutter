import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_images.dart';
import 'my_asset_widget.dart';

class MyNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit boxFit;
  final bool isProfile;
  final Color? color;
  const MyNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.height = 80,
    this.width = 100,
    this.radius = 5,
    this.boxFit = BoxFit.cover,
    this.isProfile = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl.toString(),
      color: color,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit,
            colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: SpinKitFadingCube(color: MyColor.getPrimaryColor().withValues(alpha: 0.3), size: Dimensions.space20),
          ),
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: height,
        width: width,
        child: FittedBox(
          fit: boxFit,
          child: isProfile
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: MyAssetImageWidget(assetPath: MyImages.profile, isSvg: false, height: height, width: width),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Center(child: Icon(Icons.image, color: MyColor.getBodyTextColor())),
                ),
        ),
      ),
    );
  }
}
