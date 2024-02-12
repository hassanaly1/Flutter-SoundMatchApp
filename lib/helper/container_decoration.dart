import 'package:flutter/material.dart';

class MyDecorationHelper {
  static BoxDecoration customBoxDecoration({
    Color? color,
    BorderRadiusGeometry? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white.withOpacity(0.50),
      borderRadius: borderRadius ?? BorderRadius.circular(16.0),
      boxShadow: boxShadow ?? [],
    );
  }
}
