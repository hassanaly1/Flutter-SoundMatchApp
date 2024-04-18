import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/view/auth/change_password.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/auth/otp.dart';
import 'package:sound_app/view/auth/verify_email.dart';
import 'package:sound_app/view/home_screen.dart';

class AuthController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  RxBool showPassword = false.obs;

  // Form keys
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // TextEditingControllers for form inputs
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController verifyEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  // TextEditingController forgetPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final storage = GetStorage();

  //Calling Apis Methods.

  // RegisterUser
  Future<void> registerUser() async {
    if (signupFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      // Print the first and last name
      debugPrint('First Name: ${firstNameController.text.trim()}');
      debugPrint('Last Name: ${lastNameController.text.trim()}');
      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('Password: ${passwordController.text.trim()}');
      debugPrint('Confirm Password: ${confirmPasswordController.text.trim()}');

      try {
        // Call the registerUser method in AuthService and handle the response
        Map<String, dynamic> response = await AuthService().registerUser(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            confirmPassword: confirmPasswordController.text.trim());

        // Handle registration success and failure
        if (response['status'] == 'success') {
          Fluttertoast.showToast(msg: response['message']);
          Get.to(() => OtpScreen(
                verifyOtpForForgetPassword: false,
                email: emailController.text.trim(),
              ));
          // if response['status'] == 'error'
        } else {
          Fluttertoast.showToast(msg: response['message']);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'An error occurred during registration');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //verifyEmail
  Future<void> verifyEmail() async {
    if (emailController.text.isNotEmpty && otpController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('OTP: ${otpController.text.trim()}');

      try {
        Map<String, dynamic> response = await AuthService().verifyEmail(
          email: emailController.text.trim(),
          otp: otpController.text.trim(),
        );

        if (response['status'] == 'success') {
          Fluttertoast.showToast(msg: response['message']);
          Get.offAll(() => const LoginScreen());
        } else {
          Fluttertoast.showToast(msg: response['message']);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'An error occurred during email verification');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //loginUser
  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('Password: ${passwordController.text.trim()}');

      try {
        Map<String, dynamic> response = await AuthService().loginUser(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (response['status'] == 'success') {
          Fluttertoast.showToast(msg: response['message']);
          storage.write('token', response['token']);
          debugPrint('TokenAtStorage: ${storage.read('token')}');
          Get.offAll(() => const HomeScreen(), transition: Transition.zoom);
        } else {
          response['message'] == 'Please Verify Your Email First'
              ? Get.to(() => const VerifyEmailScreen(),
                  transition: Transition.rightToLeft)
              : null;
          Fluttertoast.showToast(msg: response['message']);
          // Get.offAll(() => OtpScreen(email: emailController.text.trim()));
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong, please try again.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //sendOtp
  Future<void> sendOtp() async {
    if (emailController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Email: ${emailController.text.trim()}');

      try {
        Map<String, dynamic> response = await AuthService().sendOtp(
          email: emailController.text.trim(),
        );

        if (response['status'] == 'success') {
          Fluttertoast.showToast(msg: response['message']);

          Get.to(() => OtpScreen(
                verifyOtpForForgetPassword: true,
                email: emailController.text.trim(),
              ));
        } else {
          Fluttertoast.showToast(msg: response['message']);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong, please try again.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //verifyOtp
  Future<void> verifyOtp() async {
    if (emailController.text.isNotEmpty && otpController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('OTP: ${otpController.text.trim()}');

      try {
        Map<String, dynamic> response = await AuthService().verifyOtp(
          email: emailController.text.trim(),
          otp: otpController.text.trim(),
        );

        if (response['status'] == 'success') {
          debugPrint('VERIFY OTP API CALLED SUCCESSFULLY');
          Fluttertoast.showToast(msg: response['message']);
          debugPrint('TokenReceived: ${response['data']['token']}');
          storage.write('token', response['data']['token']);
          debugPrint('TokenAtStorage: ${storage.read('token')}');
          Get.offAll(() => const ChangePasswordScreen());
        } else {
          Fluttertoast.showToast(msg: response['message']);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  //changePassword
  Future<void> changePassword() async {
    if (passwordController.text.isNotEmpty ==
        confirmPasswordController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Password: ${passwordController.text.trim()}');
      debugPrint('ConfirmPassword: ${confirmPasswordController.text.trim()}');

      try {
        Map<String, dynamic> response = await AuthService().changePassword(
            password: passwordController.text.trim(),
            confirmPassword: confirmPasswordController.text.trim(),
            token: storage.read('token'));

        if (response['status'] == 'success') {
          Fluttertoast.showToast(msg: response['message']);
          Get.offAll(() => const HomeScreen());
        } else {
          Fluttertoast.showToast(msg: response['message']);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'An error occurred during changing password');
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
