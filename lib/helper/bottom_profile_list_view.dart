import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/profile_list_view.dart';
import 'package:sound_app/models/member_model.dart';
import 'package:sound_app/view/dashboard/main_challenge_screen.dart';
class BottomProfileSection extends StatelessWidget {
  final int currentIndex;
  final bool showBorder;
  const BottomProfileSection({
    super.key,
    required MyNewChallengeController myNewChallengeController,
    required this.widget,
    required this.height,
    required ScrollController scrollController, required this.currentIndex, required this.showBorder,
  }) : _myNewChallengeController = myNewChallengeController, _scrollController = scrollController;
  final MyNewChallengeController _myNewChallengeController;
  final MainChallengeScreen widget;
  final double height;
  final ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return Obx(() => _myNewChallengeController.think.value == false
        ? widget.challengeModel.bottomProfiles!.isNotEmpty
        ? Container(
        margin: const EdgeInsets.all(10),
        height: height * 0.17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColorHelper.container,
        ),
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget
                      .challengeModel
                      .bottomProfiles!
                      .length, // Add one for the arrow icon
                  itemBuilder: (context, index) {
                    final bottomProfile = widget
                        .challengeModel
                        .bottomProfiles![index];
                    return Padding(
                      padding:
                      const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            // height:height*0.1,
                            decoration: BoxDecoration(
                              border:
                        currentIndex==index?    Border.all(
                                  color: MyColorHelper.lightBlue,
                                  width: 2.0) :null,// Add border styling
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  MyAssetHelper
                                      .userBackground,
                                ),
                              ),
                            ),
                            child: Obx(()
                              => bottomProfile
                                  .imageUrl !=
                                  ""
                                  ? Padding(
                                padding:
                                const EdgeInsets
                                    .all(
                                    10.0),
                                child:
                                _myNewChallengeController.loaderWaiting.value==false?    CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                  NetworkImage(
                                    bottomProfile
                                        .imageUrl!,
                                  ),
                                ):CircularProgressIndicator(color: MyColorHelper.primaryColor,),
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets
                                    .all(
                                    10.0),
                                child: Image.asset(
                                    MyAssetHelper
                                        .personPlaceholder),
                              ),
                            ),
                          ),
                          Flexible(
                            child: CustomTextWidget(
                                text: bottomProfile
                                    .name!,
                                shadow: [],
                                fontFamily: "Horta",
                                textColor:
                                MyColorHelper
                                    .primaryColor,
                                fontSize: 17),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            GestureDetector(
              onTap: () {
                double offset = (_scrollController
                    .position.pixels +
                    80) +
                    (MediaQuery.of(context)
                        .size
                        .width *
                        0.05);
                _scrollController.animateTo(offset,
                    duration: const Duration(
                        milliseconds: 500),
                    curve: Curves.ease);
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            )
          ],
        ))
        : Container()
        : Container());
  }
}