import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/controller/signup_controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_social_icon.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/utils/validator.dart';
import 'package:sound_app/view/auth/login.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
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
                        InkWell(
                          onTap: () {
                            Get.offAll(() => const LoginScreen(),
                                transition: Transition.leftToRight);
                          },
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.transparent,
                              shape: CircleBorder(),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          width: context.width * 0.3,
                          decoration: BoxDecoration(
                            color: MyColorHelper.verdigris.withOpacity(0.7),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(22.0),
                              bottomLeft: Radius.circular(22.0),
                            ),
                          ),
                          child: Center(
                              child: InkWell(
                            onTap: () {
                              Get.to(() => const LoginScreen(),
                                  transition: Transition.rightToLeft);
                            },
                            child: CustomTextWidget(
                              text: 'Login',
                              fontSize: 22.0,
                              textColor: Colors.white,
                              fontFamily: 'poppins',
                            ),
                          )),
                        ),
                      ],
                    ),
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
                              controller: controller.nameController,
                              validator: (value) {
                                print('helllo');
                                return AppValidator.validateEmptyText(
                                    'Name', value);
                              },
                              hintText: 'Enter your Name'),
                          SizedBox(height: context.height * 0.02),
                          CustomTextField(
                              controller: controller.emailController,
                              validator: (value) =>
                                  AppValidator.validateEmail(value),
                              hintText: 'Enter your Email'),
                          SizedBox(height: context.height * 0.02),
                          Obx(
                            () => CustomTextField(
                              controller: controller.passwordController,
                              validator: (value) =>
                                  AppValidator.validatePassword(value),
                              hintText: 'Enter your Password',
                              obscureText: !controller.showPassword.value,
                              // suffixIcon: IconButton(
                              //   onPressed: () {
                              //     controller.showPassword.value =
                              //         !controller.showPassword.value;
                              //   },
                              //   icon: Icon(
                              //       controller.showPassword.value
                              //           ? CupertinoIcons.eye
                              //           : CupertinoIcons.eye_slash,
                              //       color: MyColorHelper.verdigris),
                              // ),
                            ),
                          ),
                          SizedBox(height: context.height * 0.03),
                          //Button
                          CustomAuthButton(
                            text: 'Register',
                            onTap: () => controller.signUp(),
                            // onTap: () {
                            //
                            //   // Get.offAll(() => const LoginScreen(),
                            //   //     transition: Transition.downToUp);
                            //   // controller.isGuestUser.value = false;
                            //   // debugPrint('Login as RegisteredUser');
                            //   // MySnackBarsHelper.showMessage(
                            //   //     "Successfully",
                            //   //     "Account Created",
                            //   //     CupertinoIcons.check_mark_circled);
                            // },
                          ),
                          SizedBox(height: context.height * 0.02),
                        ],
                      ),
                    ),
                  ),

                  CustomTextWidget(
                    text: 'Or Register with',
                    fontWeight: FontWeight.w600,
                    textColor: Colors.white60,
                    fontFamily: 'poppins',
                  ),
                  SizedBox(height: context.height * 0.02),
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSocialIcon(
                            imagePath: 'assets/images/google-icon.png'),
                        CustomSocialIcon(
                            imagePath: 'assets/images/facebook-icon.png'),
                        CustomSocialIcon(
                            imagePath: 'assets/images/apple-icon.png'),
                      ],
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
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

                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
