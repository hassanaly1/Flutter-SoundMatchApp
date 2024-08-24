import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

import 'colors.dart';

class CreateAccountPopup extends StatelessWidget {
  final double? opacity;
  final String text;
  final String buttonText;
  final String imagePath;
  final VoidCallback onTap;
  final bool isSvg;

  const CreateAccountPopup(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.buttonText,
      this.opacity,
      required this.isSvg,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity!,
      duration: const Duration(seconds: 1),
      child: Container(
        height: context.height * 0.5,
        width: context.width,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: MyColorHelper.tabColor.withOpacity(0.7),
            border: Border.all(color: MyColorHelper.white)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSvg
                ? Image.asset(imagePath, height: context.height * 0.2)
                : Image.asset(imagePath, height: context.height * 0.2),
            CustomTextWidget(
              text: text,
              fontSize: 12.0,
              textColor: Colors.white60,
              textAlign: TextAlign.center,
              maxLines: 3,
              fontWeight: FontWeight.w600,
            ),
            Container(
              decoration: BoxDecoration(
                  color: MyColorHelper.blue,
                  borderRadius: BorderRadius.circular(12.0)),
              child: TextButton(
                  onPressed: onTap,
                  child: CustomTextWidget(
                    text: buttonText,
                    fontFamily: 'horta',
                    textColor: Colors.white,
                    fontSize: 22,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
