import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/member_model.dart';

class RequestTab extends StatefulWidget {
  // final ChallengeModel challengeModel;

  const RequestTab({super.key});

  @override
  State<RequestTab> createState() => _RequestTabState();
}

class _RequestTabState extends State<RequestTab> {
  final MyNewChallengeController _myNewChallengeController =
      Get.put(MyNewChallengeController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Member myMember = Member();

    return GetBuilder<MyNewChallengeController>(
      builder: (controller) => _myNewChallengeController
              .challengeRequestList.isNotEmpty
          ? ListView.builder(
              itemCount: _myNewChallengeController.challengeRequestList.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final challengeRequest =
                    _myNewChallengeController.challengeRequestList[index];
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(MyAssetHelper.requestBackground),
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                          text: challengeRequest.leaderName!,
                          fontFamily: "Poppins",
                          textColor: MyColorHelper.white,
                          fontSize: 15),
                      CustomTextWidget(
                          text: challengeRequest.gameName!,
                          fontFamily: "Horta",
                          isShadow: true,
                          textColor: MyColorHelper.white,
                          fontSize: 36),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      challengeRequest.imagePath!,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  CustomTextWidget(
                                      text: challengeRequest.participantName!,
                                      fontFamily: "Poppins",
                                      textColor: MyColorHelper.white,
                                      maxLines: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.removeChallengeRequest(index);
                                    },
                                    child: Container(
                                      height: height * 0.094,
                                      width: width * 0.094,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.red)),
                                      child: const Center(
                                          child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      )),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.022),
                                  GestureDetector(
                                    onTap: () {
                                      // myMember = Member(
                                      //   name: challengeRequest.participantName,
                                      //   imageUrl: challengeRequest.imagePath,
                                      // );
                                      // // controller.handleCheckboxChanged(true,myMember);
                                      // if (widget.challengeModel.leftProfiles!
                                      //         .length <
                                      //     3) {
                                      //   widget.challengeModel.leftProfiles!
                                      //       .add(myMember);
                                      // } else if (widget.challengeModel
                                      //         .rightProfiles!.length <
                                      //     3) {
                                      //   widget.challengeModel.rightProfiles!
                                      //       .add(myMember);
                                      // } else {
                                      //   widget.challengeModel.bottomProfiles!
                                      //       .add(myMember);
                                      // }
                                      // controller.removeChallengeRequest(index);
                                    },
                                    child: Container(
                                      height: height * 0.094,
                                      width: width * 0.094,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: MyColorHelper.blue)),
                                      child: const Center(
                                          child: Icon(
                                        Icons.check,
                                        color: MyColorHelper.primaryColor,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CustomTextWidget(
                            text: challengeRequest.gameDescription!,
                            fontFamily: "Poppins",
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            textColor: MyColorHelper.white,
                            fontSize: 15),
                      ),
                    ],
                  ),
                );
              })
          : Center(
              child: CustomTextWidget(
              text: "No Request Available",
              textColor: MyColorHelper.white,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            )),
    );
  }
}
