import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class CustomerDetailsShimmer extends StatefulWidget {
  const CustomerDetailsShimmer({super.key});

  @override
  State<CustomerDetailsShimmer> createState() => _CustomerDetailsShimmerState();
}

class _CustomerDetailsShimmerState extends State<CustomerDetailsShimmer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spaceDown(Dimensions.space20),
        Row(
          children: [
            MyShimmerWidget(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: MyColor.getBodyTextColor(),
                  borderRadius: BorderRadius.circular(Dimensions.space10),
                ),
              ),
            ),
            spaceSide(Dimensions.space10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyShimmerWidget(
                  child: Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                      color: MyColor.getBodyTextColor(),
                      borderRadius: BorderRadius.circular(Dimensions.space10),
                    ),
                  ),
                ),
                spaceDown(Dimensions.space10),
                MyShimmerWidget(
                  child: Container(
                    height: 15,
                    width: 200,
                    decoration: BoxDecoration(
                      color: MyColor.getBodyTextColor(),
                      borderRadius: BorderRadius.circular(Dimensions.space10),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            MyShimmerWidget(
              child: Container(
                height: 20,
                width: 60,
                decoration: BoxDecoration(
                  color: MyColor.getBodyTextColor(),
                  borderRadius: BorderRadius.circular(Dimensions.space10),
                ),
              ),
            ),
          ],
        ),
        spaceDown(Dimensions.space30),
        Row(
          children: [
            Expanded(
              child: MyShimmerWidget(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor.getBodyTextColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space10),
                  ),
                ),
              ),
            ),
            spaceSide(Dimensions.space10),
            Expanded(
              child: MyShimmerWidget(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor.getBodyTextColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space10),
                  ),
                ),
              ),
            ),
          ],
        ),
        spaceDown(Dimensions.space10),
        MyShimmerWidget(
          child: Container(
            height: 20,
            width: 80,
            decoration: BoxDecoration(
              color: MyColor.getBodyTextColor(),
              borderRadius: BorderRadius.circular(Dimensions.space10),
            ),
          ),
        ),
        spaceDown(Dimensions.space15),
        Row(
          children: [
            Expanded(
              child: MyShimmerWidget(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor.getBodyTextColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space10),
                  ),
                ),
              ),
            ),
            spaceSide(Dimensions.space10),
            Expanded(
              child: MyShimmerWidget(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor.getBodyTextColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space10),
                  ),
                ),
              ),
            ),
            spaceSide(Dimensions.space10),
            Expanded(
              child: MyShimmerWidget(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor.getBodyTextColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space10),
                  ),
                ),
              ),
            ),
            spaceSide(Dimensions.space10),
            Expanded(
              child: MyShimmerWidget(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor.getBodyTextColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space10),
                  ),
                ),
              ),
            ),
          ],
        ),
        spaceDown(Dimensions.space20),
        MyShimmerWidget(
          child: Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: MyColor.getBodyTextColor(),
              borderRadius: BorderRadius.circular(Dimensions.space10),
            ),
          ),
        ),
        spaceDown(Dimensions.space20),
        MyShimmerWidget(
          child: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColor.getBodyTextColor(),
              borderRadius: BorderRadius.circular(Dimensions.space10),
            ),
          ),
        ),
      ],
    );
  }
}
