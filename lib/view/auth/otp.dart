import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';

class OtpScreen extends StatefulWidget {
  final bool verifyOtpForForgetPassword;
  final String email;

  const OtpScreen({
    super.key,
    required this.email,
    required this.verifyOtpForForgetPassword,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController controller = Get.find();

  final RxInt _start = 60.obs;
  final RxBool _timerInProgress = true.obs;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start.value == 0) {
        _timerInProgress.value = false;
        timer.cancel();
      } else {
        _start.value--;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(MyAssetHelper.authBackground, fit: BoxFit.cover),
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: MyColorHelper.verdigris.withOpacity(0.7),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(22.0),
                              bottomLeft: Radius.circular(22.0),
                            ),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              child: CustomTextWidget(
                                text: 'Verification',
                                fontSize: 20.0,
                                textColor: Colors.white,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Image.asset('assets/images/auth_logo.png',
                        fit: BoxFit.fill, height: 120),
                  ),
                  SizedBox(height: context.height * 0.02),
                  CustomTextWidget(
                    text:
                        'Enter the 6-digit code sent to your email ${widget.email}',
                    fontSize: 14.0,
                    maxLines: 2,
                    textColor: Colors.white,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: context.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Pinput(
                      length: 6,
                      keyboardType: TextInputType.number,
                      controller: controller.otpController,
                      validator: (s) => null,
                      errorTextStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      closeKeyboardWhenCompleted: true,
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 60,
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(30, 60, 87, 1),
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(222, 231, 240, .57),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.transparent),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 64,
                        height: 68,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(222, 231, 240, .57),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color.fromRGBO(114, 178, 238, 1)),
                        ),
                      ),
                      errorPinTheme: PinTheme(
                        width: 56,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 234, 238, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onCompleted: (pin) {},
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                  Obx(() {
                    return _timerInProgress.value
                        ? CustomTextWidget(
                            text: 'Resend OTP in ${_start.value} seconds',
                            textColor: Colors.white,
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                const CustomTextWidget(
                                  text: 'Didn\'t receive the code?',
                                  textColor: Colors.white54,
                                  fontSize: 14,
                                ),
                                TextButton(
                                  onPressed: () {
                                    _timerInProgress.value = true;
                                    _start.value = 60;
                                    controller.otpController.clear();
                                    controller.sendOtp();
                                    startTimer();
                                  },
                                  child: const CustomTextWidget(
                                    text: 'Resend OTP',
                                    fontSize: 16,
                                    textColor: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                  }),
                  SizedBox(height: context.height * 0.03),
                  Obx(
                    () => CustomAuthButton(
                      isLoading: controller.isLoading.value,
                      text: 'Verify OTP',
                      onTap: () {
                        if (controller.otpController.text.isEmpty) {
                          MySnackBarsHelper.showError(
                              'Please Enter OTP and try again.',
                              'Please Enter OTP.',
                              Icons.error);
                        } else {
                          widget.verifyOtpForForgetPassword
                              ? controller.verifyOtp()
                              : controller.verifyEmail();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
