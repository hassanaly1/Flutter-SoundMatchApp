import 'dart:ui';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/user_result_card.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/view/dashboard/home_screen.dart';
import 'package:sound_app/view/dashboard/main_challenge_screen.dart';
import 'package:sound_app/view/dashboard/ranks_tabs.dart';

class ResultScreen extends StatefulWidget {
  final ChallengeModel challengeModel;

  const ResultScreen({super.key, required this.challengeModel});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late MyNewChallengeController _myNewChallengeController;


  //TODO:Change this time to 60
  int countDown = 60;

  @override
  void initState() {
    _myNewChallengeController = Get.find();
    _myNewChallengeController.loaderRoundEnteredMethod(true);


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //dummy cancel for space
                            CustomTextWidget(
                              text: 'Cancel ',
                              textColor: Colors.transparent,
                              fontFamily: "Horta",
                              fontSize: 30,
                            ),
                            CustomTextWidget(
                              text: 'Results',
                              textColor: Colors.transparent,
                              fontFamily: "Horta",
                              fontSize: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.off(const HomeScreen());
                                _myNewChallengeController.startRound(false);
                                _myNewChallengeController.loaderRoundEntered(false);

                              },
                              child: CustomTextWidget(
                                text: 'Exit',
                                textColor: MyColorHelper.white,
                                fontFamily: "Horta",
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomTextWidget(
                        text: 'Final Results ',
                        textColor: Colors.transparent,
                        fontFamily: "Horta",
                        fontSize: 36,
                      ),
                      CustomTextWidget(
                        text: _myNewChallengeController.gameCompleted.value
                            ? "Final Result"
                            : "Round ${_myNewChallengeController.roundValue.value} RESULT",
                        textColor: Colors.white,
                        fontFamily: 'horta',
                        fontSize: 24.0,
                      ),
                      SizedBox(height: context.height * 0.01),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.white60)),
                                height: context.height * 0.3,
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 6,
                                    itemBuilder: (context, index) {
                                      return const UserResultCard(index: 0,);
                                    },
                                  ),
                                )),
                          ),
                          SizedBox(width: context.width * 0.02),
                          Expanded(
                            child: Container(
                                height: context.height * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(20)),
                                //  here is STAR Graph
                                child: const RadarChartSample1(
                                    showBlurBackground: false)),
                          ),
                        ],
                      ),
                      SizedBox(height: context.height * 0.015),
                      if (_myNewChallengeController.gameCompleted.value ==
                              false &&
                          _myNewChallengeController.roundValue.value <
                              widget.challengeModel.roundsCount!)
                        CircularCountDownTimer(
                          duration: countDown,
                          initialDuration: 0,
                          width: width * 0.2,
                          height: height * 0.05,
                          ringColor: MyColorHelper.lightBlue,
                          ringGradient: null,
                          fillColor: MyColorHelper.primaryColor,
                          fillGradient: null,
                          backgroundColor: MyColorHelper.container,
                          backgroundGradient: null,
                          strokeWidth: 12.0,
                          strokeCap: StrokeCap.round,
                          textStyle: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                          textFormat: CountdownTextFormat.S,
                          isReverse: false,
                          isReverseAnimation: false,
                          isTimerTextShown: true,
                          autoStart: true,
                          onStart: () {},
                          onComplete: () {
                            _myNewChallengeController.increaseRound(
                                widget.challengeModel.roundsCount!);
                            _myNewChallengeController.startRound(false);

                            Get.off(MainChallengeScreen(
                                challengeModel: widget.challengeModel));
                          },
                          onChange: (String timeStamp) {},
                        ),
                      const SizedBox(height: 20),
                      if (_myNewChallengeController.gameCompleted.value ==
                              false &&
                          _myNewChallengeController.roundValue.value <
                              widget.challengeModel.roundsCount!)
                        CustomAuthButton(
                          text: 'Next Round',
                          onTap: () {
                            _myNewChallengeController.nextButton(true);

                            _myNewChallengeController.startRound(false);

                            _myNewChallengeController.increaseRound(
                                widget.challengeModel.roundsCount!);

                            Get.off(() => MainChallengeScreen(
                                challengeModel: widget.challengeModel));
                          },
                          color: MyColorHelper.verdigris,
                        ),
                      SizedBox(height: context.height * 0.01),
                      CustomTextWidget(
                        text: 'Overall Rounds Progress',
                        textColor: Colors.white,
                        fontFamily: 'horta',
                        fontSize: 24.0,
                      ),
                      SizedBox(height: context.height * 0.01),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.white60)),
                                height: context.height * 0.32,
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 6,
                                    itemBuilder: (context, index) {
                                      return const UserResultCard(index: 0,);
                                    },
                                  ),
                                )),
                          ),
                          SizedBox(width: context.width * 0.02),
                          Expanded(
                            child: Container(
                                height: context.height * 0.32,
                                decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(20)),
                                //  here is STAR Graph
                                child:
                                    BarChartSample7(showBlurBackground: false)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
