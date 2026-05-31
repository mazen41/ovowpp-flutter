import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final Color? circleColor;
  final Widget? child;
  final ValueChanged<bool> onChanged;
  final bool isLoading;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.circleColor = MyColor.white,
    this.child,
    this.isLoading = false,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    log(widget.value.toString());
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(color: MyColor.getPrimaryColor(), strokeWidth: 2),
          )
        : AnimatedBuilder(
            animation: _animationController!,
            builder: (context, child) {
              return GestureDetector(
                onTap: () {
                  if (_animationController!.isCompleted) {
                    _animationController!.reverse();
                  } else {
                    _animationController!.forward();
                  }
                  widget.value == false ? widget.onChanged(false) : widget.onChanged(true);
                },
                child: Container(
                  width: 45.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: widget.value ? MyColor.getPrimaryColor() : MyColor.switchOffColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 2.0, bottom: 2.0, start: 2.0, end: 2.0),
                    child: Container(
                      alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 22.0,
                        height: 22.0,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.circleColor),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
