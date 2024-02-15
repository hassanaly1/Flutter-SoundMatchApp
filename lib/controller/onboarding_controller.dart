import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/onboarding/onboarding_page_widget.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    CustomOnboardingScreen(
      gradientColors: [
        const Color(0xff6A6DD8).withOpacity(0.5),
        const Color(0xff5AB9C1).withOpacity(0.5),
      ],
      text: 'Record & Relate',
      subText:
          'Unleash your voice\'s potential! Record 2-3 second sound clips, showcasing the uniqueness of your voice. Our advanced matching algorithm will astound you with its accuracy.',
      imageUrl: MyAssetHelper.onboardingOne,
    ),
    CustomOnboardingScreen(
      gradientColors: [
        const Color(0xff5D84C6).withOpacity(0.6),
        const Color(0xffA184F4).withOpacity(0.6),
      ],
      text: 'Analyzing Voice',
      subText:
          'Witness the power of comparison! Upload pre-recorded voice/sound and let our system analyze the similarity. Get ready to appreciate the intricacies of your voice with scores out of 100 for each challenge.',
      imageUrl: MyAssetHelper.onboardingTwo,
    ),
    CustomOnboardingScreen(
      gradientColors: [
        const Color(0xff3B7EA8).withOpacity(0.5),
        const Color(0xff73AF9A).withOpacity(0.5),
      ],
      text: 'Starting a New Game',
      subText:
          'Create your playground! Design an intuitive interface for starting new games and customize game parameters like rounds and sound packs',
      imageUrl: MyAssetHelper.onboardingThree,
    ),
    CustomOnboardingScreen(
      gradientColors: [
        const Color(0xffACECFF).withOpacity(0.5),
        const Color(0xff227E81).withOpacity(0.8),
      ],
      text: 'Interactive Voice Challenges',
      subText:
          '\u2022 Record your unique voice clips.\n\u2022 Upload pre-recorded sounds for challenges.\n\u2022 Engage in thrilling voice challenges.\n\u2022 Discover your scores out of 100.\n\u2022 Press "Get Started" and let the vocal fun begin!',
      imageUrl: MyAssetHelper.onboardingFour,
    )
  ];

  skip() {
    controller.jumpToPage(page: pages.length - 1);
  }

  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    if (nextPage < pages.length) {
      controller.animateToPage(page: nextPage);
    } else {
      Get.offAll(const LoginScreen(), transition: Transition.rightToLeft);
    }
  }

  onPageChangedCallback(int activePageIndex) =>
      currentPage.value = activePageIndex;
}
