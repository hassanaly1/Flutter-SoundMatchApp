import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_social_icon.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/view/auth/forget_password.dart';
import 'package:sound_app/view/auth/signup.dart';
import 'package:sound_app/view/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController =
        Get.put(AuthController(), permanent: true);
    final MyUniversalController universalController = Get.find();
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                            child: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.transparent,
                                shape: CircleBorder(),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.transparent,
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
                                child: CustomTextWidget(
                              text: 'Login',
                              fontSize: 22.0,
                              textColor: Colors.white,
                              fontFamily: 'poppins',
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
                          CustomTextField(
                              controller: authController.emailController,
                              hintText: 'Enter your Email'),
                          SizedBox(height: context.height * 0.02),
                          CustomTextField(
                              controller: authController.passwordController,
                              hintText: 'Enter your Password'),
                          Visibility(
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

                    //Button
                    Obx(
                      () => authController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white70),
                            )
                          : CustomAuthButton(
                              text: 'Login',
                              onTap: () {
                                authController.loginUser();
                                // Get.offAll(() => const HomeScreen(),
                                //     transition: Transition.downToUp);
                                // authController.isGuestUser.value = false;
                                // debugPrint('Login as RegisteredUser');
                                // MySnackBarsHelper.showMessage("Successfully", "Login",
                                //     CupertinoIcons.check_mark_circled);
                              },
                            ),
                    ),
                    SizedBox(height: context.height * 0.02),

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
                        Get.to(() => const SignupScreen(),
                            transition: Transition.rightToLeft);
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'Don\'t have an Account? ',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                              fontSize: 12.0),
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        const SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            Get.offAll(() => const HomeScreen(),
                                transition: Transition.downToUp);
                            universalController.isGuestUser.value = true;
                            debugPrint('Login as GuestUser');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyColorHelper.verdigris.withOpacity(0.7),
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
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
