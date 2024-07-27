import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // SvgPicture.asset(
        //   'assets/svgs/auth-background.svg',
        //   fit: BoxFit.cover,
        // ),
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
