import 'dart:math' as math;
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

import '../../helper/user_result_preview2.dart';

late MyNewChallengeController _myNewChallengeController;
class FinalResultScreen2 extends StatefulWidget {
  const FinalResultScreen2({super.key, });
  @override
  State<FinalResultScreen2> createState() => _FinalResultScreen2State();
}
class _FinalResultScreen2State extends State<FinalResultScreen2> {
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
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: CustomTextWidget(
                    text:
                         "Final Results",

                    textColor: MyColorHelper.white,
                    fontFamily: "Horta",
                    fontSize: 40,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        _myNewChallengeController.startRound(false);
                        _myNewChallengeController.loaderRoundEntered(false);
                        MySnackBarsHelper.showMessage("Enjoy game by creating challenge", "Create new challenge ", Icons.mic,);


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
                        Expanded(child: UserResultPreview2(myNewChallengeController:_myNewChallengeController,)),
                        Expanded(child: MyRadarChart(showBlurBackground: true)),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(child: UserResultPreview2(myNewChallengeController: _myNewChallengeController,)),
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