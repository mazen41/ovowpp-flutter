import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/buttons/my_text_button.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class OnboardTransparentImageAndSkip extends StatelessWidget {
  final VoidCallback skipTap;
  final bool isShowSkip;

  const OnboardTransparentImageAndSkip({super.key, required this.skipTap, required this.isShowSkip});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.1,
          child: SizedBox(
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white, Colors.white.withValues(alpha: 0)],
                  stops: const [0.0, 0.85, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(MyImages.splashScreenBgImagePNG, fit: BoxFit.fill),
            ),
          ),
        ),
        isShowSkip
            ? Positioned(
                top: Dimensions.space40.h,
                right: Dimensions.space30.w,
                child: CustomTextButton(text: MyStrings.skip, onTap: skipTap, textColor: MyColor.lightBodyText),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
