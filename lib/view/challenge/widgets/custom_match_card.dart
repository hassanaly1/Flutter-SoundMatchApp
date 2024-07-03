import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/challenge_model.dart';

class CustomMatchCard extends StatelessWidget {
  final ChallengeModel challenge;
  final VoidCallback onTap;
  final int? index;

  const CustomMatchCard(
      {super.key, required this.challenge, required this.onTap, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SizedBox(
              height: context.height * 0.25,
              width: context.width * 0.8,
              child: Image.asset(
                'assets/images/homeicon4.png',
              )),
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextWidget(
                    fontFamily: 'horta',
                    isShadow: true,
                    shadow: const [
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        blurRadius: 5.0,
                        color: MyColorHelper.primaryColor,
                        offset: Offset(0, 0),
                      ),
                    ],
                    text: challenge.challengeName!,
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0,
                    textColor: Colors.white,
                    maxLines: 1,
                  ),
                  Image.asset(
                    MyAssetHelper.onboardingTwo,
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
