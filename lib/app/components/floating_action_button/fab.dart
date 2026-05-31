import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class FAB extends StatelessWidget {
  final Callback callback;
  final IconData icon;

  const FAB({super.key, required this.callback, this.icon = Icons.add});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: FloatingActionButton(
          onPressed: callback,
          backgroundColor: MyColor.getPrimaryColor(),
          child: Icon(icon, color: MyColor.white),
        ),
      ),
    );
  }
}
