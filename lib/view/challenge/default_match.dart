import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sound_app/controller/default_match_controller.dart';
import 'package:sound_app/data/default_challenge_service.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/toast.dart';
import 'package:sound_app/view/home_screen.dart';

class DefaultMatchScreen extends StatefulWidget {
  const DefaultMatchScreen({super.key});

  @override
  State<DefaultMatchScreen> createState() => _DefaultMatchScreenState();
}

class _DefaultMatchScreenState extends State<DefaultMatchScreen> {
  late DefaultMatchController controller;
  late io.Socket socket;
  int randomId = Random().nextInt(100000);

  @override
  void initState() {
    super.initState();
    controller = Get.put(DefaultMatchController());
    connectToSocket();
    controller.fetchSoundsForDefaultMatch();
  }

  void connectToSocket() {
    try {
      debugPrint('Connecting to Socket...');
      socket = io.io(ApiEndPoints.baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.onConnect((_) {
        debugPrint(
            'Connected to Socket Server ${ApiEndPoints.connectToDefaultMatch}');
        socket.emit(
          ApiEndPoints.connectToDefaultMatch,
          {
            // 'user_id': MyAppStorage.storage.read('user_info')['_id'],
            'user_id': randomId,
          },
        );
      });
      socket.onDisconnect((_) {
        debugPrint(
            'Disconnected from Socket Server ${ApiEndPoints.connectToDefaultMatch}');
      });

      socket.on(ApiEndPoints.showTestMatchResult, (data) {
        debugPrint('Received Calculation Result: $data');
        controller.matchPercentage.value = data['percentage_matched'];
        controller.isResultCalculating.value = false;
        controller.isResultCalculated.value = true;
        ToastMessage.showToastMessage(
            message: 'Result Calculated Successfully',
            backgroundColor: Colors.green);
      });
    } catch (e) {
      debugPrint('Socket initialization error: $e');
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.offAll(() => const HomeScreen());
        Get.delete<DefaultMatchController>();
      },
      child: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Obx(
                  () => controller.freeMatchSounds.value.isEmpty
                      ? Center(
                          child: Lottie.asset(
                            MyAssetHelper.thinkLoader,
                            height: 100,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: context.height * 0.03,
                                horizontal: context.width * 0.02),
                            child: Column(
                              children: [
                                TopContainer(controller: controller),
                                CenterPart(
                                    controller: controller, randomId: randomId),
                              ],
                            ),
                          ),
                        ),
                ),
              ))
        ],
      )),
    );
  }
}

class TopContainer extends StatelessWidget {
  final DefaultMatchController controller;

