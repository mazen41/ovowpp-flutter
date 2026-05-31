import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class DepositHistoryShimmer extends StatefulWidget {
  const DepositHistoryShimmer({super.key});

  @override
  State<DepositHistoryShimmer> createState() => _DepositHistoryShimmerState();
}

class _DepositHistoryShimmerState extends State<DepositHistoryShimmer> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: MyColor.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyShimmerWidget(
                      child: Container(
                        height: 30,
                        width: Dimensions.space100,
                        decoration: BoxDecoration(
                          color: MyColor.getBodyTextColor(),
                          borderRadius: BorderRadius.circular(Dimensions.space5),
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
                          borderRadius: BorderRadius.circular(Dimensions.space5),
                        ),
                      ),
                    ),
                    spaceDown(Dimensions.space10),
                    MyShimmerWidget(
                      child: Container(
                        height: 30,
                        width: Dimensions.space100,
                        decoration: BoxDecoration(
                          color: MyColor.getBodyTextColor(),
                          borderRadius: BorderRadius.circular(Dimensions.space5),
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
                          borderRadius: BorderRadius.circular(Dimensions.space5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyShimmerWidget(
                    child: Container(
                      height: 20,
                      width: Dimensions.space50,
                      decoration: BoxDecoration(
                        color: MyColor.getBodyTextColor(),
                        borderRadius: BorderRadius.circular(Dimensions.space5),
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space10),
                  MyShimmerWidget(
                    child: Container(
                      height: 20,
                      width: 30,
                      decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                    ),
                  ),
                  spaceDown(Dimensions.space40),
                  MyShimmerWidget(
                    child: Container(
                      height: 20,
                      width: Dimensions.space50,
                      decoration: BoxDecoration(
                        color: MyColor.getBodyTextColor(),
                        borderRadius: BorderRadius.circular(Dimensions.space5),
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space10),
                  MyShimmerWidget(
                    child: Container(
                      height: 20,
                      width: 100,
                      decoration: BoxDecoration(color: MyColor.getBodyTextColor()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
