import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/auth/otp.dart';
import 'package:sound_app/view/home_screen.dart';

class AuthController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  RxBool showPassword = false.obs;
  RxBool isGuestUser = false.obs;

  // Form keys
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // TextEditingControllers for form inputs
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  // Method to register the user
  Future<void> registerUser() async {
    if (signupFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      // Print the first and last name
      print('First Name: ${firstNameController.text.trim()}');
      print('Last Name: ${lastNameController.text.trim()}');
      print('Email: ${emailController.text.trim()}');
      print('Password: ${passwordController.text.trim()}');
      print('Confirm Password: ${confirmPasswordController.text.trim()}');

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
          Get.to(() => OtpScreen(email: emailController.text.trim()));
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

  // Method to verify email using OTP
  Future<void> verifyEmail() async {
    if (emailController.text.isNotEmpty && otpController.text.isNotEmpty) {
      isLoading.value = true;
      print('Email: ${emailController.text.trim()}');
      print('OTP: ${otpController.text.trim()}');

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
  } // Method to verify email using OTP

  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true;
      print('Email: ${emailController.text.trim()}');
      print('Password: ${passwordController.text.trim()}');

      try {
        Map<String, dynamic> response = await AuthService().loginUser(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (response['status'] == 'success') {
          Fluttertoast.showToast(msg: response['message']);

          Get.offAll(() => const HomeScreen());
        } else {
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

  @override
  void onClose() {
    // Dispose text controllers when widget is removed
    // firstNameController.dispose();
    // lastNameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    super.onClose();
  }
}
