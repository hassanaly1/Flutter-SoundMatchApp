import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sound_app/controller/auth_controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController controller = Get.find();

  Color borderColor = const Color.fromRGBO(114, 178, 238, 1);
  Color errorColor = const Color.fromRGBO(255, 234, 238, 1);
  Color fillColor = const Color.fromRGBO(222, 231, 240, .57);
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(222, 231, 240, .57),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.transparent),
    ),
  );

  bool _timerInProgress = true;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          _timerInProgress = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          // width: context.width * 0.3,
                          decoration: BoxDecoration(
                            color: MyColorHelper.verdigris.withOpacity(0.7),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(22.0),
                              bottomLeft: Radius.circular(22.0),
                            ),
                          ),
                          child: Center(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: CustomTextWidget(
                              text: 'Verification',
                              fontSize: 20.0,
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
                  //PinPut
                  CustomTextWidget(
                    text:
                        'Enter the 6-digit code sent to your email ${widget.email}',
                    fontSize: 14.0,
                    maxLines: 2,
                    textColor: Colors.white,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'poppins',
                  ),
                  //generate textfields

                  SizedBox(height: context.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Pinput(
                      length: 6,
                      keyboardType: TextInputType.text,
                      controller: controller.otpController,
                      validator: (s) {},
                      errorTextStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        height: 68,
                        width: 64,
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: borderColor),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyWith(
                        decoration: BoxDecoration(
                          color: errorColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onCompleted: (pin) {
                        // if (pin == '2222') {
                        //   // Utils().toastMessage('Login Successfully');
                        //   // Get.offAll(const DashboardScreen(),
                        //   //     transition: Transition.rightToLeft);
                        // }
                        // setState(() {
                        //   _pinController.clear();
                        //   _timerInProgress = false;
                        // });
                      },
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                  _timerInProgress
                      ? CustomTextWidget(text: 'Resend OTP in $_start seconds')
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              CustomTextWidget(
                                text: 'Didn\'t receive the code?',
                                textColor: Colors.white54,
                                fontSize: 14,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _timerInProgress = true;
                                    _start = 60;
                                  });
                                  controller.otpController.clear();
                                  startTimer();
                                },
                                child: CustomTextWidget(
                                  text: 'Resend OTP',
                                  fontSize: 16,
                                  textColor: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
                            text: 'Verify OTP',
                            onTap: () => controller.verifyEmail(),
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
