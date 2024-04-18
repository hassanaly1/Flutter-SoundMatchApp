import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sound_app/view/auth/onboarding/onboarding_screen.dart';
import 'package:sound_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});
  final GetStorage storage = GetStorage();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Check if the JWT token is present in Get Storage
    String? token = widget.storage.read('token');

    Timer(const Duration(seconds: 2), () {
      if (token == null) {
        Get.offAll(() => const OnBoardingScreen(),
            transition: Transition.rightToLeft);
      } else {
        Get.offAll(() => const HomeScreen(),
            transition: Transition.rightToLeft);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/svgs/auth-background.svg',
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Image.asset(
              'assets/images/splash-logo.png',
              height: context.height * 0.3,
            ),
          ),
        ),
      ],
    );
  }
}