  const TopContainer({
    super.key,
    required this.controller,
  });

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
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomTextWidget(
                  text: "Free Sound Match",
                  fontFamily: "Horta",
                  textColor: MyColorHelper.white,
                  fontSize: 26,
                ),
                Obx(
                  () => Container(
                    width: 150,
                    padding:
                        EdgeInsets.symmetric(horizontal: context.width * 0.03),
                    decoration: BoxDecoration(
                      color: MyColorHelper.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<SoundModel>(
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(8.0),
                      hint: const CustomTextWidget(
                        text: "Select a Sound",
                        textColor: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.black87,
                      ),
                      value: controller.selectedSound.value,
                      items: controller.freeMatchSounds
                          .map((dynamic sound) => DropdownMenuItem<SoundModel>(
                                value: sound as SoundModel,
                                child: CustomTextWidget(
                                  text: sound.name ?? 'Unknown',
                                  textColor: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedSound.value = value;
                        // controller.defaultAudioDuration.value =
                        //     Duration(seconds: value?.duration ?? 0);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      AssetImage('assets/images/guest_user_profile.PNG'),
                  // backgroundImage: NetworkImage(MyAssetHelper.lead),
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
                                    color: Colors.black87,
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
          ],
        ),
      ),
    );
  }
}

class CenterPart extends StatelessWidget {
  final DefaultMatchController controller;
  final int randomId;

  const CenterPart({
    super.key,
    required this.controller,
    required this.randomId,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(
        () => controller.isResultCalculated.value
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Stack(
                      children: [
                        Container(
                          height: context.height * 0.2,
                          width: context.width * 0.6,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  MyAssetHelper.rankContainerBackground),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ListTile(
                                isThreeLine: true,
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/guest_user_profile.PNG'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: const CustomTextWidget(
                                  text: 'You',
                                  fontFamily: "Horta",
                                  textColor: MyColorHelper.white,
                                  fontSize: 18,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextWidget(
                                      text:
                                          "Percentage: ${controller.matchPercentage.value}%",
                                      fontFamily: "horta",
                                      textColor: MyColorHelper.white,
                                      fontSize: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomTextWidget(
                    text:
                        'Your Sound Matches ${controller.matchPercentage.value}% with the default sound',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                  ),
                  CustomAuthButton(
                    isLoading: false,
                    text: 'Back to Dashboard',
                    onTap: () {
                      Get.delete<DefaultMatchController>();
                      Get.back();
                    },
                  ),
                  CustomAuthButton(
                    isLoading: false,
                    text: 'Play Again',
                    onTap: () => controller.resetValuesOnPlayAgain(),
                  ),
                ],
              )
            : controller.isResultCalculating.value
                ? const Center(
                    heightFactor: 10,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserAudioDuration(),
                      MyRecordingAnimation(),
                      MyRecordAudioButton(controller: controller),
                      UserRecordedSoundAndCalculateButton(context, randomId)
                    ],
                  ),
      ),
    );
  }

  Visibility UserRecordedSoundAndCalculateButton(
      BuildContext context, int randomId) {
    return Visibility(
      visible: controller.isUserRecordingCompleted.value,
      child: Column(
        children: [
          const CustomTextWidget(
            text: 'Long Press to Record the Sound',
            textColor: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
          Container(
            margin: const EdgeInsets.all(6),
            width: context.width * 0.7,
            decoration: BoxDecoration(
                color: MyColorHelper.white,
                borderRadius: BorderRadius.circular(8)),
            child: Obx(
              () => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: controller.toggleUserAudio,
                          child: Icon(
                            controller.isUserAudioPlaying.value
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            size: 30.0,
                          )),
                    ),
                    const SizedBox(width: 6.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextWidget(
                                text:
                                    '${_formatDuration(controller.userAudioPosition.value)} / ${_formatDuration(controller.userAudioDuration.value)}',
                                fontWeight: FontWeight.w600,
                                textColor: Colors.black45,
                              ),
                            ),
                          ),
                          controller.isUserAudioPlaying.value
                              ? Lottie.asset(
                                  "assets/images/audioAnimation.json",
                                  fit: BoxFit.fill,
                                  height: context.height * 0.03)
                              : const Divider(thickness: 3.0, endIndent: 15.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: context.height * 0.03),
          CustomAuthButton(
            isLoading: false,
            text: 'Calculate',
            onTap: () async {
              controller.isResultCalculating.value = true;
              if (controller.recordedFilePath != null) {
                final file = File(controller.recordedFilePath!);
                final bytes = await file.readAsBytes();
                bool isSuccessful =
                    await DefaultChallengeService().uploadUserRecording(
                  userRecordingInBytes: bytes,
                  soundId: controller.selectedSound.value?.id ?? '',
                  userId: randomId,
                  // userId: storage.read('user_info')['_id'],
                );
                if (isSuccessful) {
                  controller.isResultCalculating.value = false;
                  controller.isResultCalculated.value = true;
                } else {
                  ToastMessage.showToastMessage(
                      message: 'Something went wrong, please try again!',
                      backgroundColor: Colors.red);
                  controller.isDefaultAudioPlaying = false.obs;
                  controller.isUserAudioPlaying = false.obs;
                  controller.isUserRecording = false.obs;
                  controller.isUserRecordingCompleted = false.obs;
                  controller.isResultCalculating = false.obs;
                  controller.isResultCalculated = false.obs;
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Visibility MyRecordingAnimation() {
    return Visibility(
      visible: controller.isUserRecording.value,
      child: Lottie.asset(
        MyAssetHelper.musicLoading,
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      ),
    );
  }

  Obx UserAudioDuration() {
    return Obx(
      () => CustomTextWidget(
        text: _formatDuration(controller.userRecordingDuration.value),
        textColor: Colors.white,
        fontSize: 26.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class MyRecordAudioButton extends StatelessWidget {
  const MyRecordAudioButton({
    super.key,
    required this.controller,
  });

  final DefaultMatchController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: controller.startRecording,
      onLongPressEnd: (details) => controller.stopRecording(),
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        height: context.height * 0.2,
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
    );
  }
}
