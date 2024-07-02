import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/auth/onboarding/onboarding_screen.dart';
import 'package:sound_app/view/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFirstTime = storage.read('isFirstTime') ?? true;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyColorHelper.blue),
        useMaterial3: true,
      ),
      home: isFirstTime == true
          ? const OnBoardingScreen()
          : storage.read('token') != null
              ? const HomeScreen()
              : const LoginScreen(),
    );
  }
}
