import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/screens/manage_contact/widgets/manage_contact_card.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

import '../../../core/utils/app_permission.dart';
import '../../components/snack_bar/show_custom_snackbar.dart';

class ManageContactScreen extends StatefulWidget {
  const ManageContactScreen({super.key});

  @override
  State<ManageContactScreen> createState() => _ManageContactScreenState();
}

class _ManageContactScreenState extends State<ManageContactScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      statusBarColor: Colors.transparent,
      top: true,
      child: MyCustomScaffold(
        screenBgColor: MyColor.white,
        appBarBgColor: MyColor.white,
        pageTitle: MyStrings.manageContact.tr,
        body: Column(
          children: [
            ManageContactCard(
              onTap: () {
                if (MyUtils.checkPermission(AppPermission.viewContact)) {
                  Get.toNamed(RouteHelper.contactScreen, arguments: {'isBackButton': true, 'isUpload': true});
                } else {
                  CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                }
              },
              title: MyStrings.manageContact.tr,
              image: MyImages.contact,
            ),
            spaceDown(Dimensions.space10.h),
            ManageContactCard(
              onTap: () {
                if (MyUtils.checkPermission(AppPermission.viewContactList)) {
                  Get.toNamed(RouteHelper.allContactListScreen);
                } else {
                  CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                }
              },
              title: MyStrings.manageContactList.tr,
              image: MyImages.contactList,
            ),
            spaceDown(Dimensions.space10.h),
            ManageContactCard(
              onTap: () {
                if (MyUtils.checkPermission(AppPermission.viewContactTag)) {
                  Get.toNamed(RouteHelper.contactTagListScreen);
                } else {
                  CustomSnackBar.error(errorList: [MyStrings.permissionDenyMessage]);
                }
              },
              title: MyStrings.manageContactTag.tr,
              image: MyImages.contactTag,
            ),
          ],
        ),
      ),
    );
  }
}
