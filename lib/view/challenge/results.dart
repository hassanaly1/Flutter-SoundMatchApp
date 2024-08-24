import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sound_app/controller/challenge_controller.dart';
import 'package:sound_app/data/socket_service.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_auth_button.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/result_model.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/view/challenge/challenge.dart';
import 'package:sound_app/view/challenge/widgets/bar_chart.dart';
import 'package:sound_app/view/challenge/widgets/user_result_card.dart';
import 'package:sound_app/view/home_screen.dart';

class ResultScreen extends StatefulWidget {
  final ResultModel model;

  const ResultScreen({super.key, required this.model});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  io.Socket socket = SocketService().getSocket();
  final ChallengeController controller = Get.find();
  Timer? _timer;
  bool timerCompleted = false;

  @override
  void initState() {
    super.initState();
    // controller.isChallengeCompleted.value =
    //     widget.model.nextRoomUsers!.isEmpty ? true : false;
    controller.isChallengeCompleted.value =
        widget.model.nextRoom == null ? true : false;
    debugPrint(
        'isChallengeCompletedOnInitCheck: ${controller.isChallengeCompleted.value}');
    _startTimer();
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    if (!controller.isChallengeCompleted.value) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (controller.countdownForNextRound.value > 0) {
          controller.countdownForNextRound.value--;
        } else {
          _timer?.cancel();
          timerCompleted = true;
          controller.resetControllerValues();

          // if (controller.isChallengeCompleted.value) {
          //   Get.offAll(() => const HomeScreen());
          // }
          // Check user qualification and navigate accordingly
          bool isCurrentUserQualified = widget.model.nextRoomUsers?.any(
                  (user) =>
                      user.id ==
                      MyAppStorage.storage.read('user_info')['_id']) ??
              false;
          if (isCurrentUserQualified) {
            nextRoom();
          } else {
            Get.offAll(() => const HomeScreen());
            if (Get.isRegistered<ChallengeController>()) {
              Get.delete<ChallengeController>();
            }
          }
        }
      });
    }
  }

  void nextRoom() {
    Get.offAll(() => const ChallengeRoomScreen());
    String challengeRoomId = widget.model.nextRoom ?? '';
    debugPrint('Going to Next Room: $challengeRoomId');
    socket.emit(
      'entry_to_challenge_room',
      {
        'user_id': MyAppStorage.storage.read('user_info')['_id'],
        'room_id': challengeRoomId,
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(MyAssetHelper.backgroundImage, fit: BoxFit.cover),
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
                    text: "Round ${controller.currentRound.value} Results",
                    textColor: MyColorHelper.white,
                    fontFamily: "Horta",
                    fontSize: 30,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => const HomeScreen());
                        if (Get.isRegistered<ChallengeController>()) {
                          Get.delete<ChallengeController>();
                        }
                      },
                      child: const CustomTextWidget(
                        text: 'Exit',
                        textColor: MyColorHelper.white,
                        fontFamily: "Horta",
                        fontSize: 24,
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
                    UserResultPreview(
                      model: widget.model,
                      isOverAllResult: false,
                      timerCompleted: timerCompleted,
                      countdownValue: controller.countdownForNextRound,
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: UserResultPreview(
                            model: widget.model,
                            isOverAllResult: true,
                            timerCompleted: timerCompleted,
                            countdownValue: controller.countdownForNextRound,
                          ),
                        ),
                        Expanded(
                          child: MyBarChart(resultModel: widget.model),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserResultPreview extends StatefulWidget {
  final ResultModel model;
  final bool isOverAllResult;
  final bool timerCompleted;
  final RxInt countdownValue;

  const UserResultPreview({
    super.key,
    required this.model,
    required this.isOverAllResult,
    required this.timerCompleted,
    required this.countdownValue,
  });

  @override
  State<UserResultPreview> createState() => _UserResultPreviewState();
}

class _UserResultPreviewState extends State<UserResultPreview> {
  io.Socket socket = SocketService().getSocket();

  final ChallengeController controller = Get.find();

  final CarouselController carouselController = CarouselController();

  // late ConfettiController confettiController;
  @override
  Widget build(BuildContext context) {
    debugPrint(
        'IsChallengeCompleted: ${controller.isChallengeCompleted.value}');
    bool isCurrentUserQualified = widget.model.nextRoomUsers?.any((user) =>
            user.id == MyAppStorage.storage.read('user_info')['_id']) ??
        false;

    return Column(
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
            // onPageChanged: (index, reason) {
            //   currentIndex.value = index;
            // },
          ),
          itemCount: widget.model.usersResult!.length,
          itemBuilder: (BuildContext context, int index, _) {
            bool isQualified =
                widget.model.usersResult?[index].isQualified ?? false;
            return UserResultCard(
              index: index,
              resultModel: widget.model,
              isQualified: isQualified,
              isOverAllResult: widget.isOverAllResult,
            );
          },
        ),
        buildCarouselControls(),
        widget.isOverAllResult
            ? const SizedBox()
            : CustomAuthButton(
                isLoading: false,
                text: isCurrentUserQualified ? 'Next Round' : 'Exit',
                onTap: () {
                  isCurrentUserQualified
                      ? nextRoom()
                      : Get.offAll(() => const HomeScreen());
                },
              ),
        widget.isOverAllResult
            ? const SizedBox()
            : SizedBox(height: context.height * 0.1),
      ],
    );
  }

  void nextRoom() {
    Get.offAll(() => const ChallengeRoomScreen());
    String challengeRoomId = widget.model.nextRoom ?? '';
    debugPrint('Going to Next Room: $challengeRoomId');
    socket.emit(
      'entry_to_challenge_room',
      {
        'user_id': MyAppStorage.storage.read('user_info')['_id'],
        'room_id': challengeRoomId,
      },
    );
    Get.to(
      () => const ChallengeRoomScreen(),
    );
  }

  // void onPageChanged(int index, CarouselPageChangedReason reason) {
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
                      value: widget.countdownValue.value / 60,
                      strokeWidth: 4.0,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          MyColorHelper.caribbeanCurrent),
                    ),
                    CustomTextWidget(
                      text: widget.countdownValue.value.toString(),
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
}
