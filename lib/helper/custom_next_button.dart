import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class CustomAuthButton extends StatelessWidget {
  final VoidCallback onTap;
  const CustomAuthButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: context.width * 0.5,
        decoration: const BoxDecoration(
            color: MyColorHelper.verdigris,
            borderRadius: BorderRadius.all(Radius.circular(22.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: CustomTextWidget(
                text: text,
                fontSize: 20.0,
                fontFamily: 'poppins',
                textColor: Colors.white70,
              ),
            ),
            Container(
              width: 70,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white70.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(22.0),
                  bottomRight: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
              ),
              child: const Icon(
                CupertinoIcons.arrow_right,
                color: Colors.white70,
              ),
            )
          ],
        ),
      ),
    );
  }
}
