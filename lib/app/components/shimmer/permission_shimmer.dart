import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/card/custom_app_card.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'my_shimmer_widget.dart';

class PaymentMethodShimmer extends StatelessWidget {
  const PaymentMethodShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColor.getBackgroundColor(),
        borderRadius: BorderRadius.circular(Dimensions.space8),
      ),
      child: Column(
        children: [
          CustomAppCard(
            radius: Dimensions.space10.w,
            showBorder: false,
            child: MyShimmerWidget(
              child: Column(
                children: [
                  ListTile(
                    tileColor: MyColor.white,
                    contentPadding: EdgeInsetsDirectional.zero,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(color: MyColor.white, height: Dimensions.space20, width: Dimensions.space100),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space20),
                          ),
                          height: Dimensions.space25.h,
                          width: Dimensions.space40.w,
                        ),
                        spaceSide(Dimensions.space10),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space10),
                          ),
                          height: Dimensions.space40.h,
                          width: Dimensions.space40.w,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    tileColor: MyColor.white,
                    contentPadding: EdgeInsetsDirectional.zero,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(color: MyColor.white, height: Dimensions.space20, width: Dimensions.space100),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space20),
                          ),
                          height: Dimensions.space25.h,
                          width: Dimensions.space40.w,
                        ),
                        spaceSide(Dimensions.space10),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space10),
                          ),
                          height: Dimensions.space40.h,
                          width: Dimensions.space40.w,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    tileColor: MyColor.white,
                    contentPadding: EdgeInsetsDirectional.zero,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(color: MyColor.white, height: Dimensions.space20, width: Dimensions.space100),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space20),
                          ),
                          height: Dimensions.space25.h,
                          width: Dimensions.space40.w,
                        ),
                        spaceSide(Dimensions.space10),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space10),
                          ),
                          height: Dimensions.space40.h,
                          width: Dimensions.space40.w,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    tileColor: MyColor.white,
                    contentPadding: EdgeInsetsDirectional.zero,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(color: MyColor.white, height: Dimensions.space20, width: Dimensions.space100),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space20),
                          ),
                          height: Dimensions.space25.h,
                          width: Dimensions.space40.w,
                        ),
                        spaceSide(Dimensions.space10),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space10),
                          ),
                          height: Dimensions.space40.h,
                          width: Dimensions.space40.w,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    tileColor: MyColor.white,
                    contentPadding: EdgeInsetsDirectional.zero,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(color: MyColor.white, height: Dimensions.space20, width: Dimensions.space100),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space20),
                          ),
                          height: Dimensions.space25.h,
                          width: Dimensions.space40.w,
                        ),
                        spaceSide(Dimensions.space10),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: BorderRadiusDirectional.circular(Dimensions.space10),
                          ),
                          height: Dimensions.space40.h,
                          width: Dimensions.space40.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          spaceDown(Dimensions.space10),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, i) {
                return CustomAppCard(
                  radius: Dimensions.space10.w,
                  showBorder: false,
                  child: MyShimmerWidget(
                    child: ListTile(
                      tileColor: MyColor.white,
                      contentPadding: EdgeInsetsDirectional.zero,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(color: MyColor.white, height: Dimensions.space20, width: Dimensions.space100),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: MyColor.white,
                              borderRadius: BorderRadiusDirectional.circular(Dimensions.space20),
                            ),
                            height: Dimensions.space25.h,
                            width: Dimensions.space40.w,
                          ),
                          spaceSide(Dimensions.space10),
                          Container(
                            decoration: BoxDecoration(
                              color: MyColor.white,
                              borderRadius: BorderRadiusDirectional.circular(Dimensions.space10),
                            ),
                            height: Dimensions.space40.h,
                            width: Dimensions.space40.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
