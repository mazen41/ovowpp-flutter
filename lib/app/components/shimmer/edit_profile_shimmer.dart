import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class EditProfileShimmer extends StatefulWidget {
  const EditProfileShimmer({super.key});

  @override
  State<EditProfileShimmer> createState() => _EditProfileShimmerState();
}

class _EditProfileShimmerState extends State<EditProfileShimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              MyShimmerWidget(
                child: ClipOval(
                  child: Material(
                    color: MyColor.getTransparentColor(),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: MyShimmerWidget(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.getBodyTextColor()),
                  ),
                ),
              ),
            ],
          ),
          spaceDown(Dimensions.space20),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.all(0),
                  tileColor: MyColor.getTransparentColor(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyShimmerWidget(
                        child: Container(
                          height: 20,
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
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MyColor.getBodyTextColor(),
                            borderRadius: BorderRadius.circular(Dimensions.space5),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          spaceDown(Dimensions.space20),
          MyShimmerWidget(
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColor.getBodyTextColor(),
                borderRadius: BorderRadius.circular(Dimensions.space5),
              ),
            ),
          ),
          spaceDown(Dimensions.space100.h),
        ],
      ),
    );
  }
}
