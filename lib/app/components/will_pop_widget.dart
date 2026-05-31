import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'dialog/exit_dialog.dart';

class WillPopWidget extends StatelessWidget {
  final Widget child;
  final String nextRoute;

  const WillPopWidget({super.key, required this.child, this.nextRoute = ''});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Schedule the dialog/navigation immediately
        Future.delayed(Duration.zero, () {
          if (nextRoute.trim().isEmpty) {
            showExitDialog();
          } else {
            Get.offAndToNamed(nextRoute);
          }
        });
      },
      child: child,
    );
  }
}
