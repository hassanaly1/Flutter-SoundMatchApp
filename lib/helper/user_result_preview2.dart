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

class UserResultPreview2 extends StatefulWidget {

  final MyNewChallengeController myNewChallengeController;
  const UserResultPreview2({Key? key, required this.myNewChallengeController, }) : super(key: key);

  @override
  _UserResultPreview2State createState() => _UserResultPreview2State();
}

class _UserResultPreview2State extends State<UserResultPreview2>
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


        const SizedBox(height:  14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildCarouselControl(
                MyAssetHelper.rankLeft, carouselController.previousPage),


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
