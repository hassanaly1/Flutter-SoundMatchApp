import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sound_app/controller/challenge_controller.dart';
import 'package:sound_app/data/socket_service.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/challenge_room_model.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/utils/storage_helper.dart';

class ChallengeRoomScreen extends StatefulWidget {
  const ChallengeRoomScreen({super.key});

  @override
  State<ChallengeRoomScreen> createState() => _ChallengeRoomScreenState();
}

class _ChallengeRoomScreenState extends State<ChallengeRoomScreen> {
  ChallengeRoomModel? model;
  late ChallengeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChallengeController());
    callSockets();
  }

  callSockets() async {
    await callChallengeRoomSocket();
  }

  callChallengeRoomSocket() {
    io.Socket socket = SocketService().getSocket();
    debugPrint(
        '<============================ Connecting to Challenge Room ============================>');
    try {
      socket.on(
        'challenge_room',
        (data) {
          debugPrint(
              '<================================== New Data Received In The Challenge Room ==================================>');
          ChallengeRoomModel challengeRoomModel =
              ChallengeRoomModel.fromJson(data['challenge_room']);
          // print('Challenge Room Model: ${challengeRoomModel.toJson()}');
          model = challengeRoomModel;
          controller.totalParticipants.value = model!.users!;
          controller.isChallengeStarts.value = model!.isStarted!;
          controller.currentTurnParticipantId.value =
              model!.currentTurnHolder!.id;
          controller.isRoundCompleted.value = model!.isFinished!;

          debugPrint(
              'Total Participants: ${controller.totalParticipants.length}');
          debugPrint(
              'Current Turn: ${controller.currentTurnParticipantId.value}');

          ///Start the Timer Again when the Match is already started.
          if (controller.isRoundCompleted.value == false &&
              controller.hasChallengeStarted.value) {
            debugPrint(
                'hasChallengeStarted: ${controller.hasChallengeStarted.value}');
            controller.recordingTimer?.cancel();
            controller.recordingTimer = null;
            controller.isUserRecording.value = false;
            controller.eachTurnDuration.value =
                controller.originalTurnDuration.value;
            controller.onGameStarts(
              currentUserId: controller.currentTurnParticipantId.value,
              roomId: model!.id!,
            );
          }

          ///Display the Round Started Popup only when the game is started for the very first time
          if (controller.isChallengeStarts.value &&
              controller.hasChallengeStarted.value == false) {
            controller.hasChallengeStarted.value = true;
            debugPrint(
                'isChallengeStarts: ${controller.isChallengeStarts.value}');
            if (mounted) {
              showRoundStartedPopup(
                model: model!,
                controller: controller,
              );
            }
          }

          ///Display Showing Result Popup when the round is completed
          if (controller.isRoundCompleted.value) {
            debugPrint(
                'isRoundCompleted: ${controller.isRoundCompleted.value}');
            controller.showCalculatingResultPopup(model!);
          }
          // debugPrint(
          //     'Created By: ${model!.createdBy?.firstName} ${model!.createdBy?.lastName} with Id: ${model!.createdBy?.id} and profile: ${model!.createdBy?.profile}');
        },
      );
    } catch (e) {
      debugPrint('Error Getting Challenge Data: $e');
    }
  }

  void showRoundStartedPopup({
    required ChallengeController controller,
    required ChallengeRoomModel model,
  }) {
    if (!context.mounted)
      return; // Ensure the widget is mounted before showing the dialog

    // Show the dialog
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return PopScope(
          canPop: false,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: AlertDialog(
                scrollable: true,
                backgroundColor: Colors.transparent,
                content: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: context.height * 0.02,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                      colors: [
                        MyColorHelper.blue,
                        MyColorHelper.caribbeanCurrent
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        spreadRadius: 5.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        MyAssetHelper.roundAnimation,
                        height: 120,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: DefaultTextStyle(
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Horta',
                            color: MyColorHelper.white,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                textAlign: TextAlign.center,
                                'Round ${model.challengeRoomNumber.toString()} Started',
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // Close the dialog after 3 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (context.mounted) {
        Navigator.of(context).pop();
        controller.onGameStarts(
          currentUserId: model.currentTurnHolder?.id ?? '',
          roomId: model.id ?? '',
        );
      }
    });
  }

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
            body: Obx(
              () => controller.totalParticipants.value.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
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
                                    model: model!,
                                  ),
                                  Expanded(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.totalParticipants.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 0.0,
                                        crossAxisSpacing: 120.0,
                                      ),
                                      itemBuilder: (context, index) {
                                        final participant =
                                            controller.totalParticipants[index];
                                        return CustomUserCard(
                                          participant: participant,
                                          isCurrentTurn: controller
                                                  .currentTurnParticipantId
                                                  .value ==
                                              participant.id,
                                          index: index,
                                          hasChallengeStarted: controller
                                              .hasChallengeStarted.value,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: context.height * 0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(
                                        () => Visibility(
                                          visible:
                                              controller.isUserRecording.value,
                                          child: Lottie.asset(
                                            MyAssetHelper.musicLoading,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        // visible: controller
                                        //         .currentTurnIndex.value ==
                                        //     controller.currentUserIndex.value,
                                        visible: model!.currentTurnHolder?.id ==
                                                MyAppStorage.userId &&
                                            controller
                                                .hasChallengeStarted.value,
                                        child: GestureDetector(
                                          onLongPress:
                                              controller.onLongPressedStart,
                                          onLongPressEnd: (details) =>
                                              controller.onLongPressedEnd(
                                            userId: controller
                                                .currentTurnParticipantId.value,
                                            roomId: model!.id!,
                                          ),
                                          child: Container(
                                            height: 80,
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 15.0,
                                                    spreadRadius: 4.0,
                                                    offset: Offset(5.0, 5.0),
                                                  )
                                                ],
                                                shape: BoxShape.circle),
                                            child:
                                                Image.asset(MyAssetHelper.mic),
                                          ),
                                        ),
                                      ),

                                      /// Countdown Timer
                                      Container(
                                        height: 80,
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
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
                                                          .eachTurnDuration
                                                          .value /
                                                      controller
                                                          .originalTurnDuration
                                                          .toDouble(),
                                                  strokeWidth: 4.0,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                              Color>(
                                                          MyColorHelper
                                                              .caribbeanCurrent),
                                                ),
                                                CustomTextWidget(
                                                  text: controller
                                                      .eachTurnDuration.value
                                                      .toString(),
                                                  fontSize: 24.0,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  textColor: MyColorHelper
                                                      .caribbeanCurrent,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     ChallengeService().uploadUserSound(
                                      //       userRecordingInBytes: null,
                                      //       userId: MyAppStorage.userId,
                                      //       roomId: model?.id ?? '',
                                      //     );
                                      //   },
                                      //   child: Container(
                                      //     height: 80,
                                      //     margin: const EdgeInsets.all(10),
                                      //     padding: const EdgeInsets.all(20),
                                      //     decoration: BoxDecoration(
                                      //         color: Colors.grey.shade300,
                                      //         boxShadow: const [
                                      //           BoxShadow(
                                      //             color: Colors.black26,
                                      //             blurRadius: 15.0,
                                      //             spreadRadius: 4.0,
                                      //             offset: Offset(5.0, 5.0),
                                      //           )
                                      //         ],
                                      //         shape: BoxShape.circle),
                                      //     child: Center(
                                      //       child: Icon(Icons.add_circle),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(
                                () => BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: controller.isRoundCompleted.value
                                        ? 5
                                        : 0,
                                    sigmaY: controller.isRoundCompleted.value
                                        ? 5
                                        : 0,
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
          ),
        )
      ],
    ));
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
          const Flexible(
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

class TopContainer extends StatelessWidget {
  final ChallengeRoomModel model;
  final ChallengeController controller;

  const TopContainer(
      {super.key, required this.controller, required this.model});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

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
                text: model.challengeGroup?.name ?? '',
                fontFamily: "Horta",
                textColor: MyColorHelper.white,
                fontSize: 32),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      const CustomTextWidget(text: 'Creator', maxLines: 2),
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(model.createdBy?.profile ?? ''),
                      ),
                      CustomTextWidget(
                          text:
                              '${model.createdBy?.firstName} ${model.createdBy?.lastName}'),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: context.width * 0.03),
                    decoration: BoxDecoration(
                      color: MyColorHelper.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Obx(
                        () {
                          final duration =
                              controller.defaultAudioDuration.value;
                          final position =
                              controller.defaultAudioPosition.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: controller.toggleDefaultAudio,
                                  child: Icon(
                                    controller.isDefaultAudioPlaying.value
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                    size: 35.0,
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomTextWidget(
                                        text:
                                            '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                        fontWeight: FontWeight.w600,
                                        textColor: Colors.black45,
                                      ),
                                      controller.isDefaultAudioPlaying.value
                                          ? Lottie.asset(
                                              "assets/images/audioAnimation.json",
                                              fit: BoxFit.fill,
                                              height: context.height * 0.03,
                                            )
                                          : const Divider(thickness: 3.0),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CustomTextWidget(
              // text: 'Round # ${controller.currentRound.toString()}',
              text:
                  ' Passing Criteria for Round # ${model.challengeRoomNumber.toString()}: ${model.passingCriteria?.percentage}',
              fontWeight: FontWeight.w500,
              textColor: MyColorHelper.white,
              fontSize: 14,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  // text: 'Round # ${controller.currentRound.toString()}',
                  text:
                      'Round # ${model.challengeRoomNumber.toString()} / ${model.challengeGroup?.numberOfChallenges.toString()}',
                  fontWeight: FontWeight.w600,
                  textColor: MyColorHelper.white,
                  fontSize: 16,
                ),
                Visibility(
                  visible: model.createdBy?.id == MyAppStorage.userId &&
                      controller.isChallengeStarts.value == false,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('Start Match Clicked');
                      io.Socket socket = SocketService().getSocket();
                      socket.emit(
                        'start_challenge',
                        model.id,
                      );

                      // controller.onGameStarts(model);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        // width: 100,
                        decoration: BoxDecoration(
                            color: MyColorHelper.primaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: CustomTextWidget(
                            text: "Start Match",
                            textColor: MyColorHelper.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     io.Socket socket = SocketService().getSocket();
                //     socket.emit(
                //       'room_challenge_completed',
                //       {
                //         'data': {
                //           'room_id': model.id,
                //         }
                //       },
                //     );
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       height: 40,
                //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //       // width: 100,
                //       decoration: BoxDecoration(
                //           color: MyColorHelper.primaryColor,
                //           borderRadius: BorderRadius.circular(12)),
                //       child: const Center(
                //         child: CustomTextWidget(
                //           text: "Test",
                //           textColor: MyColorHelper.white,
                //           fontSize: 14,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     ChallengeService().uploadUserSound(
                //         userRecordingInBytes: null,
                //         userId: MyAppStorage.userId,
                //         roomId: model.id ?? '');
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       height: 40,
                //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //       // width: 100,
                //       decoration: BoxDecoration(
                //           color: MyColorHelper.primaryColor,
                //           borderRadius: BorderRadius.circular(12)),
                //       child: const Center(
                //         child: CustomTextWidget(
                //           text: "Test Sound",
                //           textColor: MyColorHelper.white,
                //           fontSize: 14,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 8.0)
          ],
        ),
      ),
    );
  }
}

class CustomUserCard extends StatelessWidget {
  final Participant participant;
  final bool isCurrentTurn;
  final bool hasChallengeStarted;
  final int? index;

  const CustomUserCard({
    super.key,
    required this.isCurrentTurn,
    this.index,
    required this.participant,
    required this.hasChallengeStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          CustomTextWidget(
            text: participant.firstName ?? '',
            fontFamily: 'Poppins',
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            textColor: Colors.white,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: isCurrentTurn && hasChallengeStarted
                  ? Border.all(color: Colors.white, width: 3.0)
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
                backgroundImage: NetworkImage(participant.profile ?? ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
