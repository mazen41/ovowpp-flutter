import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/app/components/buttons/custom_round_border_shape.dart';
import '../../core/utils/dimensions.dart';
import 'image/custom_svg_picture.dart';

class NoDataOrInternetScreen extends StatefulWidget {
  final String message;
  final double paddingTop;
  final double imageHeight;
  final bool fromReview;
  final bool isNoInternet;
  final Function? onChanged;
  final String message2;
  final String image;

  const NoDataOrInternetScreen({
    super.key,
    this.message = MyStrings.noData,
    this.paddingTop = 6,
    this.imageHeight = .5,
    this.fromReview = false,
    this.isNoInternet = false,
    this.onChanged,
    this.message2 = MyStrings.noDataToShow,
    this.image = MyImages.noDataImage,
  });

  @override
  State<NoDataOrInternetScreen> createState() => _NoDataOrInternetScreenState();
}

class _NoDataOrInternetScreenState extends State<NoDataOrInternetScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: ListView(
        physics: widget.fromReview ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(height: Dimensions.space30.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Dimensions.space30.h,
                width: widget.isNoInternet ? mediaQuery.size.width * 0.6 : mediaQuery.size.width * 0.4,
                child: widget.isNoInternet
                    ? Lottie.asset(
                        MyImages.noInternet,
                        height: mediaQuery.size.height * widget.imageHeight,
                        width: mediaQuery.size.width * 0.6,
                      )
                    : CustomSvgPicture(
                        image: widget.image,
                        height: Dimensions.space100.h,
                        width: Dimensions.space100.w,
                        color: MyColor.getBorderColor(),
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: Dimensions.space2.h,
                  left: Dimensions.space30.w,
                  right: Dimensions.space30.w,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.isNoInternet ? MyStrings.noInternet.tr : widget.message.tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: widget.isNoInternet ? MyColor.getErrorColor() : MyColor.getBodyTextColor(),
                        fontSize: Dimensions.space18,
                      ),
                    ),
                    SizedBox(height: Dimensions.space5.h),
                    if (!widget.isNoInternet)
                      Text(
                        widget.message2,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: MyColor.getBodyTextColor(),
                          fontSize: Dimensions.fontLarge,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (widget.isNoInternet) SizedBox(height: Dimensions.space15.h),
                    if (widget.isNoInternet)
                      InkWell(
                        onTap: () async {
                          final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult.any((result) => result != ConnectivityResult.none)) {
                            widget.onChanged!(true);
                          }
                        },
                        child: RoundedBorderContainer(
                          text: MyStrings.retry.tr,
                          bgColor: MyColor.getErrorColor(),
                          borderColor: MyColor.getErrorColor(),
                          textColor: MyColor.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
