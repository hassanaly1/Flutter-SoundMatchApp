import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/audio_player.dart';
import 'package:sound_app/helper/bottom_profile_list_view.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_pop_up.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/profile_list_view.dart';
import 'package:sound_app/helper/ranks_loader.dart';
import 'package:sound_app/helper/round_pop_up.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/member_model.dart';
import 'package:sound_app/models/profile.dart';

import 'package:sound_app/view/dashboard/ranks_tabs.dart';
import 'package:sound_app/view/dashboard/result_screen.dart';
import 'package:sound_app/view/dashboard/result_screen_2.dart';
import 'package:sound_app/view/dashboard/sharing_screen.dart';


class MainChallengeScreen extends StatefulWidget {
  final ChallengeModel challengeModel;

  const MainChallengeScreen({
    super.key,
    required this.challengeModel,
  });

  @override
  State<MainChallengeScreen> createState() => _MainChallengeScreenState();
}

class _MainChallengeScreenState extends State<MainChallengeScreen> {
  late AudioPlayerService _leaderAudioPlayerService;
  late AudioPlayerService _userAudioPlayerService;




  Future<void> _initAudioPlayers() async {
    // await _leaderAudioPlayerService.initAudioPlayer('assets/music/music1.mp3');
    // await _userAudioPlayerService.initAudioPlayer('assets/music/music2.mp3');
    await _leaderAudioPlayerService.initAudioPlayer('');
    await _userAudioPlayerService.initAudioPlayer('');
  }

  final CountDownController countDownController1 = CountDownController();
  final ScrollController scrollController = ScrollController();
  MyNewChallengeController _myNewChallengeController = Get.find();

  @override
  void initState() {
    _leaderAudioPlayerService = AudioPlayerService();
    _userAudioPlayerService = AudioPlayerService();
    _initAudioPlayers();
    _myNewChallengeController.makeIndexZero();
    _myNewChallengeController. makeIndexAllZero();
   _myNewChallengeController.showFirstBorderMethod(false);
    _myNewChallengeController.showSecondBorderMethod(false);
    _myNewChallengeController.showThirdBorderMethod(false);
    _myNewChallengeController.startRound(false);



    if (_myNewChallengeController.loaderRoundEntered.value) {
      _myNewChallengeController.loaderWaitingMethod(true);

      Future.delayed(const Duration(seconds: 10), () {
        _myNewChallengeController.loaderWaitingMethod(false);

      }).then((value) {
        _myNewChallengeController.loaderRoundEnteredMethod(false);
      });


    }
    Future.delayed(const Duration(seconds: 5), () {
      _myNewChallengeController.startRound(true);
    });
    _myNewChallengeController.nextButton(false);


    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyNewChallengeController>();
    // _timer.cancel();
    _leaderAudioPlayerService.dispose();
    _userAudioPlayerService.dispose();
    super.dispose();
  }


  
      // Timer for each person
  //TODO:Change this time to 30
  int timerForEachPerson = 30;



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    MyProfile profile = new MyProfile();

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            MyAssetHelper.backgroundImage,
            fit: BoxFit.fill,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Leader Portion
                      LeaderContainer(height, width, context),

                      Obx(
                        () => _myNewChallengeController.loaderWaiting.value ==
                                true
                            ? SizedBox(
                                width: Get.width * 0.7,
                                child: DefaultTextStyle(
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Horta',
                                      color: MyColorHelper.white),
                                  child: AnimatedTextKit(
                                    isRepeatingAnimation: true,
                                    repeatForever: true,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                          textAlign: TextAlign.center,
                                          "waiting for other players"),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  decoration: const BoxDecoration(
                                      color: Colors.white60),
                                  child: CustomTextWidget(
                                      text:
                                          "Round # ${_myNewChallengeController.roundValue.value}",
                                      fontFamily: 'poppins',
                                      textColor: MyColorHelper.tabColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                      ),

                      // Main Challenge Portion
                      Obx(
                        () => _myNewChallengeController.think.value == false
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Left Profile Section
                                  Obx(
                                    () => ProfileListView(
                                      showBorder: _myNewChallengeController
                                          .firstBorder.value,
                                      currentIndex: _myNewChallengeController
                                          .indexAll.value,
                                      height: height,
                                      profiles:
                                          widget.challengeModel.leftProfiles!,
                                      myNewChallengeController:
                                          _myNewChallengeController,
                                    ),
                                  ),

                                  //Middle Mic and audio section
                                  Obx(
                                    () => Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    _myNewChallengeController
                                                            .isUserPlaying.value
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  _userAudioPlayerService
                                                                      .audioPlayer
                                                                      .pause();

                                                                  _myNewChallengeController
                                                                      .userTogglePlayer(
                                                                          false);
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .pause)),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
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
                                                                .isUserPlaying
                                                                .value,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    // Display the countdown timer
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        _myNewChallengeController
                                                .isMicPressed.value
                                            ? Lottie.asset(
                                                MyAssetHelper.musicLoading,
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.fill,
                                              )
                                            : Container(),
                                        GestureDetector(
                                          onLongPress: () {
                                            _myNewChallengeController .micPressed(true);


                                            _myNewChallengeController.audioFileInvisible();


                                          },
                                          onLongPressEnd: (details) {
                                            _myNewChallengeController.audioFileVisible();

                                            _myNewChallengeController.micPressed(false);
                                            _myNewChallengeController.nextTimer(countDownController1,widget.challengeModel.leftProfiles!,widget.challengeModel.rightProfiles!,

                                              widget.challengeModel.bottomProfiles!,widget.challengeModel.participants!.length,scrollController,context);



                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(20),
                                            height: height * 0.18,
                                            width: width * 0.23,
                                            child: Image.asset(
                                              MyAssetHelper.mic,
                                            ),
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
                                          ),
                                        ),
                                        CircularCountDownTimer(
                                          duration: timerForEachPerson,
                                          initialDuration: 1,
                                          controller: countDownController1,
                                          width: width * 0.2,
                                          height: height * 0.08,
                                          ringColor: MyColorHelper.lightBlue,
                                          ringGradient: null,
                                          fillColor: MyColorHelper.primaryColor,
                                          fillGradient: null,
                                          backgroundColor:
                                              MyColorHelper.container,
                                          backgroundGradient: null,
                                          strokeWidth: 15.0,
                                          strokeCap: StrokeCap.round,
                                          textStyle: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textFormat: CountdownTextFormat.S,
                                          isReverse: false,
                                          isReverseAnimation: false,
                                          isTimerTextShown: true,
                                          autoStart: false,
                                          onStart: () {},
                                          onComplete: () {},
                                          onChange: (String timeStamp) {},
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.03,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(
                                    () => ProfileListView(
                                      showBorder: _myNewChallengeController
                                          .secondBorder.value,
                                      currentIndex: _myNewChallengeController
                                          .indexAll.value-3,
                                      height: height,
                                      profiles:
                                          widget.challengeModel.rightProfiles!,
                                      myNewChallengeController:
                                          _myNewChallengeController,
                                    ),
                                  )
                                ],
                              )
                            : RanksLoader(height: height),
                      ),

