import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ovowpp/core/utils/my_color.dart';

Widget spinkit({Color? spinColor, double? size}) {
  return SpinKitCircle(color: spinColor ?? MyColor.getPrimaryColor(), size: size ?? 32.sp);
}
