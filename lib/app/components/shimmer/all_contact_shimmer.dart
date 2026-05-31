import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class AllContactShimmer extends StatefulWidget {
  final bool isContactList;
  final bool isViewContactList;
  final bool isViewContactTagList;
  const AllContactShimmer({
    super.key,
    this.isContactList = false,
    this.isViewContactList = false,
    this.isViewContactTagList = false,
  });

  @override
  State<AllContactShimmer> createState() => _AllContactShimmerState();
}

class _AllContactShimmerState extends State<AllContactShimmer> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => spaceDown(Dimensions.space10),
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.all(0),
          tileColor: MyColor.getTransparentColor(),
          leading: !widget.isContactList
              ? MyShimmerWidget(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                  ),
                )
              : null,
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
              !widget.isViewContactTagList
                  ? MyShimmerWidget(
                      child: Container(
                        height: 15,
                        width: 150,
                        decoration: BoxDecoration(
                          color: MyColor.getBodyTextColor(),
                          borderRadius: BorderRadius.circular(Dimensions.space5),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyShimmerWidget(
                child: Container(
                  height: 20,
                  width: 30,
                  decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                ),
              ),
              spaceDown(!widget.isViewContactList ? Dimensions.space10 : 0),
              !widget.isViewContactList
                  ? MyShimmerWidget(
                      child: Container(
                        height: 20,
                        width: 30,
                        decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                      ),
                    )
                  : SizedBox(),
              spaceDown(!widget.isViewContactList ? Dimensions.space10 : 0),
              !widget.isViewContactList
                  ? MyShimmerWidget(
                      child: Container(
                        height: 20,
                        width: 30,
                        decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
