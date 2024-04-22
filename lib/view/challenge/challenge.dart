import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_app/controller/challenge_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/view/challenge/sharing_screen.dart';

class ChallengeScreen extends StatelessWidget {
  final ChallengeModel challengeModel;
  ChallengeScreen({super.key, required this.challengeModel});

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
                            challengeModel: challengeModel,
                          ),
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: controller.totalParticipants.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 0.0,
                                crossAxisSpacing: 120.0,
                              ),
                              itemBuilder: (context, index) {
                                final participant =
                                    controller.totalParticipants[index];
                                controller.isCurrentTurn.value = (index ==
                                    controller.currentTurnIndex.value);
                                return CustomUserCard(
                                  participant: participant,
                                  isCurrentTurn: controller.isCurrentTurn.value,
                                  index: index,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: context.height * 0.1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => Visibility(
                                  visible: controller.isUserRecording.value,
                                  child: Lottie.asset(
                                    MyAssetHelper.musicLoading,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.currentTurnIndex.value ==
                                    controller.currentUserIndex.value,
                                child: GestureDetector(
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
                                child: Center(
                                  child: Obx(
                                    () => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: controller
                                                  .eachTurnDuration.value /
                                              controller.originalTurnDuration
                                                  .toDouble(),
                                          strokeWidth: 4.0,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                      Color>(
                                                  MyColorHelper.primaryColor),
                                        ),
                                        CustomTextWidget(
                                          text: controller
                                              .eachTurnDuration.value
                                              .toString(),
                                          fontSize: 24.0,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX:
                                controller.isResultPopupVisible.value ? 5 : 0,
                            sigmaY:
                                controller.isResultPopupVisible.value ? 5 : 0,
                          ),
                          child: const SizedBox(),
                        ),
                      )
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
  final ChallengeModel challengeModel;
  final ChallengeController controller;
  const TopContainer(
      {super.key, required this.controller, required this.challengeModel});

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
                text: challengeModel.challengeName ?? '',
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
                controller.currentTurnIndex.value = 0;
                controller.onGameStarts();
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
  final Participant participant;
  final bool isCurrentTurn;
  final int? index;

  const CustomUserCard(
      {super.key,
      required this.isCurrentTurn,
      this.index,
      required this.participant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          CustomTextWidget(
            text: participant.name ?? '',
            fontFamily: 'Poppins',
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            textColor: Colors.white,
          ),
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(participant.imageUrl ?? ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatingResultPopup extends StatelessWidget {
  const CalculatingResultPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      height: context.height * 0.6,
      width: context.width,
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage(MyAssetHelper.leaderBackground),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            MyAssetHelper.robot,
            height: context.height * 0.15,
          ),
          Flexible(
            child: CustomTextWidget(
              text:
                  "All recordings have been received.\n Please wait, Result are Calculating...... ",
              textAlign: TextAlign.center,
              maxLines: 4,
              fontFamily: 'poppins',
              textColor: MyColorHelper.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          SpinKitSpinningLines(
            color: Colors.white,
            size: context.height * 0.06,
            lineWidth: 2.0,
          )
        ],
      ),
    );
  }
}