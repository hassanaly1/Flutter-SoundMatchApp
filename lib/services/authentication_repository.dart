import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sound_app/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:sound_app/utils/exceptions/firebase_exceptions.dart';
import 'package:sound_app/utils/exceptions/platform_exceptions.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/auth/onboarding/onboarding_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final storage = GetStorage();
  final _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    screenRedirect();
  }

  screenRedirect() async {
    //LocalStorage
    storage.writeIfNull('isFirstTime', true);
    debugPrint(storage.read('isFirstTime'));
    storage.read('isFirstTime') != true
        ? Get.offAll(const LoginScreen())
        : Get.offAll(const OnBoardingScreen());
  }

  //LOGIN
  //REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FormatException('Invalid format').message;
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
