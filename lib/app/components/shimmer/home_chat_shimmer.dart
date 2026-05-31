import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class HomeChatListShimmer extends StatefulWidget {
  const HomeChatListShimmer({super.key});

  @override
  State<HomeChatListShimmer> createState() => _HomeChatListShimmerState();
}

class _HomeChatListShimmerState extends State<HomeChatListShimmer> {
  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      showAppBar: false,
      padding: EdgeInsets.all(0),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              primary: true,
              separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: MyColor.getTransparentColor(),
                  leading: MyShimmerWidget(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                    ),
                  ),
                  title: Column(
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
                    ],
                  ),
                  trailing: Column(
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
