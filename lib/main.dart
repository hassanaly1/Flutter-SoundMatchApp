import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/splash.dart';
import 'package:sound_app/view/challenge/challenge.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Initialize Get Storage
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyColorHelper.blue),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put(MyUniversalController());
      }),
    );
  }
}
