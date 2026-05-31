import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/shimmer/my_shimmer_widget.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ListTile(
                leading: MyShimmerWidget(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyShimmerWidget(child: Container(height: 14, width: 120, color: Colors.grey)),
                    const SizedBox(height: 8),
                    MyShimmerWidget(child: Container(height: 12, width: 200, color: Colors.grey)),
                  ],
                ),
              ),
            );
          }, childCount: 10),
        ),
      ],
    );
  }
}
