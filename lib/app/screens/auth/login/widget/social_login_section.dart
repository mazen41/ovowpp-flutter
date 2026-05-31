import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/screens/auth/login/widget/social_login_item.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/data/controller/auth/social_login_controller.dart';
import 'package:ovowpp/data/repo/auth/social_login_repo.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/my_images.dart';

class SocialLoginSection extends StatefulWidget {
  const SocialLoginSection({super.key});

  @override
  State<SocialLoginSection> createState() => _SocialLoginSectionState();
}

class _SocialLoginSectionState extends State<SocialLoginSection> {
  @override
  void initState() {
    Get.put(SocialLoginRepo());
    Get.put(SocialLoginController(repo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLoginController>(
      builder: (controller) {
        return Visibility(
          visible: controller.checkSocialAuthActiveOrNot(provider: 'all'),
          child: Row(
            children: [
              spaceDown(Dimensions.space10.h),
              if (controller.checkSocialAuthActiveOrNot(provider: 'google')) ...[
                Expanded(
                  child: SocialLoginItem(
                    isLoading: controller.isGoogleSignInLoading,
                    onSocialTap: () {
                      controller.signInWithGoogle();
                    },
                    iconPath: MyImages.googleLogoSVG,
                  ),
                ),

                spaceDown(Dimensions.defaultRadius),
              ],
              if (controller.checkSocialAuthActiveOrNot(provider: 'linkedin')) ...[
                Expanded(
                  child: SocialLoginItem(
                    isLoading: controller.isLinkedinLoading,
                    onSocialTap: () {
                      controller.signInWithLinkedin(context);
                    },
                    iconPath: MyImages.linkedInLogo,
                  ),
                ),

                spaceSide(Dimensions.defaultRadius),
              ],
            ],
          ),
        );
      },
    );
  }
}
