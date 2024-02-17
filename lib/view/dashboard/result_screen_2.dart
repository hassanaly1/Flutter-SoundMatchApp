import 'dart:math' as math;
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/bar_chart.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/players_result_preview.dart';
import 'package:sound_app/helper/radar_chart.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/view/dashboard/home_screen.dart';

late MyNewChallengeController _myNewChallengeController;
class ResultScreen2 extends StatefulWidget {
  final ChallengeModel challengeModel;
 const ResultScreen2({super.key, required this.challengeModel, });
  @override
  State<ResultScreen2> createState() => _ResultScreen2State();
}
class _ResultScreen2State extends State<ResultScreen2> {
  @override
  void initState() {
    _myNewChallengeController = Get.put(MyNewChallengeController());
    _myNewChallengeController.loaderRoundEnteredMethod(true);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            MyAssetHelper.backgroundImage,
            fit: BoxFit.fill,
          ),
          DefaultTabController(
            length: 2,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: CustomTextWidget(
                    text: _myNewChallengeController.gameCompleted.value
                        ? "Final Result"
                        : "Round ${_myNewChallengeController.roundValue.value} RESULT",
                    textColor: MyColorHelper.white,
                    fontFamily: "Horta",
                    fontSize: 40,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.off(const HomeScreen());
                        _myNewChallengeController.startRound(false);
                        _myNewChallengeController.loaderRoundEntered(false);
                        MySnackBarsHelper.showMessage("Challenge has been ended", "Exit ", Icons.done_all,);

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
                     Column(
                      children: [
                        Expanded(child: UsersResultPreview(myNewChallengeController:_myNewChallengeController,challengeModel:widget.challengeModel ,)),
                        Expanded(child: MyRadarChart(showBlurBackground: true)),
                      ],
                                         ),
                    Column(
                      children: [
                         Expanded(child: UsersResultPreview(myNewChallengeController: _myNewChallengeController,challengeModel:widget.challengeModel ,)),
                        Expanded(child: MyBarChart(showBlurBackground: true)),
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
///Bar End