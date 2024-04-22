import 'dart:ui';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/challenge_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/challenge/widgets/bar_chart.dart';
import 'package:sound_app/view/challenge/widgets/radar_chart.dart';
import 'package:sound_app/view/challenge/widgets/user_result_card.dart';
import 'package:sound_app/view/home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
        DefaultTabController(
          length: 2,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: CustomTextWidget(
                  text: "Final Results",
                  textColor: MyColorHelper.white,
                  fontFamily: "Horta",
                  fontSize: 40,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.offAll(() => const HomeScreen());
                      Get.delete<ChallengeController>();
                    },
                    child: CustomTextWidget(
                      text: 'Exit',
                      textColor: MyColorHelper.white,
                      fontFamily: "Horta",
                      fontSize: 26,
                    ),
                  )
                ],
                backgroundColor: Colors.transparent,
                bottom: TabBar(
                  isScrollable: false,
                  tabAlignment: TabAlignment.center,
                  indicatorColor: MyColorHelper.primaryColor,
                  labelColor: MyColorHelper.white,
                  labelStyle: const TextStyle(
                    color: MyColorHelper.white,
                    fontFamily: "Horta",
                    fontSize: 20,
                  ),
                  unselectedLabelColor: MyColorHelper.white,
                  unselectedLabelStyle: const TextStyle(
                    color: MyColorHelper.white,
                    fontFamily: "Horta",
                    fontSize: 14,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: const Border(
                      right: BorderSide.none,
                      left: BorderSide.none,
                      bottom: BorderSide(
                        color: MyColorHelper.white,
                        width: 5.0,
                      ),
                    ),
                    color: MyColorHelper.tabColor,
                  ),
                  tabs: const [
                    Tab(text: 'Last Round Individual Results'),
                    Tab(text: 'Overall Game Progress'),
                  ],
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const Column(
                    children: [
                      Expanded(child: UserResultPreview2()),
                      Expanded(child: MyRadarChart(showBlurBackground: true)),
                    ],
                  ),
                  Column(
                    children: [
                      const Expanded(child: UserResultPreview2()),
                      Expanded(child: MyBarChart(showBlurBackground: true)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class UserResultPreview2 extends StatefulWidget {
  const UserResultPreview2({
    super.key,
  });

  @override
  _UserResultPreview2State createState() => _UserResultPreview2State();
}

class _UserResultPreview2State extends State<UserResultPreview2>
    with AutomaticKeepAliveClientMixin {
  final CarouselController carouselController = CarouselController();
  late ConfettiController confettiController;
  final RxBool isFirstIndex = true.obs;

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
        const SizedBox(height: 14),
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
