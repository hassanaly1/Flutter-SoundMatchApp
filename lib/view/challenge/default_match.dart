import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sound_app/controller/default_match_controller.dart';
import 'package:sound_app/data/default_challenge_service.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/view/challenge/widgets/user_result_card.dart';
import 'package:sound_app/view/home_screen.dart';

class DefaultMatchScreen extends StatefulWidget {
  const DefaultMatchScreen({super.key});

  @override
  State<DefaultMatchScreen> createState() => _DefaultMatchScreenState();
}

class _DefaultMatchScreenState extends State<DefaultMatchScreen> {
  late DefaultMatchController controller;
  late IO.Socket socket;

  @override
  void initState() {
    controller = Get.put(DefaultMatchController());
    connectToSocket();
    super.initState();
  }

  void connectToSocket() {
    try {
      debugPrint('Connecting to socket...');
      socket = IO.io(ApiEndPoints.baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.onConnect((_) {
        debugPrint(
            'Connected to Socket Server ${ApiEndPoints.connectToDefaultMatch}');
        socket.emit(ApiEndPoints.connectToDefaultMatch,
            {'user_id': '6610d5301605a835f150583f'});
      });
      socket.onDisconnect((_) {
        debugPrint(
            'Disconnected from Socket Server ${ApiEndPoints.connectToDefaultMatch}');
      });

      socket.on('ApiEndPoints.connectToDefaultMatch', (data) {
        debugPrint('Received calculation result: $data');
      });
    } catch (e) {
      print('Socket initialization error: $e');
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
            const CustomTextWidget(
              text: "Free Sound Match",
              fontFamily: "Horta",
              textColor: MyColorHelper.white,
              fontSize: 26,
            ),
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
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

  const CenterPart({
    super.key,
    required this.controller,
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
                  UserResultCard(
                      index: 0,
                      participant: Participant(
                          name: 'You',
                          imageUrl:
                              'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?size=626&ext=jpg&uid=R133237588&ga=GA1.2.1091155359.1700008188&semt=ais')),
                  CustomAuthButton(
                    text: 'Back to Dashboard',
                    onTap: () {
                      Get.delete<DefaultMatchController>();
                      Get.back();
                    },
                  ),
                  CustomAuthButton(
                    text: 'Play Again',
                    onTap: () => controller.resetValuesOnPlayAgain(),
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
                      Obx(
                        () => CustomTextWidget(
                          text: _formatDuration(
                              controller.userRecordingDuration.value),
                          textColor: Colors.white,
                          fontSize: 26.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                      ),
                      Visibility(
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                            onTap: controller.toggleUserAudio,
                                            child: Icon(
                                              controller
                                                      .isUserAudioPlaying.value
                                                  ? Icons.pause_circle
                                                  : Icons.play_circle,
                                              size: 30.0,
                                            )),
                                      ),
                                      const SizedBox(width: 6.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Obx(
                                              () => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                    height:
                                                        context.height * 0.03)
                                                : const Divider(
                                                    thickness: 3.0,
                                                    endIndent: 15.0),
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
                              text: 'Calculate',
                              onTap: () async {
                                controller.isResultCalculating.value = true;

                                if (controller.recordedFilePath != null) {
                                  // final userAudioBinary =
                                  //     await controller.fileToBinaryString(
                                  //         controller.recordedFilePath!);
                                  final file =
                                      File(controller.recordedFilePath!);
                                  final bytes = await file.readAsBytes();
                                  print(
                                      'User Recorded Audio in Binary: $bytes');
                                  DefaultChallengeService().uploadUserRecording(
                                      userRecordingInBytes: bytes,
                                      soundId: '1');
                                }

                                controller.isResultCalculating.value = false;
                                controller.isResultCalculated.value = true;

                                // Timer(
                                //   const Duration(seconds: 1),
                                //   () => controller.isResultCalculated.value =
                                //       true,
                                // );
                              },
                            ),

                            // CustomAuthButton(
                            //   text: 'Calculate Result',
                            //   onTap: () {
                            //     controller.isResultCalculating.value = true;
                            //     Timer(
                            //         const Duration(seconds: 1),
                            //         () => controller.isResultCalculated.value =
                            //             true);
                            //   },
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
