import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/utils/validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final AuthController authController = Get.find();

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
                  child: Form(
                    key: authController.changePasswordFormKey,
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
                          validator: (p0) => AppValidator.validateEmptyText(
                            fieldName: 'Password',
                            value: p0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextField(
                          hintText: 'Re-Enter your New Password',
                          controller: authController.confirmPasswordController,
                          validator: (p0) => AppValidator.validateEmptyText(
                            fieldName: 'Confirm Password',
                            value: p0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Obx(
                          () => CustomAuthButton(
                            isLoading: authController.isLoading.value,
                            text: 'Change Password',
                            onTap: () {
                              if (authController
                                  .changePasswordFormKey.currentState!
                                  .validate()) {
                                if (authController.passwordController.text
                                        .trim() !=
                                    authController
                                        .confirmPasswordController.text
                                        .trim()) {
                                  MySnackBarsHelper.showMessage(
                                      'Password Mismatch',
                                      'New and Confirm Password should be same',
                                      Icons.error);
                                } else {
                                  authController.changePassword();
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
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
