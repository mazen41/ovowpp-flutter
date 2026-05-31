import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/view_contact/add_new_contact_group_controller.dart';
import 'package:ovowpp/data/repo/view_contact/add_new_contact_repo.dart';

import '../../../core/utils/text_style.dart';
import '../../components/annotated_region/annotated_region_widget.dart';

class AddNewContactGroupScreen extends StatefulWidget {
  const AddNewContactGroupScreen({super.key});

  @override
  State<AddNewContactGroupScreen> createState() => _AddNewContactGroupScreenState();
}

class _AddNewContactGroupScreenState extends State<AddNewContactGroupScreen> {
  final ScrollController _controller = ScrollController();

  void fetchData() {
    Get.find<AddNewContactGroupController>().initData();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (Get.find<AddNewContactGroupController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(AddNewContactRepo());
    final controller = Get.put(AddNewContactGroupController(repo: Get.find()));

    super.initState();

    controller.id = Get.arguments[0];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.page = 0;
      //  controller.getAllContact();
      controller.initData();
      _controller.addListener(_scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      statusBarColor: Colors.transparent,
      top: true,
      child: MyCustomScaffold(
        showAppBarContent: true,
        appBarContent: GetBuilder<AddNewContactGroupController>(
          builder: (controller) => Row(
            children: [
              Expanded(
                child: Text(
                  MyStrings.viewContactList.tr,
                  style: MyTextStyle.heading20W700().copyWith(color: MyColor.appBarTitleColor),
                ),
              ),
              spaceSide(Dimensions.space5.w),
            ],
          ),
        ),
        transformValue: 1,
        pageTitle: MyStrings.allContacts.tr,
        body: GetBuilder<AddNewContactGroupController>(
          builder: (controller) => RefreshIndicator(
            color: MyColor.getPrimaryColor(),
            backgroundColor: MyColor.getBackgroundColor(),
            onRefresh: () async {
              controller.page = 0;
              await controller.initData();
            },
            child: controller.isLoading
                ? const CustomLoader()
                : controller.allContactListdata.isEmpty
                ? const NoDataWidget()
                : ListView.builder(
                    controller: _controller,
                    itemCount: controller.allContactListdata.length + 1,
                    itemBuilder: (context, index) {
                      if (controller.allContactListdata.length == index) {
                        return controller.hasNext()
                            ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                            : const SizedBox();
                      }
                      var item = controller.allContactListdata[index];
                      bool isSelected = controller.contactList.contains(item.id.toString());

                      return Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: MyColor.getCardBackgroundColor(),
                        ),
                        child: ListTile(
                          onTap: () {
                            controller.toggleContactSelection(item.id.toString());
                            controller.update();
                          },
                          title: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item.firstname ?? ""} ${item.lastname ?? ""}",
                                      style: MyTextStyle.subHeading16W400().copyWith(color: MyColor.ovoTextColor),
                                    ),
                                    spaceDown(Dimensions.space4.h),
                                    Text(
                                      "+${item.mobileCode ?? ""}${item.mobile ?? ""}",
                                      style: MyTextStyle.subHeading14W600FieldTitleColor().copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            height: Dimensions.space10.h,
                            width: Dimensions.space10.h,

                            child: Checkbox(
                              activeColor: MyColor.getPrimaryColor(),
                              value: isSelected,
                              onChanged: (bool? value) {
                                controller.toggleContactSelection(item.id.toString());
                                controller.update();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        floatingActionButton: GetBuilder<AddNewContactGroupController>(
          builder: (controller) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(Dimensions.space15.sp),
                child: CustomElevatedBtn(
                  isLoading: controller.savingContact,
                  text: MyStrings.save.tr,
                  onTap: () {
                    controller.addContact();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
