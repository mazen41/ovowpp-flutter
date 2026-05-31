import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class PrivacyPolicyShimmer extends StatefulWidget {
  const PrivacyPolicyShimmer({super.key});

  @override
  State<PrivacyPolicyShimmer> createState() => _PrivacyPolicyShimmerState();
}

class _PrivacyPolicyShimmerState extends State<PrivacyPolicyShimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: MyShimmerWidget(
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      color: MyColor.getBodyTextColor(),
                      borderRadius: BorderRadius.circular(Dimensions.space10),
                    ),
                  ),
                ),
              ),
              spaceSide(Dimensions.space10),
              Expanded(
                flex: 2,
                child: MyShimmerWidget(
                  child: Container(
                    height: 30,
                    width: 150,
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
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: MyColor.getTransparentColor(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          width: 200,
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
        ],
      ),
    );
  }
}
