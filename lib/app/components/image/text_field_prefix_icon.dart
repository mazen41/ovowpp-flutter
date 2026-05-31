import 'package:flutter/cupertino.dart';

import '../../../core/utils/util_exporter.dart';
import 'my_asset_widget.dart';

class TextFieldPrefixIcon extends StatelessWidget {
  final String imagePath;
  const TextFieldPrefixIcon({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10.r),
      child: MyAssetImageWidget(height: 24.sp, width: 24.sp, isSvg: true, assetPath: imagePath),
    );
  }
}
