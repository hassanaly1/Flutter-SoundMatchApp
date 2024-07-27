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
        Map<String, dynamic> response = await AuthService().registerUser(
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
        Map<String, dynamic> response = await AuthService().verifyEmail(
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
        Map<String, dynamic> response = await AuthService().loginUser(
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
          GuestController().isGuestUser.value = false;
          Get.offAll(() => const HomeScreen(), transition: Transition.zoom);

          clearAllControllers();
        } else {
          response['message'] == 'Please Verify Your Email First'
              ? Get.to(() => const VerifyEmailScreen(),
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
        final bool isSuccess = await AuthService().sendOtp(
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
        Map<String, dynamic> response = await AuthService().verifyOtp(
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
          Get.offAll(() => const ChangePasswordScreen());

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
        Map<String, dynamic> response = await AuthService().changePassword(
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
        );
        print(response);
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

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    verifyEmailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
