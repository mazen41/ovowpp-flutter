import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../../data/controller/all_contacts/all_contact_controller.dart';
import '../../../../data/model/customer_details/customer_details_response_model.dart' show Contact;
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/divider/line.dart';
import '../../../components/no_data.dart';
import '../../../components/shimmer/all_contact_shimmer.dart';
import 'contact_item.dart';

class ContactTabBarView extends StatelessWidget {
  const ContactTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllContactController>(
      builder: (controller) {
        return controller.isContactLoading
            ? const AllContactShimmer()
            : controller.newAllContactsData.isEmpty
            ? NoDataWidget(text: MyStrings.noContactFound.tr)
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    final metrics = notification.metrics;

                    if (metrics.pixels >= metrics.maxScrollExtent - 100) {
                      if (!controller.isLoadingMore && controller.hasNext()) {
                        controller.newGetContact(
                          loadMore: true,
                          status: controller.status,
                          searchQuery: controller.searchQuery,
                        );
                      }
                    }
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(childCount: controller.newAllContactsData.length, (
                        context,
                        index,
                      ) {
                        if (controller.newAllContactsData.length == index) {
                          return controller.hasNext()
                              ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                              : const SizedBox();
                        }
                        Contact item = controller.newAllContactsData[index];
                        final bool isLastIndex = index == controller.newAllContactsData.length;
                        return Column(
                          children: [
                            InkWell(
                              child: ContactItem(isLastIndex: true, item: item, index: index),
                            ),
                            isLastIndex
                                ? SizedBox.shrink()
                                : Padding(
                                    padding: EdgeInsets.symmetric(vertical: Dimensions.space7.h),
                                    child: Line(),
                                  ),
                          ],
                        );
                      }),
                    ),
                    SliverToBoxAdapter(
                      child: controller.isLoadingMore
                          ? CustomLoader(isPagination: true, loaderSize: 50.sp)
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
