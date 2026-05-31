import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class NewDepositShimmer extends StatelessWidget {
  const NewDepositShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: MyColor.white, borderRadius: BorderRadius.circular(10)),
      height: 370,
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyShimmerWidget(
            child: Container(
              height: 20,
              width: 200,
              decoration: BoxDecoration(color: MyColor.getBodyTextColor(), borderRadius: BorderRadius.circular(10)),
            ),
          ),
          spaceDown(Dimensions.space20),
          MyShimmerWidget(
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(color: MyColor.getBodyTextColor(), borderRadius: BorderRadius.circular(10)),
            ),
          ),
          spaceDown(Dimensions.space30),
          MyShimmerWidget(
            child: Container(
              height: 20,
              width: 200,
              decoration: BoxDecoration(color: MyColor.getBodyTextColor(), borderRadius: BorderRadius.circular(10)),
            ),
          ),
          spaceDown(Dimensions.space20),
          MyShimmerWidget(
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(color: MyColor.getBodyTextColor(), borderRadius: BorderRadius.circular(10)),
            ),
          ),
          spaceDown(Dimensions.space20),
          MyShimmerWidget(
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(color: MyColor.getBodyTextColor(), borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
