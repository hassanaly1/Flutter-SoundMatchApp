import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
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
                        text: 'Change Password',
                        fontSize: 30,
                        fontFamily: 'horta',
                        fontWeight: FontWeight.w700,
                        textColor: Colors.white70,
                      ),
                      const SizedBox(height: 10.0),
                      const CustomTextWidget(
                        text:
                            'Please enter the strong password for your Account.',
                        fontSize: 14,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        textColor: Colors.white54,
                      ),
                      const SizedBox(height: 15.0),
                      CustomTextField(
                        hintText: 'Enter your New Password',
                        controller: authController.passwordController,
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        hintText: 'Re-Enter your New Password',
                        controller: authController.confirmPasswordController,
                      ),
                      const SizedBox(height: 20.0),
                      Obx(
                        () => CustomAuthButton(
                          isLoading: authController.isLoading.value,
                          text: 'Change Password',
                          onTap: () {
                            if (authController.passwordController.text.trim() !=
                                authController.confirmPasswordController.text
                                    .trim()) {
                              Fluttertoast.showToast(
                                  msg: 'Passwords do not match.');
                            } else {
                              authController.changePassword();
                            }
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
      ),
    );
  }
}
