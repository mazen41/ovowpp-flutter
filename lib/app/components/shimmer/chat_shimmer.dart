import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemCount: 10,
      reverse: true,
      itemBuilder: (context, index) {
        bool isSender = index % 2 == 0;
        return Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              isSender
                  ? Expanded(
                      child: MyShimmerWidget(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                        ),
                      ),
                    )
                  : SizedBox(),
              spaceSide(Dimensions.space10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: MyShimmerWidget(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isSender ? 12 : 0),
                        bottomRight: Radius.circular(isSender ? 0 : 12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 150.w, height: 12.h, color: MyColor.white),
                        SizedBox(height: 8.h),
                        Container(width: 100.w, height: 10.h, color: MyColor.white),
                        SizedBox(height: 4.h),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(width: 50.w, height: 8.h, color: MyColor.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              spaceSide(Dimensions.space10),
              !isSender
                  ? Expanded(
                      child: MyShimmerWidget(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(color: MyColor.getBodyTextColor(), shape: BoxShape.circle),
                        ),
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
