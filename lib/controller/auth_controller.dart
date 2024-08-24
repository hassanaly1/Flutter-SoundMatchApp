import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/utils/toast.dart';
import 'package:sound_app/view/auth/change_password.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/auth/otp.dart';
import 'package:sound_app/view/auth/verify_email.dart';
import 'package:sound_app/view/home_screen.dart';

class AuthController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;

  // Form keys
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  // TextEditingControllers for form inputs
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController verifyEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final AuthService authService = AuthService();

  // void saveUserInfo(Map<String, dynamic> userInfo) {
  //   MyAppStorage.storage.write('user_info', userInfo);
  // }

  //Calling Apis Methods.

  // RegisterUser
  Future<void> registerUser() async {
    if (signupFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
        // Call the registerUser method in AuthService and handle the response
        Map<String, dynamic> response = await authService.registerUser(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
        );

        // Handle registration success and failure
        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
            message: 'Account Created Successfully, Please Verify your Email',
            backgroundColor: Colors.green,
          );
          Get.to(() => OtpScreen(
                verifyOtpForForgetPassword: false,
                email: emailController.text.trim(),
              ));
        } else if (response['message'] == 'Email already exists') {
          ToastMessage.showToastMessage(
            message: 'Email Already Registered, Please Login',
            backgroundColor: Colors.green,
          );
          Get.offAll(() => const LoginScreen(),
              transition: Transition.leftToRight);
        } else {
          ToastMessage.showToastMessage(
              message: 'Something went wrong, please try again.');
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message:
                'Something went wrong during Registration, please try again.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //verifyEmail
  Future<void> verifyEmail() async {
    debugPrint(verifyEmailController.text);
    debugPrint(otpController.text);
    if (emailController.text.isNotEmpty && otpController.text.isNotEmpty) {
      isLoading.value = true;

      try {
        Map<String, dynamic> response = await authService.verifyEmail(
          email: emailController.text.trim(),
          otp: otpController.text.trim(),
        );

        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
            message: 'Email Verified Successfully',
            backgroundColor: Colors.green,
          );
          Get.offAll(() => const LoginScreen());
          clearAllControllers();
        } else {
          ToastMessage.showToastMessage(
              message: 'InCorrect Otp, Please Enter Correct Otp');
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'Something went wrong during Email Verification');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //loginUser
  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true;

      try {
        Map<String, dynamic> response = await authService.loginUser(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
            message: 'Login Successfully.',
            backgroundColor: Colors.green,
          );
          MyAppStorage.storage.write('token', response['token']);

          // saveUserInfo(response['user']);
          final userInfo = response['user'];
          MyAppStorage.storage.write('user_info', userInfo);
          debugPrint(
              'TokenAtStorageAtLogin: ${MyAppStorage.storage.read('token')}');
          debugPrint(
              'UserAtStorageAtLogin: ${MyAppStorage.storage.read('user_info')}');
          GuestController().isGuestUser.value = false;
          Get.offAll(() => const HomeScreen(), transition: Transition.zoom);

          clearAllControllers();
        } else {
          response['message'] == 'Please Verify Your Email First'
              ? Get.to(() => VerifyEmailScreen(),
                  transition: Transition.rightToLeft)
              : null;
          ToastMessage.showToastMessage(message: response['message']);
          // Get.offAll(() => OtpScreen(email: emailController.text.trim()));
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //sendOtp
  Future<void> sendOtp() async {
    if (emailController.text.isNotEmpty) {
      isLoading.value = true;

      try {
        final bool isSuccess = await authService.sendOtp(
          email: emailController.text.trim(),
        );

        if (isSuccess) {
          ToastMessage.showToastMessage(
            message: 'Otp Sent Successfully, Check your Email',
            backgroundColor: Colors.green,
          );

          Get.to(() => OtpScreen(
                verifyOtpForForgetPassword: true,
                email: emailController.text.trim(),
              ));

          // clearAllControllers();
        } else {
          ToastMessage.showToastMessage(
              message: 'Something went wrong, please try again.');
        }
      } on SocketException {
        ToastMessage.showToastMessage(
          message:
              'No Internet connection. Please check your internet connection.',
          backgroundColor: Colors.red,
        );
      } on TimeoutException {
        ToastMessage.showToastMessage(
          message: 'The request timed out. Please try again later.',
          backgroundColor: Colors.red,
        );
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //verifyOtp
  Future<void> verifyOtp() async {
    if (emailController.text.isNotEmpty && otpController.text.isNotEmpty) {
      isLoading.value = true;
      print(emailController.text.trim());
      print(otpController.text.trim());

      try {
        Map<String, dynamic> response = await authService.verifyOtp(
          email: emailController.text.trim(),
          otp: otpController.text.trim(),
        );

        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
            message: 'Otp Verified Successfully',
            backgroundColor: Colors.green,
          );
          // Accessing the token correctly
          String token = response['data'][0]['token'];
          MyAppStorage.storage.write('token', token);
          Get.offAll(() => ChangePasswordScreen());

          clearAllControllers();
        } else {
          ToastMessage.showToastMessage(
              message: 'Invalid Otp', backgroundColor: Colors.red);
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again.');
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

      try {
        Map<String, dynamic> response = await authService.changePassword(
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
        );
        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
            message: 'Password Changed Successfully, Please Login Again',
            backgroundColor: Colors.green,
          );
          Get.offAll(() => const LoginScreen());
          clearAllControllers();
        } else {
          ToastMessage.showToastMessage(
              message: 'Something went wrong, please try again.');
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message:
                'Something went wrong during Changing Password, please try again.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  clearAllControllers() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    otpController.clear();
    verifyEmailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
