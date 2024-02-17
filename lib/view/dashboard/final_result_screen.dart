import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/user_result_card.dart';
import 'package:sound_app/view/dashboard/ranks_tabs.dart';
import 'package:sound_app/view/dashboard/result_screen.dart';

class FinalResultScreen extends StatefulWidget {
  //final ChallengeModel challengeModel;

  const FinalResultScreen({super.key});

  @override
  State<FinalResultScreen> createState() => _FinalResultScreenState();
}

class _FinalResultScreenState extends State<FinalResultScreen> {
  late MyNewChallengeController _myNewChallengeController;
  int countDown = 10;

  @override
  void initState() {
    _myNewChallengeController = Get.find();

    // TODO: implement initState
    super.initState();
  }

  int selectedDataSetIndex = -1;

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
                padding: const EdgeInsets.all(4.0),
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
                              text: 'Final Results ',
                              textColor: Colors.transparent,
                              fontFamily: "Horta",
                              fontSize: 36,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
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
                        textColor: MyColorHelper.white,
                        fontFamily: "Horta",
                        fontSize: 36,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextWidget(
                              text: 'Players Rankings:',
                              textColor: MyColorHelper.white,
                              fontFamily: "horta",
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                            CustomTextWidget(
                              text: 'My Score Breakdown:',
                              textColor: MyColorHelper.white,
                              fontFamily: "horta",
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          ],
                        ),
                      ),
                      CustomTextWidget(
                        text: "Last Round Result",
                        // text: widget.challengeModel.challengeName.toString() +
                        //     " Final Result",
                        textColor: Colors.white,
                        fontFamily: 'horta',
                        fontSize: 24.0,
                      ),
                      SizedBox(height: context.height * 0.02),
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
                                child: const RadarChartSample1(
                                  showBlurBackground: false,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: context.height * 0.02),
                      CustomTextWidget(
                        text: 'Overall Rounds Progress',
                        textColor: Colors.white,
                        fontFamily: 'horta',
                        fontSize: 24.0,
                      ),
                      SizedBox(height: context.height * 0.02),
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
                                child: BarChartSample7(
                                  showBlurBackground: false,
                                )),
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
