import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/shimmer/diposit_history_shimmer.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/app/components/custom_no_data_found_class.dart';
import 'package:ovowpp/app/screens/deposits/widget/custom_deposits_card.dart';
import 'package:ovowpp/app/screens/deposits/widget/deposit_bottom_sheet.dart';
import 'package:ovowpp/app/screens/deposits/widget/deposit_history_top.dart';
import 'package:get/get.dart';
import '../../../core/helper/date_converter.dart';
import '../../../core/route/route.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_strings.dart';
import '../../../data/controller/deposit/deposit_history_controller.dart';
import '../../../data/repo/deposit/deposit_repo.dart';

class DepositsHistoryScreen extends StatefulWidget {
  const DepositsHistoryScreen({super.key});

  @override
  State<DepositsHistoryScreen> createState() => _DepositsHistoryScreenState();
}

class _DepositsHistoryScreenState extends State<DepositsHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  void fetchData() {
    Get.find<DepositController>().fetchNewList();
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<DepositController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(DepositRepo());
    final controller = Get.put(DepositController(depositRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.beforeInitLoadData();
      scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositController>(
      builder: (controller) => AnnotatedRegionWidget(
        top: true,
        child: MyCustomScaffold(
          appBarBgColor: MyColor.white,
          screenBgColor: MyColor.white,
          pageTitle: MyStrings.depositHistory.tr,
          titleFontSize: 18.sp,

          actionButton: [
            GestureDetector(
              onTap: () {
                controller.changeIsPress();
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.space7),
                decoration: BoxDecoration(color: MyColor.white, shape: BoxShape.circle),
                child: Icon(
                  controller.isSearch ? Icons.clear : Icons.search,
                  color: MyColor.getPrimaryColor(),
                  size: 26.sp,
                ),
              ),
            ),
            const SizedBox(width: Dimensions.space7),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.newDepositScreenScreen, arguments: {'source': 'regular_deposit'});
              },
              child: Container(
                margin: const EdgeInsets.only(left: 7, right: 10, bottom: 7, top: 7),
                padding: const EdgeInsets.all(Dimensions.space7),
                decoration: BoxDecoration(color: MyColor.white, shape: BoxShape.circle),
                child: Icon(Icons.add, color: MyColor.getPrimaryColor(), size: 26.sp),
              ),
            ),
          ],
          body: controller.isLoading
              ? const DepositHistoryShimmer()
              : Column(
                  children: [
                    Visibility(
                      visible: controller.isSearch,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DepositHistoryTop(),
                          SizedBox(height: Dimensions.space15),
                        ],
                      ),
                    ),
                    controller.depositList.isEmpty && controller.searchLoading == false
                        ? const NoDataOrInternetScreen()
                        : controller.searchLoading
                        ? Expanded(child: DepositHistoryShimmer())
                        : Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              controller: scrollController,
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: controller.depositList.length + 1,
                              separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                              itemBuilder: (context, index) {
                                if (controller.depositList.length == index) {
                                  return controller.hasNext()
                                      ? SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context).size.width,
                                          child: const Center(child: CustomLoader()),
                                        )
                                      : const SizedBox();
                                }
                                return CustomDepositsCard(
                                  onPressed: () {
                                    DepositBottomSheet.depositBottomSheet(context, index);
                                  },
                                  trxValue: controller.depositList[index].trx ?? "",
                                  date: DateConverter.isoToLocalDateAndTime(
                                    controller.depositList[index].createdAt ?? "",
                                  ),
                                  status: controller.getStatus(index),
                                  statusBgColor: controller.getStatusColor(index),
                                  amount:
                                      "${AppConverter.formatNumber(controller.depositList[index].amount ?? " ")} ${controller.currency}",
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
