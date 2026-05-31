import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/my_images.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/account/profile_controller.dart';
import 'package:ovowpp/app/components/circle_button_with_icon.dart';
import 'package:ovowpp/app/components/column_widget/card_column.dart';
import 'package:ovowpp/app/components/divider/custom_divider.dart';
import 'package:ovowpp/app/components/image/circle_shape_image.dart';

class ProfileTopSection extends StatefulWidget {
  const ProfileTopSection({super.key});

  @override
  State<ProfileTopSection> createState() => _ProfileTopSectionState();
}

class _ProfileTopSectionState extends State<ProfileTopSection> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<ProfileController>(
      builder: (controller) => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleButtonWithIcon(
                  circleSize: 50,
                  imageSize: 40,
                  padding: 0,
                  borderColor: Colors.transparent,
                  isIcon: false,
                  isAsset: false,
                  imagePath: controller.imageUrl,
                  isProfile: true,
                  onTap: () {},
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(RouteHelper.editProfileScreen),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.space5, horizontal: Dimensions.space15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyColor.getPrimaryColor(),
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.edit, color: MyColor.white, size: 20),
                        const SizedBox(width: Dimensions.space10),
                        Text(
                          MyStrings.editProfile.tr,
                          style: theme.textTheme.bodySmall?.copyWith(color: MyColor.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.space25),
            Row(
              children: [
                CircleShapeImage(
                  imageColor: MyColor.getAccent1Color(),
                  image: MyImages.name,
                  backgroundColor: MyColor.getPrimaryColor(),
                ),
                const SizedBox(width: Dimensions.space15),
                CardColumn(header: MyStrings.name.tr, body: controller.profileModel.data?.user?.username ?? ""),
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                CircleShapeImage(
                  imageColor: MyColor.getAccent1Color(),
                  image: MyImages.email,
                  backgroundColor: MyColor.getPrimaryColor(),
                ),
                const SizedBox(width: Dimensions.space15),
                CardColumn(header: MyStrings.email.tr, body: controller.profileModel.data?.user?.email ?? ""),
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                CircleShapeImage(imageColor: MyColor.getPrimaryColor(), image: MyImages.phone),
                const SizedBox(width: Dimensions.space15),
                CardColumn(header: MyStrings.phone.tr, body: controller.profileModel.data?.user?.mobile ?? ""),
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                CircleShapeImage(imageColor: MyColor.getPrimaryColor(), image: MyImages.address),
                const SizedBox(width: Dimensions.space15),
                CardColumn(header: MyStrings.address.tr, body: controller.profileModel.data?.user?.address ?? ""),
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                CircleShapeImage(imageColor: MyColor.getPrimaryColor(), image: MyImages.state),
                const SizedBox(width: Dimensions.space15),
                CardColumn(header: MyStrings.state.tr, body: controller.profileModel.data?.user?.state ?? ""),
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                CircleShapeImage(imageColor: MyColor.getPrimaryColor(), image: MyImages.zipCode),
                const SizedBox(width: Dimensions.space15),
                CardColumn(header: MyStrings.zipCode.tr, body: controller.profileModel.data?.user?.zip ?? ""),
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                CircleShapeImage(imageColor: MyColor.getPrimaryColor(), image: MyImages.city),
                const SizedBox(width: Dimensions.space15),
                CardColumn(header: MyStrings.city.tr, body: controller.profileModel.data?.user?.city ?? ""),
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                CircleShapeImage(imageColor: MyColor.getPrimaryColor(), image: MyImages.country),
                const SizedBox(width: Dimensions.space15),
                CardColumn(header: MyStrings.country.tr, body: controller.profileModel.data?.user?.countryName ?? ""),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
