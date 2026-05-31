import 'package:flutter/material.dart';

import '../../../components/shimmer/my_shimmer_widget.dart';

class ChatHomeShimmer extends StatelessWidget {
  const ChatHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    MyShimmerWidget(
                      child: Container(
                        height: 20,
                        width: 120,
                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyShimmerWidget(
                      child: Container(
                        height: 14,
                        width: 200,
                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyShimmerWidget(
                      child: Container(
                        height: 14,
                        width: 40,
                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyShimmerWidget(
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                      ),
                    ),
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
