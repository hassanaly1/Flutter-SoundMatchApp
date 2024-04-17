import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class CustomAuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? color;
  const CustomAuthButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          height: 60,
          // width: context.width * 0.5,
          decoration: BoxDecoration(
              color: color ?? MyColorHelper.verdigris.withOpacity(0.7),
              borderRadius: const BorderRadius.all(Radius.circular(22.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextWidget(
                  text: text,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  textAlign: TextAlign.center,
                  fontFamily: 'poppins',
                  textColor: Colors.white,
                ),
              ),
              Container(
                width: context.width * 0.2,
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
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
