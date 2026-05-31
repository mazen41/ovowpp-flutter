import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/shimmer/diposit_history_shimmer.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/controller/withdraw/withdraw_history_controller.dart';
import 'package:ovowpp/data/repo/withdraw/withdraw_history_repo.dart';
import 'package:get/get.dart';
import '../../../../core/helper/date_converter.dart';
import '../../../../core/route/route.dart';

import '../widget/custom_withdraw_card.dart';
import '../widget/withdraw_bottom_sheet.dart';
import '../widget/withdraw_history_top.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<WithdrawHistoryController>().hasNext()) {
        Get.find<WithdrawHistoryController>().loadPaginationData();
      }
    }
  }

  @override
  void initState() {
    Get.put(WithdrawHistoryRepo());
    final controller = Get.put(WithdrawHistoryController(withdrawHistoryRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initData();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawHistoryController>(
      builder: (controller) {
        return AnnotatedRegionWidget(
          top: true,
          child: MyCustomScaffold(
            appBarBgColor: MyColor.white,
            screenBgColor: MyColor.white,
            pageTitle: MyStrings.withdraw.tr,
            actionButton: [
              GestureDetector(
                onTap: () {
                  controller.changeSearchStatus();
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.space7),
                  decoration: BoxDecoration(color: MyColor.white, shape: BoxShape.circle),
                  child: Icon(
                    controller.isSearch ? Icons.clear : Icons.search,
                    color: MyColor.getPrimaryColor(),
                    size: 25,
                  ),
                ),
              ),
              spaceSide(Dimensions.space7.w),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.addWithdrawMethodScreen);
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
                            WithdrawHistoryTop(),
                            SizedBox(height: Dimensions.space10),
                          ],
                        ),
                      ),
                      Expanded(
                        child: (controller.withdrawList.isEmpty) && controller.filterLoading == false
                            ? Center(child: NoDataWidget())
                            : controller.filterLoading
                            ? const DepositHistoryShimmer()
                            : SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: (controller.withdrawList.length) + 1,
                                  controller: scrollController,
                                  separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                                  itemBuilder: (context, index) {
                                    if (index == (controller.withdrawList.length)) {
                                      return controller.hasNext()
                                          ? const CustomLoader(isPagination: true)
                                          : const SizedBox();
                                    }

                                    final withdraw = controller.withdrawList[index]; // using null check operator safely

                                    return CustomWithdrawCard(
                                      onPressed: () {
                                        WithdrawBottomSheet().withdrawBottomSheet(index, context, controller.currency);
                                      },
                                      trxValue: withdraw.trx ?? "", // fallback to empty string if null
                                      date: DateConverter.isoToLocalDateAndTime(withdraw.createdAt ?? ""),
                                      status: controller.getStatus(index),
                                      statusBgColor: controller.getColor(index),
                                      amount:
                                          "${AppConverter.formatNumber(withdraw.finalAmount ?? "0")} ${controller.currency}",
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
