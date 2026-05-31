import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class DashboardShimmer extends StatefulWidget {
  const DashboardShimmer({super.key});

  @override
  State<DashboardShimmer> createState() => _DashboardShimmerState();
}

class _DashboardShimmerState extends State<DashboardShimmer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        spaceDown(Dimensions.space25),
        ListTile(
          tileColor: MyColor.white,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyShimmerWidget(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: MyColor.getBodyTextColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space5),
                  ),
                ),
              ),
              spaceSide(Dimensions.space10),
              MyShimmerWidget(
                child: Container(
                  height: 25,
                  width: 250,
                  decoration: BoxDecoration(
                    color: MyColor.getBodyTextColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space5),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.horizontalScreenPadding,
            vertical: Dimensions.space10,
          ),
          child: ListTile(
            tileColor: MyColor.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyShimmerWidget(
                  child: Container(
                    height: 30,
                    width: 250,
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
                    height: 20,
                    width: double.infinity - 50,
                    decoration: BoxDecoration(
                      color: MyColor.getBodyTextColor(),
                      borderRadius: BorderRadius.circular(Dimensions.space5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.horizontalScreenPadding,
            vertical: Dimensions.space10,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: Dimensions.space10, horizontal: Dimensions.space10),
            tileColor: MyColor.white,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyShimmerWidget(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: MyColor.getBodyTextColor(),
                      borderRadius: BorderRadius.circular(Dimensions.space5),
                    ),
                  ),
                ),
                spaceSide(Dimensions.space10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyShimmerWidget(
                      child: Container(
                        height: 25,
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
                        height: 15,
                        width: 100,
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
                        width: 100,
                        decoration: BoxDecoration(
                          color: MyColor.getBodyTextColor(),
                          borderRadius: BorderRadius.circular(Dimensions.space5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalScreenPadding),
            separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
            itemCount: 7,
            itemBuilder: (context, index) {
              return index == 5 || index == 6
                  ? Column(
                      children: [
                        spaceDown(Dimensions.space20),
                        ListTile(
                          tileColor: MyColor.white,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyShimmerWidget(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: MyColor.getBodyTextColor(),
                                    borderRadius: BorderRadius.circular(Dimensions.space5),
                                  ),
                                ),
                              ),
                              spaceDown(Dimensions.space10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyShimmerWidget(
                                    child: Container(
                                      height: 25,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        color: MyColor.getBodyTextColor(),
                                        borderRadius: BorderRadius.circular(Dimensions.space5),
                                      ),
                                    ),
                                  ),
                                  spaceDown(Dimensions.space20),
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
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListTile(
                      tileColor: MyColor.white,
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyShimmerWidget(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: MyColor.getBodyTextColor(),
                                borderRadius: BorderRadius.circular(Dimensions.space5),
                              ),
                            ),
                          ),
                          spaceSide(Dimensions.space10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyShimmerWidget(
                                child: Container(
                                  height: 25,
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
                                  height: 15,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: MyColor.getBodyTextColor(),
                                    borderRadius: BorderRadius.circular(Dimensions.space5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