                      // Bottom Blue Profile List Screen
                      Obx(
                        () => BottomProfileSection(
                          myNewChallengeController: _myNewChallengeController,
                          widget: widget,
                          height: height,
                          scrollController: scrollController,
                          currentIndex:
                              _myNewChallengeController.indexAll.value-6,
                          showBorder:
                              _myNewChallengeController.thirdBorder.value,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Round Start Pop Up
          RoundStartPopUp(myNewChallengeController: _myNewChallengeController)
        ],
      ),
    );
  }

  Container LeaderContainer(double height, double width, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage(
          MyAssetHelper.leaderBackground,
        ),
      )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OpenContainer(
                openColor: Colors.transparent,
                closedColor: Colors.transparent,
                transitionDuration: const Duration(milliseconds: 500),
                closedBuilder: (context, action) {
                  return IconButton(
                    onPressed: action,
                    icon: const Icon(CupertinoIcons.chart_pie_fill,
                        color: MyColorHelper.white),
                  );
                },
                openBuilder: (context, action) {
                  return const RadarChartSample1(showBlurBackground: true);
                },
                openElevation: 0,
                closedElevation: 0,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              Expanded(
                child: CustomTextWidget(
                    text: widget.challengeModel.challengeName!,
                    fontFamily: "Horta",
                    textAlign: TextAlign.center,
                    textColor: MyColorHelper.white,
                    fontSize: 30),
              ),
              OpenContainer(
                openColor: Colors.transparent,
                closedColor: Colors.transparent,
                transitionDuration: const Duration(milliseconds: 500),
                closedBuilder: (context, action) {
                  return IconButton(
                    onPressed: action,
                    icon: const Icon(CupertinoIcons.chart_bar_alt_fill,
                        color: MyColorHelper.white),
                  );
                },
                openBuilder: (context, action) {
                  return BarChartSample7(showBlurBackground: true);
                },
                openElevation: 0,
                closedElevation: 0,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Image.asset(MyAssetHelper.personPlaceholder),
                    ),
              Obx(
                () => Container(
                  margin: const EdgeInsets.all(6),
                  height: height * 0.06,
                  width: width * 0.35,
                  decoration: BoxDecoration(
                      color: MyColorHelper.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      _myNewChallengeController.isLeaderPlaying.value
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    _leaderAudioPlayerService.audioPlayer
                                        .pause();
                                    _myNewChallengeController
                                        .leaderTogglePlayer(false);
                                  },
                                  child: const Icon(Icons.pause)),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    _leaderAudioPlayerService.audioPlayer
                                        .play();

                                    _myNewChallengeController
                                        .leaderTogglePlayer(true);
                                  },
                                  child: const Icon(Icons.play_arrow)),
                            ),
                      Expanded(
                          child: Lottie.asset(
                              "assets/images/audioAnimation.json",
                              animate: _myNewChallengeController
                                  .isLeaderPlaying.value,
                              fit: BoxFit.fill,
                              height: height * 0.03)),
                    ],
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
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {


                  widget.challengeModel.participants!.isNotEmpty&&_myNewChallengeController.loaderWaiting.value==false
                      ? _myNewChallengeController.timerStart1(widget.challengeModel.participants!.length,
                      widget.challengeModel.leftProfiles!,widget.challengeModel.rightProfiles!,

                      widget.challengeModel.bottomProfiles!,countDownController1,

                    widget.challengeModel,scrollController,context


                  )
                      :_myNewChallengeController.loaderWaiting.value? MySnackBarsHelper.showMessage(
                          "Please wait until all members arrived",
                          "Waiting",
                          CupertinoIcons.person_2):MySnackBarsHelper.showMessage(
                      "Please add members to start",
                      "Add Members",
                      CupertinoIcons.mic);
                },
                child: Container(
                  height: height * 0.06,
                  width: width * 0.22,
                  decoration: BoxDecoration(
                      color: MyColorHelper.primaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: CustomTextWidget(
                      text: "Start",
                      // text: _myNewChallengeController.roundValue.value.toString(),
                      textColor: MyColorHelper.white,
                      fontFamily: "Poppins",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





