import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/next_round_button.dart';
import 'package:sound_app/helper/user_result_card.dart';
import 'package:sound_app/view/dashboard/main_challenge_screen.dart';

import '../models/challenge_model.dart';

class UsersResultPreview extends StatefulWidget {
  final ChallengeModel challengeModel;

  final MyNewChallengeController myNewChallengeController;
  const UsersResultPreview({Key? key, required this.myNewChallengeController, required this.challengeModel, }) : super(key: key);

  @override
  _UsersResultPreviewState createState() => _UsersResultPreviewState();
}

class _UsersResultPreviewState extends State<UsersResultPreview>
    with AutomaticKeepAliveClientMixin {
  final CarouselController carouselController = CarouselController();
  late ConfettiController confettiController;
  final RxBool isFirstIndex = true.obs;


  //TODO:Change this time to 60
  int countDown = 60;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController();
    isFirstIndex.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      confettiController.play();
    });
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                carouselController: carouselController,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.25,
                  enlargeCenterPage: false,
                  viewportFraction: 0.7,
                  initialPage: 0,
                  onPageChanged: onPageChanged,
                ),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index, _) {
                  return UserResultCard(index: index);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              buildCarouselControls(),
            ],
          ),
        ),
        Obx(() {
          return isFirstIndex.value
              ? ConfettiWidget(
                  confettiController: confettiController,
                  shouldLoop: true,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 40,
                  colors: const [Colors.green, Colors.blue, Colors.pink],
                )
              : const SizedBox();
        }),
      ],
    );
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    if (index == 0) {
      isFirstIndex.value = true;
      confettiController.play();
    } else {
      isFirstIndex.value = false;
      confettiController.stop();
    }
  }

  Widget buildCarouselControls() {
    return Column(
      children: [


        if (widget.myNewChallengeController.gameCompleted.value ==  false  && widget.myNewChallengeController.roundValue.value < widget.challengeModel.roundsCount!)
          NextRoundButton(
            text: 'Next Round',
            onTap: () {
              widget.myNewChallengeController.nextButton(true);

              widget.myNewChallengeController.startRound(false);

              widget.myNewChallengeController.increaseRound(
                  widget.challengeModel.roundsCount!);

              Get.off(() => MainChallengeScreen(
                  challengeModel: widget.challengeModel));
            },
            color: MyColorHelper.verdigris,
          ),
        const SizedBox(height:  14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildCarouselControl(
                MyAssetHelper.rankLeft, carouselController.previousPage),
            if (widget.myNewChallengeController.gameCompleted.value ==
                false
            &&
            widget.myNewChallengeController.roundValue.value <
            widget.challengeModel.roundsCount!
            )
              CircularCountDownTimer(
                duration: countDown,
                initialDuration: 0,
                width: context.width * 0.2,
                height: context. height * 0.05,
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
                  widget.myNewChallengeController.increaseRound(
                      widget.challengeModel.roundsCount!);
                  widget.myNewChallengeController.startRound(false);

                  Get.off(MainChallengeScreen(
                      challengeModel: widget.challengeModel
                  ));
                },
                onChange: (String timeStamp) {},
              ),


            buildCarouselControl(
                MyAssetHelper.rankRight, carouselController.nextPage),
          ],
        ),

      ],
    );
  }

  Widget buildCarouselControl(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        height: 40,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
