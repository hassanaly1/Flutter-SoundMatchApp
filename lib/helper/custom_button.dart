import 'package:flutter/material.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;
  final double width;
  final double? height;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.width = double.infinity,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: height ?? 40,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: buttonColor ?? MyColorHelper.caribbeanCurrent,
              border: Border.all(
                  color: borderColor ?? MyColorHelper.caribbeanCurrent)),
          child: Center(
              child: CustomTextWidget(
            text: buttonText,
            fontFamily: 'poppins',
            fontSize: 14,
            textColor: textColor ?? Colors.white,
            fontWeight: FontWeight.w500,
          ))),
    );
  }
}
