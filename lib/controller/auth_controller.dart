import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/utils/storage_helper.dart';
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
        Map<String, dynamic> response = await authService.registerUser(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
        );

        if (response['status'] == 'success') {
          MySnackBarsHelper.showMessage(
              'Please Verify your Email',
              'Account Created Successfully',
              CupertinoIcons.checkmark_alt_circle);
          Get.to(() => OtpScreen(
                verifyOtpForForgetPassword: false,
                email: emailController.text.trim(),
              ));
        } else if (response['message'] == 'Email already exists') {
          MySnackBarsHelper.showError(
              'Email Already Registered', 'Please Login', Icons.error);
          Get.offAll(() => const LoginScreen(),
              transition: Transition.leftToRight);
        } else {
          MySnackBarsHelper.showError(
              'Please try again.', 'Something went wrong', Icons.error);
        }
      } catch (e) {
        MySnackBarsHelper.showError('Please try again.',
            'Something went wrong during Registration', Icons.error);
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
          MySnackBarsHelper.showMessage('Email Verified Successfully',
              'Please Login', CupertinoIcons.checkmark_alt_circle);
          Get.offAll(() => const LoginScreen());
          clearAllControllers();
        } else {
          MySnackBarsHelper.showError('Please Enter Correct Otp & try again.',
              'InCorrect Otp', Icons.error);
        }
      } catch (e) {
        MySnackBarsHelper.showError('Please try again.',
            'Something went wrong during Email Verification', Icons.error);
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
          MySnackBarsHelper.showMessage('Welcome Back!', 'Login Successfully.',
              CupertinoIcons.checkmark_alt_circle);
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
              ? Get.to(() => const VerifyEmailScreen(),
                  transition: Transition.rightToLeft)
              : null;
          MySnackBarsHelper.showError(
              'Enter your email so that we can send you a Otp',
              'Please Verify Your Email First',
              Icons.error);
        }
      } catch (e) {
        MySnackBarsHelper.showError('Please try again.',
            'Something went wrong during Login.', Icons.error);
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
          MySnackBarsHelper.showMessage('Otp Sent Successfully',
              'Please Check your Email', CupertinoIcons.checkmark_alt_circle);

          Get.to(() => OtpScreen(
                verifyOtpForForgetPassword: true,
                email: emailController.text.trim(),
              ));

          // clearAllControllers();
        } else {
          MySnackBarsHelper.showError('Please try again.',
              'Something went wrong during Sending Otp.', Icons.error);
        }
      } on SocketException {
        MySnackBarsHelper.showError('Please Check your Internet Connection.',
            'No Internet Connection.', Icons.error);
      } on TimeoutException {
        MySnackBarsHelper.showError(
            'Please try again.', 'The Request Timed Out.', Icons.error);
      } catch (e) {
        MySnackBarsHelper.showError('Please try again.',
            'Something went wrong during Sending Otp.', Icons.error);
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
          MySnackBarsHelper.showMessage(
              'Please Enter New Password And Confirm It.',
              'Otp Verified Successfully.',
              CupertinoIcons
                  .checkmark_alt_circle); // Accessing the token correctly
          String token = response['data'][0]['token'];
          MyAppStorage.storage.write('token', token);
          Get.offAll(() => const ChangePasswordScreen());

          clearAllControllers();
        } else {
          MySnackBarsHelper.showError('Please Enter Correct Otp & try again.',
              'InCorrect Otp', Icons.error);
        }
      } catch (e) {
        MySnackBarsHelper.showError('Please try again.',
            'Something went wrong during OTP Verification', Icons.error);
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
          MySnackBarsHelper.showMessage(
              ' Please Login Again.',
              'Password Changed Successfully.',
              CupertinoIcons.checkmark_alt_circle);
          Get.offAll(() => const LoginScreen());
          clearAllControllers();
        } else {
          MySnackBarsHelper.showError('Please try again.',
              'Something went wrong during Changing Password', Icons.error);
        }
      } catch (e) {
        MySnackBarsHelper.showError('Please try again.',
            'Something went wrong during Changing Password', Icons.error);
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
