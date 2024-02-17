import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/audio_player.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/view/dashboard/final_result_screen.dart';
import 'package:sound_app/view/dashboard/final_result_screen2.dart';

late MyNewChallengeController _myNewChallengeController;

class DefaultMatchScreen extends StatefulWidget {
  final ChallengeModel challengeModel;
  const DefaultMatchScreen({super.key, required this.challengeModel});

  @override
  State<DefaultMatchScreen> createState() => _DefaultMatchScreenState();
}

class _DefaultMatchScreenState extends State<DefaultMatchScreen> {
  late AudioPlayerService _leaderAudioPlayerService;
  late AudioPlayerService _userAudioPlayerService;

  late Timer _timer;

  Future<void> _initAudioPlayers() async {
    // await _leaderAudioPlayerService.initAudioPlayer('assets/music/music1.mp3');
    // await _userAudioPlayerService.initAudioPlayer('assets/music/music2.mp3');
    await _leaderAudioPlayerService.initAudioPlayer('');
    await _userAudioPlayerService.initAudioPlayer('');
  }

  @override
  void initState() {
    _myNewChallengeController = Get.put(MyNewChallengeController());
    _leaderAudioPlayerService = AudioPlayerService();
    _userAudioPlayerService = AudioPlayerService();
    _initAudioPlayers();
    _currentList = [];
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    Get.delete<MyNewChallengeController>();
    // _timer.cancel();
    _leaderAudioPlayerService.dispose();
    _userAudioPlayerService.dispose();
    super.dispose();
  }

  late List<int> _currentList;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 30.0),

                        // height: height*0.25,
                        // padding: const EdgeInsets.all(10.0),

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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomTextWidget(
                                      text: "Free Sound Match",
                                      fontFamily: "Horta",
                                      textColor: MyColorHelper.white,
                                      fontSize: 32),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyAssetHelper.lead != ""
                                      ? CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            MyAssetHelper.lead,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                              MyAssetHelper.personPlaceholder),
                                        ),
                                  Obx(
                                    () => Container(
                                      margin: const EdgeInsets.all(6),
                                      height: height * 0.06,
                                      width: width * 0.35,
                                      decoration: BoxDecoration(
                                          color: MyColorHelper.white,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Row(
                                        children: [
                                          _myNewChallengeController
                                                  .isLeaderPlaying.value
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        print(
                                                            "onTap on audio button");
                                                        _leaderAudioPlayerService
                                                            .audioPlayer
                                                            .pause();
                                                        _myNewChallengeController
                                                            .leaderTogglePlayer(
                                                                false);
                                                      },
                                                      child: const Icon(
                                                          Icons.pause)),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        _leaderAudioPlayerService
                                                            .audioPlayer
                                                            .play();

                                                        _myNewChallengeController
                                                            .leaderTogglePlayer(
                                                                true);
                                                      },
                                                      child: const Icon(
                                                          Icons.play_arrow)),
                                                ),
                                          Expanded(
                                              child: Lottie.asset(
                                                  "assets/images/audioAnimation.json",
                                                  animate:
                                                      _myNewChallengeController
                                                          .isLeaderPlaying
                                                          .value,
                                                  fit: BoxFit.fill,
                                                  height: height * 0.03)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.off(FinalResultScreen2(),
                                          transition: Transition.downToUp);
                                    },
                                    child: Image.asset(
                                      MyAssetHelper.rank,
                                      height: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  _myNewChallengeController
                                          .isAudioFileVisible.value
                                      ? Container(
                                          margin: const EdgeInsets.all(6),
                                          height: height * 0.06,
                                          width: width * 0.27,
                                          decoration: BoxDecoration(
                                            color: MyColorHelper.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _myNewChallengeController
                                                      .isUserPlaying.value
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            print(
                                                                "onTap on audio button");
                                                            _userAudioPlayerService
                                                                .audioPlayer
                                                                .pause();
                                                            _myNewChallengeController
                                                                .userTogglePlayer(
                                                                    false);
                                                          },
                                                          child: const Icon(
                                                              Icons.pause)),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            _userAudioPlayerService
                                                                .audioPlayer
                                                                .play();
                                                            _myNewChallengeController
                                                                .userTogglePlayer(
                                                                    true);
                                                          },
                                                          child: const Icon(
                                                              Icons
                                                                  .play_arrow)),
                                                    ),
                                              Expanded(
                                                child: Lottie.asset(
                                                  "assets/images/audioAnimation.json",
                                                  animate:
                                                      _myNewChallengeController
                                                          .isUserPlaying.value,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              // Display the countdown timer
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  _myNewChallengeController.isMicPressed.value
                                      ? Lottie.asset(
                                          MyAssetHelper.musicLoading,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(),
                                  GestureDetector(
                                    onLongPress: () {
                                      _myNewChallengeController.micPressed(true);
                                      _myNewChallengeController
                                          .audioFileInvisible();
                                    },
                                    onLongPressEnd: (details) {
                                      _myNewChallengeController.micPressed(false);

                                      _myNewChallengeController
                                          .audioFileVisible();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(20),
                                      height: height * 0.23,
                                      width: width * 0.23,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                30.0, // soften the shadow
                                            spreadRadius:
                                                8.0, // extend the shadow
                                            offset: Offset(
                                              5.0, // Move to right 5 horizontally
                                              5.0, // Move to bottom 5 Vertically
                                            ),
                                          )
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        MyAssetHelper.mic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          MySnackBarsHelper.showMessage(
                              "voice matching process completed ",
                              "See Result",
                              CupertinoIcons.mic);
                        },
                        child: Container(
                          height: height * 0.08,
                          width: width * 0.25,
                          decoration: BoxDecoration(
                              color:
                                  MyColorHelper.primaryColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: CustomTextWidget(
                              text: "Process",
                              textColor: MyColorHelper.white,
                              fontFamily: "Horta",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
