import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/view/dashboard/main_challenge_screen.dart';
import 'package:sound_app/view/dashboard/ranks_tabs.dart';

class RanksScreen extends StatefulWidget {
  final ChallengeModel challengeModel;

  final bool isDefault;

  const RanksScreen(
      {super.key, required this.isDefault, required this.challengeModel});

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  MyNewChallengeController _myNewChallengeController = Get.find();

  int countDown = 5;
  int roundCount = 4;

  @override
  void initState() {
    _myNewChallengeController = Get.find();
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            MyAssetHelper.ranksBackground,
            fit: BoxFit.fill,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.off(MainChallengeScreen(
                                challengeModel: widget.challengeModel));
                          },
                          child: const Icon(
                            CupertinoIcons.back,
                            color: MyColorHelper.white,
                            size: 28,
                          )),
                      CustomTextWidget(
                        text: _myNewChallengeController.gameCompleted.value
                            ? "Final Result"
                            : "Round ${_myNewChallengeController.roundValue.value} RESULT",
                        fontFamily: "Horta",
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        textColor: MyColorHelper.white,
                      ),
                      const Icon(
                        CupertinoIcons.back,
                        color: Colors.transparent,
                        size: 28,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.07),
                  Center(
                    child: CustomTextWidget(
                      text: "PLAYERS",
                      shadow: const [],
                      fontSize: 20,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                      textColor: MyColorHelper.primaryColor,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  CarouselSlider.builder(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: 210,
                      enlargeCenterPage: false,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: widget.isDefault ? false : true,
                    ),
                    itemCount: widget.isDefault
                        ? 1
                        : _myNewChallengeController.rank.length,
                    itemBuilder: (BuildContext context, int index, _) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              MyAssetHelper.rankContainerBackground,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height:
                                  60, // Adjust the height and width as needed
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover, // Adjust the fit as needed
                                  image: NetworkImage(
                                    _myNewChallengeController
                                        .rank[index].profilePath!,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    text: _myNewChallengeController
                                        .rank[index].name!,
                                    shadow: const [],
                                    fontFamily: "Horta",
                                    textColor: MyColorHelper.primaryColor,
                                    fontSize: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: LinearPercentIndicator(
                                        width: width * 0.32,
                                        lineHeight: 14.0,
                                        percent: _myNewChallengeController
                                                .rank[index].accuracy! /
                                            100,
                                        center: Text(
                                          " ${_myNewChallengeController.rank[index].accuracy}%",
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Horta"),
                                        ),
                                        restartAnimation: true,
                                        animation: true,
                                        barRadius: const Radius.circular(6),
                                        backgroundColor: Colors.grey[300],
                                        progressColor:
                                            MyColorHelper.primaryColor),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomTextWidget(
                                        text: "Accuracy:",
                                        fontFamily: "Horta",
                                        textColor: MyColorHelper.primaryColor,
                                        fontSize: 20,
                                      ),
                                      CustomTextWidget(
                                        text:
                                            " ${_myNewChallengeController.rank[index].accuracy}%",
                                        shadow: const [],
                                        fontFamily: "Horta",
                                        textColor: MyColorHelper.primaryColor,
                                        fontSize: 30,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _carouselController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Image.asset(
                          MyAssetHelper.rankLeft,
                          height: 50,
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(const RanksTabs(),
                                  transition: Transition.downToUp);
                            },
                            child: Container(
                              height: height * 0.07,
                              padding: EdgeInsets.all(height * 0.015),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: MyColorHelper.primaryColor),
                                color: MyColorHelper.primaryColor,
                              ),
                              child: Image.asset(MyAssetHelper.pcRank),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          CustomTextWidget(
                            text: "Ranks",
                            textColor: MyColorHelper.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _carouselController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Image.asset(
                          MyAssetHelper.rankRight,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_myNewChallengeController.gameCompleted.value == false &&
                      _myNewChallengeController.roundValue.value < roundCount)
                    CircularCountDownTimer(
                      duration: countDown,
                      initialDuration: 0,
                      width: width * 0.2,
                      height: height * 0.08,
                      ringColor: MyColorHelper.lightBlue,
                      ringGradient: null,
                      fillColor: MyColorHelper.primaryColor,
                      fillGradient: null,
                      backgroundColor: MyColorHelper.container,
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
                      autoStart: true,
                      onStart: () {},
                      onComplete: () {
                        _myNewChallengeController
                            .increaseRound(widget.challengeModel.roundsCount!);
                        _myNewChallengeController.startRound(false);

                        debugPrint(
                            "------------->${_myNewChallengeController.roundValue.value}");

                        Get.off(MainChallengeScreen(
                            challengeModel: widget.challengeModel));
                      },
                      onChange: (String timeStamp) {},
                    ),
                  const SizedBox(height: 20),
                  if (_myNewChallengeController.gameCompleted.value == false &&
                      _myNewChallengeController.roundValue.value <
                          widget.challengeModel.roundsCount!)
                    CustomAuthButton(
                      text: 'Next Round',
                      onTap: () {
                        _myNewChallengeController.nextButton(true);
                        debugPrint(
                            "----------------> next button pressed${_myNewChallengeController.nextButtonPressed}");

                        debugPrint("------------->ontap next round");

                        _myNewChallengeController.startRound(false);

                        _myNewChallengeController
                            .increaseRound(widget.challengeModel.roundsCount!);

                        debugPrint(
                            "------------->next round${_myNewChallengeController.roundValue.value}");

                        Get.off(() => MainChallengeScreen(
                            challengeModel: widget.challengeModel));
                      },
                      color: MyColorHelper.verdigris,
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
