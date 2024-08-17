import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/splash.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/auth/onboarding/onboarding_screen.dart';
import 'package:sound_app/view/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  // Initialize GetStorage and GetX controllers before using MyAppStorage
  await GetStorage.init();
  Get.put(GuestController());

  // Initialize MyAppStorage static fields
  MyAppStorage.initialize();
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
      home: AuthCheck(),
    );
  }
}

class AuthStatusCheckController extends GetxController {
  var isFirstTime = true.obs;
  var isTokenValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    isFirstTime.value = MyAppStorage.storage.read('isFirstTime') ?? true;
  }

  Future<void> _checkAuthState() async {
    var authResponse = await postAuthStateChange();
    bool tokenValid = authResponse['statusCode'] == 200;
    isTokenValid.value = tokenValid;

    if (!tokenValid && MyAppStorage.storage.read('token') != null) {
      _showSessionExpiredMessage();
    } else if (tokenValid) {
      var user = authResponse['user'];
      var token = authResponse['token'];
      MyAppStorage.storage.write('user_info', user);
      MyAppStorage.storage.write('token', token);
      debugPrint('TokenAtStorage: ${MyAppStorage.storage.read('token')}');
      debugPrint('UserAtStorage: ${MyAppStorage.storage.read('user_info')}');
    }
  }

  void _showSessionExpiredMessage() {
    MySnackBarsHelper.showMessage(
      "Session Expired",
      "Your session has expired. Please log in again.",
      Icons.no_accounts_sharp,
    );
  }

  Future<void> checkAuthState() => _checkAuthState();
}

class AuthCheck extends StatelessWidget {
  final AuthStatusCheckController authController =
      Get.put(AuthStatusCheckController());

  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authController.checkAuthState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          if (authController.isFirstTime.value) {
            return const OnBoardingScreen();
          } else if (MyAppStorage.storage.read('token') != null &&
              authController.isTokenValid.value) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }
}

Future<Map<String, dynamic>> postAuthStateChange() async {
  var url =
      Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.onAuthStateChangeUrl}');
  var token = MyAppStorage.storage.read('token');
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  var response = await http.post(
    url,
    headers: headers,
  );

  debugPrint('StatusCode: ${response.statusCode} + ${response.reasonPhrase}');
  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    var user = responseBody['data'];
    var token = responseBody['token'];
    var statusCode = response.statusCode;
    return {
      'user': user,
      'token': token,
      'statusCode': statusCode,
    };
  } else if (response.statusCode == 402) {
    return {
      'user': null,
      'token': null,
      'statusCode': response.statusCode,
    };
  } else {
    return {
      'user': null,
      'token': null,
      'statusCode': response.statusCode,
    };
  }
}
