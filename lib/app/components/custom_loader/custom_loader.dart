import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/indicator/indicator.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class CustomLoader extends StatelessWidget {
  final bool isFullScreen;
  final bool isPagination;
  final double strokeWidth;
  final Color loaderColor;
  final double loaderSize;

  const CustomLoader({
    super.key,
    this.isFullScreen = false,
    this.isPagination = false,
    this.strokeWidth = 1,
    this.loaderColor = MyColor.black,
    this.loaderSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(color: loaderColor, value: loaderSize),
            ),
          )
        : isPagination
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: LoadingIndicator(size: loaderSize, strokeWidth: strokeWidth),
            ),
          )
        : Center(
            child: Transform.scale(scale: 0.6, child: CircularProgressIndicator(color: loaderColor)),
          );
  }
}
