import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

import 'package:ovowpp/data/controller/splash/splash_controller.dart';
import 'package:ovowpp/data/repo/auth/general_setting_repo.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // MyUtils.splashScreen();

    Get.put(GeneralSettingRepo());
    final controller = Get.put(SplashController(repo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.gotoNextPage();
    });
  }

  @override
  void dispose() {
    // MyUtils.allScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) => AnnotatedRegionWidget(
        statusBarColor: Colors.transparent,
        child: Scaffold(
          backgroundColor: controller.noInternet ? MyColor.white : MyColor.splashScreenBackground,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SplashBgImage(),
                spaceDown(Dimensions.space30.h),
                //   MyAssetImageWidget(assetPath: MyImages.appIcon, isSvg: true),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyAssetImageWidget(
                        height: 160.h,
                        width: 160.w,
                        isSvg: true,
                        assetPath: MyImages.splashScreenIcon,
                      ),
                    ],
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

class SplashBgImage extends StatelessWidget {
  const SplashBgImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
