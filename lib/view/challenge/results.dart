import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/challenge_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/result_model.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/view/challenge/widgets/bar_chart.dart';
import 'package:sound_app/view/challenge/widgets/user_result_card.dart';
import 'package:sound_app/view/home_screen.dart';

class ResultScreen extends StatelessWidget {
  final ResultModel model;

  const ResultScreen({super.key, required this.model});

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
                title: const CustomTextWidget(
                  text: "Results",
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
                    child: const CustomTextWidget(
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
                  Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: UserResultPreview(
                            model: model,
                            isOverAllResult: false,
                          )),
                      // const Expanded(
                      //     child: MyRadarChart(showBlurBackground: true)),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                          child: UserResultPreview(
                        model: model,
                        isOverAllResult: true,
                      )),
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

class UserResultPreview extends StatefulWidget {
  final ResultModel model;
  final bool isOverAllResult;

  const UserResultPreview({
    super.key,
    required this.model,
    required this.isOverAllResult,
  });

  @override
  State<UserResultPreview> createState() => _UserResultPreviewState();
}

class _UserResultPreviewState extends State<UserResultPreview>
    with AutomaticKeepAliveClientMixin {
  final ChallengeController controller = Get.find();
  final CarouselController carouselController = CarouselController();
  late ConfettiController confettiController;
  final RxBool isFirstIndex = true.obs;
  Timer? _timer;
  bool timerCompleted = false;
  RxInt currentIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _startTimer();
    confettiController = ConfettiController();
    isFirstIndex.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      confettiController.play();
    });
  }

  void _startTimer() {
    if (!controller.isChallengeCompleted.value) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (controller.countdownForNextRound.value > 0) {
          controller.countdownForNextRound.value--;
        } else {
          _timer?.cancel();
          timerCompleted = true;
          controller.countdownForNextRound.value = 60;

          controller.resetControllerValues();
        }
      });
    }
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
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.isOverAllResult
                ? const SizedBox()
                : SizedBox(height: context.height * 0.1),
            CarouselSlider.builder(
              carouselController: carouselController,
              options: CarouselOptions(
                enlargeCenterPage: true,
                viewportFraction: 0.6,
                enableInfiniteScroll: false,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  currentIndex.value = index;
                },
              ),
              itemCount: widget.model.usersResult!.length,
              itemBuilder: (BuildContext context, int index, _) {
                return UserResultCard(
                  index: index,
                  resultModel: widget.model,
                );
              },
            ),
            buildCarouselControls(),
            widget.isOverAllResult
                ? const SizedBox()
                : Obx(
                    () => CustomAuthButton(
                      isLoading: false,
                      text: MyAppStorage.userId ==
                              widget.model.usersResult
                                  ?.map((e) => e.participant?.id)
                          ? 'Next Round'
                          : 'Exit',
                      onTap: () {},
                    ),
                  ),
            widget.isOverAllResult
                ? const SizedBox()
                : SizedBox(height: context.height * 0.1),
          ],
        ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildCarouselControl(
            MyAssetHelper.rankLeft, carouselController.previousPage),
        Visibility(
          visible: !controller.isChallengeCompleted.value,
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
            child: Center(
              child: Obx(
                () => Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: controller.countdownForNextRound.value / 60,
                      strokeWidth: 4.0,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          MyColorHelper.caribbeanCurrent),
                    ),
                    CustomTextWidget(
                      text: controller.countdownForNextRound.value.toString(),
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      textColor: MyColorHelper.caribbeanCurrent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        buildCarouselControl(
            MyAssetHelper.rankRight, carouselController.nextPage),
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
