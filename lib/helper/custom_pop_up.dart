import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_app/controller/controller.dart';

import 'colors.dart';

class CustomPopUp extends StatelessWidget {
  final double opacity;
  final String text;
  final String lottiePath;
  const CustomPopUp(
      {super.key,
      required MyNewChallengeController myNewChallengeController,
      required this.lottiePath,
      required this.text,
      required this.opacity})
      : _myNewChallengeController = myNewChallengeController;

  final MyNewChallengeController _myNewChallengeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(seconds: 1),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        height: 270,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: MyColorHelper.tabColor.withOpacity(0.9),
            border: Border.all(color: MyColorHelper.white)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              lottiePath,
              height: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Horta',
                    color: MyColorHelper.white),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(textAlign: TextAlign.center, text),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
