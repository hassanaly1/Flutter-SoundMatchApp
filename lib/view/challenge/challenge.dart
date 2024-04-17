import 'dart:ui';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_app/controller/challenge_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/challenge/sharing_screen.dart';

class ChallengeScreen extends StatelessWidget {
  ChallengeScreen({super.key});

  final ChallengeController controller = Get.put(ChallengeController());

  @override
  Widget build(BuildContext context) {
    debugPrint('ChallengeBuildCalled');
    return SafeArea(
        child: Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: context.height * 0.03,
                  horizontal: context.width * 0.02),
              child: GetBuilder<ChallengeController>(
                init: controller,
                builder: (controller) {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          TopContainer(
                            controller: controller,
                            countDownController: controller.countDownController,
                          ),
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: 8,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5.0,
                                crossAxisSpacing: 120.0,
                              ),
                              itemBuilder: (context, index) {
                                bool isCurrentTurn = (index ==
                                    controller.currentTurnIndex.value);
                                return CustomUserCard(
                                    isCurrentTurn: isCurrentTurn);
                              },
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onLongPress: controller.onLongPressedStart,
                              onLongPressEnd: (details) =>
                                  controller.onLongPressedEnd(),
                              child: Container(
                                height: 80,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0,
                                        spreadRadius: 4.0,
                                        offset: Offset(5.0, 5.0),
                                      )
                                    ],
                                    shape: BoxShape.circle),
                                child: Image.asset(MyAssetHelper.mic),
                              ),
                            ),
                            Container(
                                height: 80,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0,
                                        spreadRadius: 4.0,
                                        offset: Offset(5.0, 5.0),
                                      )
                                    ],
                                    shape: BoxShape.circle),
                                child: CircularCountDownTimer(
                                  duration: 10,
                                  controller: controller.countDownController,
                                  width: 40,
                                  ringColor: Colors.grey.shade300,
                                  ringGradient: null,
                                  fillColor: MyColorHelper.primaryColor,
                                  fillGradient: null,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundGradient: null,
                                  strokeWidth: 10.0,
                                  strokeCap: StrokeCap.round,
                                  textStyle: const TextStyle(
                                      fontSize: 26.0,
                                      fontFamily: 'poppins',
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                  textFormat: CountdownTextFormat.S,
                                  isReverse: false,
                                  isReverseAnimation: false,
                                  isTimerTextShown: true,
                                  autoStart: true,
                                  onStart: () => controller.onCountdownComplete,
                                  // onComplete: controller.onCountdownComplete,
                                  onChange: (String timeStamp) {
                                    print(timeStamp);
                                  },
                                  height: 50,
                                )),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        )
      ],
    ));
  }
}

class TopContainer extends StatelessWidget {
  final ChallengeController controller;
  final CountDownController countDownController;
  const TopContainer(
      {super.key, required this.controller, required this.countDownController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage(
          MyAssetHelper.leaderBackground,
        ),
      )),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextWidget(
                text: "Challenge Name",
                fontFamily: "Horta",
                textColor: MyColorHelper.white,
                fontSize: 32),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(MyAssetHelper.lead),
                ),
                Flexible(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: context.width * 0.05),
                    height: context.height * 0.06,
                    decoration: BoxDecoration(
                        color: MyColorHelper.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Obx(
                      () => Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  debugPrint('AudioIconTapped');
                                  controller.isDefaultAudioPlaying.value =
                                      !controller.isDefaultAudioPlaying.value;
                                },
                                child: Icon(
                                    controller.isDefaultAudioPlaying.value
                                        ? Icons.pause_circle
                                        : Icons.play_circle)),
                          ),
                          Expanded(
                            child: controller.isDefaultAudioPlaying.value
                                ? Lottie.asset(
                                    "assets/images/audioAnimation.json",
                                    fit: BoxFit.fill,
                                    height: context.height * 0.03)
                                : const Divider(
                                    thickness: 3.0, endIndent: 15.0),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      backgroundColor: MyColorHelper.caribbeanCurrent,
                      context: context,
                      builder: (BuildContext context) {
                        return const SocialMediaSharingBottomSheet();
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: MyColorHelper.primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: const Center(
                        child: Icon(
                      FontAwesomeIcons.share,
                      color: MyColorHelper.white,
                    )),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                countDownController.start();
                controller.currentTurnIndex.value = 0;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: MyColorHelper.primaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: CustomTextWidget(
                      text: "Start",
                      textColor: MyColorHelper.white,
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomUserCard extends StatelessWidget {
  final bool isCurrentTurn;

  const CustomUserCard({super.key, required this.isCurrentTurn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: isCurrentTurn
              ? Border.all(color: Colors.white, width: 2.0)
              : null,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(MyAssetHelper.userBackground),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(radius: 30),
        ),
      ),
    );
  }
}
