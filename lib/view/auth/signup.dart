import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/view/auth/login.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset('assets/svgs/auth-background.svg',
              fit: BoxFit.cover),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: context.height * 0.02),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white)),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              width: context.width * 0.3,
                              decoration: BoxDecoration(
                                color: MyColorHelper.verdigris.withOpacity(0.7),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(22.0),
                                  bottomLeft: Radius.circular(22.0),
                                ),
                              ),
                              child: Center(
                                  child: CustomTextWidget(
                                      text: 'Register',
                                      fontSize: 20.0,
                                      textColor: Colors.white,
                                      fontFamily: 'poppins')))
                        ]),
                  ),
                  Center(
                    child: Image.asset('assets/images/auth_logo.png',
                        fit: BoxFit.fill, height: 120),
                  ),
                  SizedBox(height: context.height * 0.02),
                  //TextFields
                  Form(
                    key: controller.signupFormKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextField(
                            controller: controller.firstNameController,
                            // validator: (value) => AppValidator.validateEmptyText(
                            //       'First Name', value),
                            hintText: ' First Name',
                          ),

                          SizedBox(height: context.height * 0.02),
                          CustomTextField(
                            controller: controller.lastNameController,
                            // validator: (value) => AppValidator.validateEmptyText(
                            //       'Last Name', value),
                            hintText: ' Last Name',
                          ),

                          SizedBox(height: context.height * 0.02),
                          CustomTextField(
                            controller: controller.emailController,
                            // validator: (value) =>
                            //     AppValidator.validateEmail(value),
                            hintText: ' Email',
                          ),
                          SizedBox(height: context.height * 0.02),
                          Obx(
                            () => CustomTextField(
                              controller: controller.passwordController,
                              // validator: (value) =>
                              //     AppValidator.validatePassword(value),
                              hintText: ' Password',
                              obscureText: !controller.showPassword.value,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.showPassword.value =
                                        !controller.showPassword.value;
                                  },
                                  icon: Icon(
                                      controller.showPassword.value
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash,
                                      color: MyColorHelper.verdigris)),
                            ),
                          ),
                          SizedBox(height: context.height * 0.02),
                          Obx(
                            () => CustomTextField(
                              controller: controller.confirmPasswordController,
                              // validator: (value) =>
                              //     AppValidator.validatePassword(value),
                              hintText: 'Confirm Password',
                              obscureText: !controller.showPassword.value,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.showPassword.value =
                                        !controller.showPassword.value;
                                  },
                                  icon: Icon(
                                      controller.showPassword.value
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash,
                                      color: MyColorHelper.verdigris)),
                            ),
                          ),
                          SizedBox(height: context.height * 0.03),
                          //Button
                          Obx(
                            () => controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Colors.white70,
                                  ))
                                : CustomAuthButton(
                                    text: 'Register',
                                    onTap: () => controller.registerUser(),
                                  ),
                          ),
                          SizedBox(height: context.height * 0.02),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => const LoginScreen(),
                          transition: Transition.rightToLeft);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an Account? ',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            fontSize: 12.0),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
