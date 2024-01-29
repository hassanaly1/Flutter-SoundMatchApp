import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/helper/auth_textfield.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_social_icon.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/view/auth/forget_password.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/auth/signup.dart';
import 'package:sound_app/view/dashboard/home_screen.dart';

class AuthScreen extends StatelessWidget {
  final String text;
  final bool isLoginScreen;
  const AuthScreen(
      {super.key, required this.text, required this.isLoginScreen});

  @override
  Widget build(BuildContext context) {
    final AuthController authController =
        Get.put(AuthController(), permanent: true);
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
                        Visibility(
                          visible: !isLoginScreen,
                          child: InkWell(
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
                              isLoginScreen
                                  ? Get.offAll(() => const SignupScreen(),
                                      transition: Transition.rightToLeft)
                                  : Get.to(() => const LoginScreen(),
                                      transition: Transition.rightToLeft);
                            },
                            child: CustomTextWidget(
                              text: isLoginScreen ? 'Register' : 'Login',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                            visible: !isLoginScreen,
                            child: AuthTextField(
                                controller: authController.nameController,
                                hintText: 'Enter your Name')),
                        SizedBox(height: context.height * 0.02),
                        AuthTextField(
                            controller: authController.emailController,
                            hintText: 'Enter your Email'),
                        SizedBox(height: context.height * 0.02),
                        AuthTextField(
                            controller: authController.passwordController,
                            hintText: 'Enter your Password'),
                        Visibility(
                          visible: isLoginScreen,
                          child: TextButton(
                              isSemanticButton: true,
                              onPressed: () {
                                Get.to(() => const ForgetPasswordScreen(),
                                    transition: Transition.rightToLeft);
                              },
                              child: CustomTextWidget(
                                text: 'Forget Password?',
                                textColor: Colors.white60,
                                fontFamily: 'poppins',
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: !isLoginScreen ? context.height * 0.03 : 0),
                  //Button
                  CustomAuthButton(
                    text: text,
                    onTap: () {
                      !isLoginScreen
                          ? Get.offAll(() => const LoginScreen(),
                              transition: Transition.downToUp)
                          : Get.offAll(() => const HomeScreen(),
                              transition: Transition.downToUp);
                      authController.isGuestUser.value = false;
                      debugPrint('Login as RegisteredUser');
                      MySnackBarsHelper.showMessage(
                          "Successfully",
                          !isLoginScreen ? "Account Created" : "Login",
                          CupertinoIcons.check_mark_circled);
                    },
                  ),
                  SizedBox(height: context.height * 0.02),

                  CustomTextWidget(
                    text: 'Or $text with',
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
                      isLoginScreen
                          ? Get.to(() => const SignupScreen(),
                              transition: Transition.rightToLeft)
                          : Get.offAll(() => const LoginScreen(),
                              transition: Transition.rightToLeft);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: isLoginScreen
                            ? 'Don\'t have an Account? '
                            : 'Already have an Account? ',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            fontSize: 12.0),
                        children: [
                          TextSpan(
                            text: isLoginScreen ? 'Register' : 'Login',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  isLoginScreen
                      ? Column(
                          children: [
                            const SizedBox(height: 20.0),
                            InkWell(
                              onTap: () {
                                Get.offAll(() => const HomeScreen(),
                                    transition: Transition.downToUp);
                                authController.isGuestUser.value = true;
                                debugPrint('Login as GuestUser');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MyColorHelper.verdigris
                                        .withOpacity(0.7),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomTextWidget(
                                        text: 'Continue as Guest',
                                        textColor: Colors.white,
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                      ),
                                      const SizedBox(width: 8.0),
                                      const Icon(
                                        Icons.accessibility,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
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
