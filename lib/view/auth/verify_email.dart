import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/svgs/auth-background.svg',
            fit: BoxFit.cover,
          ),
          Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white70)),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset('assets/images/auth_logo.png',
                          fit: BoxFit.fill, height: 150),
                    ),
                    const SizedBox(height: 20.0),
                    const CustomTextWidget(
                      text: 'Verify Email',
                      fontSize: 30,
                      fontFamily: 'horta',
                      fontWeight: FontWeight.w700,
                      textColor: Colors.white70,
                    ),
                    const SizedBox(height: 10.0),
                    const CustomTextWidget(
                      text:
                          'Please provide your email address so we can send you the verification code.',
                      fontSize: 14,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      textColor: Colors.white54,
                    ),
                    const SizedBox(height: 15.0),
                    CustomTextField(
                      hintText: 'Enter your Email',
                      controller: authController.emailController,
                    ),
                    const SizedBox(height: 20.0),
                    Obx(
                      () => authController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white70),
                            )
                          : CustomAuthButton(
                              text: 'Send OTP',
                              onTap: () {
                                // Get.off(() => OtpScreen(
                                //     verifyOtpForForgetPassword: false,
                                //     email: authController.emailController.text
                                //         .trim()));
                                authController.sendOtp();
                              },
                            ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
