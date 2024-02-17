import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sound_app/controller/onboarding_controller.dart';
import 'package:sound_app/helper/custom_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/auth/login.dart';

class CustomOnboardingScreen extends StatelessWidget {
  final String text;
  final String subText;
  final String imageUrl;
  final List<Color> gradientColors;

  const CustomOnboardingScreen({
    Key? key,
    required this.text,
    required this.subText,
    required this.imageUrl,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnBoardingController onBoardingController = Get.find();

    return Scaffold(
      body: Container(
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: context.height * 0.02),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                isSemanticButton: true,
                onPressed: () {
                  onBoardingController.skip();
                },
                child: CustomTextWidget(
                  text: 'Skip',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: context.height * 0.05),
            Image.asset(
              imageUrl,
              height: 150,
            ),
            SizedBox(height: context.height * 0.05),
            CustomTextWidget(
              text: text,
              fontSize: 30.0,
              fontFamily: 'horta',
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomTextWidget(
                text: subText,
                fontSize: 12.0,
                fontFamily: 'poppins',
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.justify,
                maxLines: 10,
                textColor: Colors.black87,
              ),
            ),
            const Spacer(),
            Obx(
              () => AnimatedSmoothIndicator(
                count: onBoardingController.pages.length,
                activeIndex: onBoardingController.currentPage.value,
                effect: const WormEffect(
                  dotWidth: 15,
                  dotHeight: 15,
                  activeDotColor: Color(0xff272727),
                ),
              ),
            ),
            SizedBox(height: context.height * 0.05),
            CustomButton(
              width: context.width * 0.5,
              buttonText: onBoardingController.currentPage.value ==
                      onBoardingController.pages.length - 1
                  ? 'Get Started'
                  : 'NEXT',
              onTap: () {
                if (onBoardingController.currentPage.value ==
                    onBoardingController.pages.length - 1) {
                  final storage = GetStorage();
                  storage.write('isFirstTime', false);
                  print(storage.read('isFirstTime'));
                  Get.offAll(() => const LoginScreen(),
                      transition: Transition.rightToLeft);
                } else {
                  onBoardingController.animateToNextSlide();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
