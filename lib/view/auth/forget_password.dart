import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/utils/validator.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final AuthController authController = Get.find();
  final _validationKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              MyAssetHelper.authBackground,
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
                        text: 'Forget Password?',
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
                      Form(
                        key: _validationKey,
                        child: CustomTextField(
                          hintText: 'Enter your Email',
                          controller: authController.emailController,
                          validator: (p0) =>
                              AppValidator.validateEmail(value: p0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Obx(
                        () => CustomAuthButton(
                          isLoading: authController.isLoading.value,
                          text: 'Send OTP',
                          onTap: () {
                            if (_validationKey.currentState!.validate()) {
                              authController.sendOtp();
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
