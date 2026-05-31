import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/alert-dialog/custom_alert_dialog.dart';
import 'package:ovowpp/app/components/alert-dialog/delete_dialogue.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/image/my_asset_widget.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/shimmer/all_contact_shimmer.dart';
import 'package:ovowpp/app/components/text-field/label_text_field.dart';
import 'package:ovowpp/app/screens/all_contact/widgets/upload_csv_dialogue.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/all_contacts/all_contact_controller.dart';
import 'package:ovowpp/data/repo/all_contact/all_contact_repo.dart';

class AllContactScreen extends StatefulWidget {
  const AllContactScreen({super.key});

  @override
  State<AllContactScreen> createState() => _AllContactScreenState();
}

class _AllContactScreenState extends State<AllContactScreen> {
  final ScrollController _controller = ScrollController();
  Timer? _debounceTimer;

  void fetchData() {
    Get.find<AllContactController>().initData();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (Get.find<AllContactController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(AllContactRepo());
    final controller = Get.put(AllContactController(repo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.page = 0;
      controller.initData();
      controller.clearActiveNotificationInfo();
      _controller.addListener(_scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MyCustomScaffold(
      screenBgColor: MyColor.white,
      showAppBarContent: true,
      appBarBgColor: MyColor.white,
      appBarContent: GetBuilder<AllContactController>(
        builder: (controller) => Row(
          children: [
            Expanded(
              child: Text(
                MyStrings.allContacts.tr,
                style: theme.textTheme.headlineMedium?.copyWith(color: MyColor.getHeadingTextColor()),
              ),
            ),
            GestureDetector(
              onTap: () {
                CustomAlertDialog(
                  verticalPadding: 0,
                  isHorizontalPadding: false,
                  child: UploadCsvDialogue(),
                ).customAlertDialog(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColor.getInformationColor().withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(Dimensions.space5),
                ),
                child: Icon(Icons.file_upload_outlined, color: MyColor.black),
              ),
            ),
            spaceSide(Dimensions.space5.w),
            Visibility(
              visible: MyUtils.checkPermission(AppPermission.addContactList),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.customerAccountScreen, arguments: [controller.imagePath, null, false]);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColor.getPrimaryColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space5),
                  ),
                  child: Icon(Icons.add, color: MyColor.black),
                ),
              ),
            ),
            spaceSide(Dimensions.space15),
          ],
        ),
      ),
      transformValue: 1,
      pageTitle: MyStrings.allContacts.tr,
      body: GetBuilder<AllContactController>(
        builder: (controller) => RefreshIndicator(
          color: MyColor.getPrimaryColor(),
          backgroundColor: MyColor.getBackgroundColor(),
          onRefresh: () async {
            controller.page = 0;
            await controller.initData(initPage: true);
          },
          child: Column(
            children: [
              LabelTextField(
                labelText: MyStrings.search.tr,
                hideLabel: true,
                hintText: MyStrings.search.tr,
                controller: controller.searchController,
                onChanged: (value) {
                  if (_debounceTimer?.isActive ?? false) {
                    _debounceTimer?.cancel();
                  }

                  _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                    controller.initData(initPage: true);
                  });
                },
                textInputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                radius: Dimensions.largeRadius,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(Dimensions.space10),
                  child: MyAssetImageWidget(
                    assetPath: MyImages.search,
                    isSvg: true,
                    height: Dimensions.space10.h,
                    width: Dimensions.space10.h,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return MyStrings.fieldErrorMsg.tr;
                  } else {
                    return null;
                  }
                },
              ),
              spaceDown(Dimensions.space10),
              controller.isContactLoading
                  ? Expanded(child: const AllContactShimmer())
                  : controller.allContactsData.isEmpty
                  ? Expanded(child: NoDataWidget(text: MyStrings.noContactFound.tr))
                  : Expanded(
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: controller.allContactsData.length + 1,
                        itemBuilder: (context, index) {
                          if (controller.allContactsData.length == index) {
                            return controller.hasNext()
                                ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                                : const SizedBox();
                          }
                          var item = controller.allContactsData[index];
                          return Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: MyColor.getCardBackgroundColor(),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.space10.w),
                              leading: item.image != null
                                  ? CircleAvatar(
                                      maxRadius: 25,
                                      backgroundImage: NetworkImage(
                                        "${UrlContainer.domainUrl}/${controller.imagePath}/${item.image}",
                                      ),
                                    )
                                  : AlphabetAvatar(firstname: item.firstname ?? "", lastName: item.lastname ?? ""),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item.firstname ?? ""} ${item.lastname ?? ""}",
                                          style: theme.textTheme.headlineSmall?.copyWith(color: MyColor.black),
                                        ),
                                        spaceDown(Dimensions.space4.h),
                                        Text(
                                          "+${item.mobileCode ?? ""}${item.mobile ?? ""}",
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: MyColor.getBodyTextColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(
                                            RouteHelper.customerAccountScreen,
                                            arguments: [controller.imagePath, item, true],
                                          );
                                        },
                                        child: MyAssetImageWidget(
                                          assetPath: MyImages.edit,
                                          isSvg: true,
                                          height: Dimensions.space20.h,
                                          width: Dimensions.space20.h,
                                          color: MyColor.getPrimaryColor(),
                                        ),
                                      ),
                                      spaceSide(Dimensions.space10),
                                      InkWell(
                                        onTap: () {
                                          controller.contactId = item.id.toString();
                                          controller.createConversation();
                                        },
                                        child: MyAssetImageWidget(
                                          assetPath: MyImages.send,
                                          isSvg: true,
                                          height: Dimensions.space20.h,
                                          width: Dimensions.space20.h,
                                          color: MyColor.getInformationColor(),
                                        ),
                                      ),
                                      spaceSide(Dimensions.space10),
                                      Visibility(
                                        visible: MyUtils.checkPermission(AppPermission.deleteContactList),
                                        child: InkWell(
                                          onTap: () {
                                            controller.userId = item.id.toString();
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              return CustomAlertDialog(
                                                verticalPadding: 0,
                                                isHorizontalPadding: true,
                                                child: GetBuilder<AllContactController>(
                                                  builder: (context) {
                                                    return DeleteDialogue(
                                                      warningText: MyStrings.areYouSureYouWantToDeleteThisContact.tr,
                                                      isLoading: controller.isDeleteLoading,
                                                      onTap: () {
                                                        controller.deleteMessage(index);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ).customAlertDialog(context);
                                            });
                                          },
                                          child: MyAssetImageWidget(
                                            assetPath: MyImages.delete,
                                            isSvg: true,
                                            height: Dimensions.space20.h,
                                            width: Dimensions.space20.h,
                                            color: MyColor.getErrorColor(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
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
