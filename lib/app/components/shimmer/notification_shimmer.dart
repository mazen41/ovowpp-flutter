import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class NotificationShimmer extends StatefulWidget {
  const NotificationShimmer({super.key});

  @override
  State<NotificationShimmer> createState() => _NotificationShimmerState();
}

class _NotificationShimmerState extends State<NotificationShimmer> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
      itemCount: 20,
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
                        width: double.infinity,
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
