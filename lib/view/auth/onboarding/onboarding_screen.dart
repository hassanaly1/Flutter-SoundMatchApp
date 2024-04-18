import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:sound_app/controller/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingController = Get.put(OnBoardingController());

    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            LiquidSwipe(
              pages: onboardingController.pages,
              enableSideReveal: false,
              currentUpdateTypeCallback: (updateType) => updateType,
              liquidController: onboardingController.controller,
              slideIconWidget: const Icon(Icons.arrow_forward_ios_rounded),
              enableLoop: false,
              waveType: WaveType.liquidReveal,
              onPageChangeCallback: (page) {
                onboardingController.onPageChangedCallback(page);
              },
            ),
          ],
        ),
      ),
    );
  }
}
