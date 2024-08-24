import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/asset_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          MyAssetHelper.authBackground,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.black,
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
