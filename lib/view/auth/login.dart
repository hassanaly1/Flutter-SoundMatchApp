import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/utils/validator.dart';
import 'package:sound_app/view/auth/forget_password.dart';
import 'package:sound_app/view/auth/signup.dart';
import 'package:sound_app/view/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthController authController;
  final GuestController guestController = Get.find();

  @override
  void initState() {
    authController = Get.put(AuthController());
    super.initState();
  }

  @override
  void dispose() {
    authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            child: const Center(
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
                      child: Form(
                        key: authController.loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomTextField(
                              controller: authController.emailController,
                              hintText: 'Enter your Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) =>
                                  AppValidator.validateEmail(value: val),
                            ),
                            SizedBox(height: context.height * 0.02),
                            Obx(
                              () => CustomTextField(
                                controller: authController.passwordController,
                                validator: (value) =>
                                    AppValidator.validatePassword(value: value),
                                hintText: ' Password',
                                obscureText: !authController.showPassword.value,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      authController.showPassword.value =
                                          !authController.showPassword.value;
                                    },
                                    icon: Icon(
                                        authController.showPassword.value
                                            ? CupertinoIcons.eye
                                            : CupertinoIcons.eye_slash,
                                        color: MyColorHelper.verdigris)),
                              ),
                            ),
                            TextButton(
                                isSemanticButton: true,
                                onPressed: () {
                                  Get.to(() => const ForgetPasswordScreen(),
                                      transition: Transition.rightToLeft);
                                },
                                child: const CustomTextWidget(
                                  text: 'Forget Password?',
                                  textColor: Colors.white,
                                  fontFamily: 'poppins',
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                      ),
                    ),

                    //Button
                    Obx(
                      () => CustomAuthButton(
                        isLoading: authController.isLoading.value,
                        text: 'Login',
                        onTap: () {
                          if (authController.loginFormKey.currentState!
                              .validate()) {
                            authController.loginUser();
                            guestController.isGuestUser.value = false;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: context.height * 0.02),

                    // const CustomTextWidget(
                    //   text: 'Or Register with',
                    //   fontWeight: FontWeight.w600,
                    //   textColor: Colors.white60,
                    //   fontFamily: 'poppins',
                    // ),
                    // SizedBox(height: context.height * 0.02),
                    // const Center(
                    //   child: CustomSocialIcon(
                    //       imagePath: 'assets/images/google-icon.png'),
                    // ),
                    SizedBox(height: context.height * 0.02),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SignupScreen(),
                            transition: Transition.rightToLeft);
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Don\'t have an Account? ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                              fontFamily: 'poppins',
                              fontSize: 12.0),
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontFamily: 'poppins',
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
                            guestController.isGuestUser.value = true;
                            debugPrint(
                                'Login as GuestUser: ${guestController.isGuestUser.value}');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyColorHelper.verdigris.withOpacity(0.7),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0))),
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
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
                                  SizedBox(width: 8.0),
                                  Icon(
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
