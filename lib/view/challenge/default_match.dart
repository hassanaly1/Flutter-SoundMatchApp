import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/default_match_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_app/view/challenge/widgets/user_result_card.dart';

class DefaultMatchScreen extends StatelessWidget {
  DefaultMatchScreen({super.key});

  final DefaultMatchController controller = Get.put(DefaultMatchController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.03,
                      horizontal: context.width * 0.02),
                  child: Column(
                    children: [
                      TopContainer(controller: controller),
                      CenterPart(controller: controller),
                    ],
                  ),
                ),
              ),
            ))
      ],
    ));
  }
}

class CenterPart extends StatelessWidget {
  final DefaultMatchController controller;
  const CenterPart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(
        () => controller.isResultCalculated.value
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const UserResultCard(index: 0),
                  CustomAuthButton(
                    text: 'Back to Dashboard',
                    onTap: () {
                      Get.delete<DefaultMatchController>();
                      Get.back();
                    },
                  ),
                  CustomAuthButton(
                    text: 'Play Again',
                    onTap: () {
                      controller.isUserRecording.value = false;
                      controller.isUserRecordingCompleted.value = false;
                      controller.isResultCalculated.value = false;
                      controller.isResultCalculating.value = false;
                    },
                  ),
                ],
              )
            : controller.isResultCalculating.value
                ? const Center(
                    heightFactor: 10,
                    child: CircularProgressIndicator(color: Colors.white))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: controller.isUserRecording.value,
                        child: Lottie.asset(
                          MyAssetHelper.musicLoading,
                          width: 60,
                          height: 60,
                          fit: BoxFit.fill,
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () {
                          controller.isUserRecordingCompleted.value = false;
                          controller.isUserRecording.value = true;
                        },
                        onLongPressEnd: (details) {
                          controller.isUserRecording.value = false;
                          controller.isUserRecordingCompleted.value = true;
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(20),
                          height: context.height * 0.25,
                          width: context.width * 0.25,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 30.0,
                                  spreadRadius: 8.0,
                                  offset: Offset(5.0, 5.0))
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(MyAssetHelper.mic),
                        ),
                      ),
                      Visibility(
                        visible: controller.isUserRecordingCompleted.value,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(6),
                              height: context.height * 0.07,
                              width: context.width * 0.7,
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
                                            controller
                                                    .isUserAudioPlaying.value =
                                                !controller
                                                    .isUserAudioPlaying.value;
                                          },
                                          child: Icon(
                                            controller.isUserAudioPlaying.value
                                                ? Icons.pause_circle
                                                : Icons.play_circle,
                                            size: 30.0,
                                          )),
                                    ),
                                    Expanded(
                                      child: controller.isUserAudioPlaying.value
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
                            SizedBox(height: context.height * 0.05),
                            CustomAuthButton(
                              text: 'Calculate',
                              onTap: () {
                                controller.isResultCalculating.value = true;
                                Timer(
                                    const Duration(seconds: 5),
                                    () => controller.isResultCalculated.value =
                                        true);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  final DefaultMatchController controller;
  const TopContainer({
    super.key,
    required this.controller,
  });

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
                text: "Free Sound Match",
                fontFamily: "Horta",
                textColor: MyColorHelper.white,
                fontSize: 32),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
