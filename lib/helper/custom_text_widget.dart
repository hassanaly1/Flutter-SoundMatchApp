import 'package:flutter/material.dart';
import 'package:sound_app/helper/colors.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final String? fontFamily;
  final bool isShadow;
  final List<Shadow>? shadow;
  final int? maxLines;

  const CustomTextWidget(
      {super.key,
      required this.text,
      this.textColor,
      this.textAlign,
      this.fontSize,
      this.shadow,
      this.isShadow = false,
      this.fontFamily,
      this.maxLines,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: fontFamily ?? 'Poppins',
        fontSize: fontSize ?? 12,
        fontWeight: fontWeight ?? FontWeight.w300,
        color: textColor ?? Colors.white,
        shadows: isShadow
            ? shadow ??
                [
                  const Shadow(
                    blurRadius: 15.0,
                    color: MyColorHelper.primaryColor,
                    offset: Offset(0, 0),
                  ),
                  const Shadow(
                    blurRadius: 15.0,
                    color: MyColorHelper.primaryColor,
                    offset: Offset(0, 0),
                  ),
                ]
            : null,
      ),
    );
  }
}
