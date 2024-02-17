import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/controller/add_challenge_controller.dart';
import 'package:sound_app/controller/login_controller.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/appbar_with_icons.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/auth_textfield.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/create_account_popup.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/member_model.dart';
import 'package:sound_app/view/auth/signup.dart';
import 'package:sound_app/view/dashboard/main_challenge_screen.dart';
import 'package:sound_app/view/dashboard/select_members.dart';
import 'package:sound_app/view/dashboard/select_song.dart';

class CreateChallenge extends StatelessWidget {
  const CreateChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController authController = Get.find();
    final AddChallengeController controller = Get.put(AddChallengeController());
    final MyNewChallengeController _myNewChallengeController =
        Get.put(MyNewChallengeController());

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const AppbarWithIcons(),
                            //Create New Challenge button
                            const CreateChallengeImage(),
                            //MainChallengeContainer
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.width * 0.1),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: SizedBox(
                                      height: context.height * 0.6,
                                      width: context.width,
                                      child: Image.asset(
                                          MyAssetHelper.challengeContainer,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: context.height * 0.07,
                                            width: context.width * 0.5,
                                            child: AuthTextField(
                                              hintText: 'Enter Challenge Name',
                                              fontSize: 12.0,
                                              controller: controller
                                                  .challengeNameController,
                                            ),
                                          ),
                                          SizedBox(
                                              height: context.height * 0.02),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Obx(
                                                () => Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      _buildIcon(
                                                        icon: Icons
                                                            .person_add_alt_rounded,
                                                        color: controller
                                                                .selectedMembers
                                                                .isEmpty
                                                            ? Colors.redAccent
                                                                .shade100
                                                                .withOpacity(
                                                                    0.6)
                                                            : MyColorHelper
                                                                .blue,
                                                        context: context,
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return SelectMemberScreen(
                                                                selectedMembers:
                                                                    controller
                                                                        .selectedMembers,
                                                                filteredMembers:
                                                                    controller
                                                                        .filteredMembers,
                                                                onSearchChanged:
                                                                    controller
                                                                        .filterMembers,
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CustomTextWidget(
                                                            text:
                                                                'Select Rounds',
                                                            fontFamily:
                                                                'poppins',
                                                            textColor:
                                                                MyColorHelper
                                                                    .blue,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          SizedBox(
                                                              height: context
                                                                      .height *
                                                                  0.01),
                                                          SizedBox(
                                                              height: context
                                                                      .height *
                                                                  0.08,
                                                              width: context
                                                                      .width *
                                                                  0.15,
                                                              child: TextFormField(
                                                                  controller: controller.numberOfRounds,
                                                                  onChanged: controller.updateGameRound, // controller: controller
                                                                  //     .numberOfRounds,
                                                                  // onChanged:
                                                                  //     (value) {
                                                                  //   controller
                                                                  //           .gameRound
                                                                  //           .value =
                                                                  //       value
                                                                  //           as int;
                                                                  // },
                                                                  keyboardType: TextInputType.number,
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: MyColorHelper
                                                                        .verdigris,
                                                                  ),
                                                                  decoration: InputDecoration(
                                                                      hintText: '1',
                                                                      hintStyle: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: MyColorHelper
                                                                            .verdigris,
                                                                      ),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: MyColorHelper.verdigris),
                                                                      ),
                                                                      focusedBorder: const OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: MyColorHelper.blue),
                                                                      )))),
                                                          Row(
                                                            children:
                                                                _buildRadioButtons(
                                                                    controller),
                                                          ),
                                                        ],
                                                      ),
                                                      _buildIcon(
                                                        icon: Icons
                                                            .volume_down_rounded,
                                                        color: controller
                                                                    .selectedSong
                                                                    .value ==
                                                                null
                                                            ? Colors.redAccent
                                                                .shade100
                                                                .withOpacity(
                                                                    0.6)
                                                            : MyColorHelper
                                                                .blue,
                                                        context: context,
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return SelectSongsScreen();
                                                            },
                                                          );
                                                        },
                                                      )
                                                    ]),
                                              )),
                                          SizedBox(
                                              height: context.height * 0.02),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                createChallenge(
                                                    authController:
                                                        authController,
                                                    controller: controller,
                                                    myNewChallengeController:
                                                        _myNewChallengeController,
                                                    context: context);
                                              },
                                              child: Image.asset(
                                                  MyAssetHelper.startNow,
                                                  height:
                                                      context.height * 0.05),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(
      {required IconData icon,
      required Color? color,
      required BuildContext context,
      void Function()? onTap}) {
    return InkWell(
      excludeFromSemantics: true,
      onTap: onTap,
      child: Icon(
        icon,
        color: color,
        size: context.height * 0.06,
      ),
    );
  }

  List<Widget> _buildRadioButtons(AddChallengeController controller) {
    const List<int> radioValues = [1, 2, 3];

    return radioValues.map((value) {
      return Radio(
        autofocus: true,
        splashRadius: 20.0,
        fillColor: MaterialStateProperty.resolveWith((states) {
          // active
          if (states.contains(MaterialState.selected)) {
            return MyColorHelper.blue;
          }
          // inactive
          return Colors.white60;
        }),
        activeColor: MyColorHelper.blue,
        value: value,
        groupValue: controller.gameRound.value,
        onChanged: (int? selectedValue) {
          if (selectedValue != null) {
            controller.gameRound.value = selectedValue;
            controller.numberOfRounds.text = selectedValue.toString();
          }
        },
      );
    }).toList();
  }

  void createChallenge(
      {required LoginController authController,
      required AddChallengeController controller,
      required MyNewChallengeController myNewChallengeController,
      required BuildContext context}) {
    if (authController.isGuestUser.value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: Colors.transparent,
            content: CreateAccountPopup(
                onTap: () {
                  Get.offAll(() => const SignupScreen(),
                      transition: Transition.upToDown);
                },
                buttonText: 'Create Account',
                isSvg: true,
                imagePath: 'assets/svgs/create-account.svg',
                text:
                    'To Create the Challenge, Please Create the Account first.',
                opacity: 1),
          );
        },
      );
      debugPrint('PLEASE CREATE ACCOUNT');
    } else {
      if (controller.challengeNameController.text.isNotEmpty &&
          controller.selectedSong.value != null &&
          controller.selectedMembers.isNotEmpty) {
        List<Member> participants = controller.selectedMembers;

        List<Member> leftProfiles = participants.length >= 3
            ? participants.sublist(0, 3)
            : participants.sublist(0, min(participants.length, 3));
        List<Member> rightProfiles = participants.length >= 6
            ? participants.sublist(3, 6)
            : participants.length >= 3
                ? participants.sublist(3)
                : [];
        List<Member> bottomProfiles =
            participants.length >= 6 ? participants.sublist(6) : [];

        controller.createChallenge(
          ChallengeModel(
            id: Random().nextInt(50),
            challengeName: controller.challengeNameController.text,
            participants: participants,
            song: controller.selectedSong.value!,
            leftProfiles: leftProfiles,
            rightProfiles: rightProfiles,
            bottomProfiles: bottomProfiles,
            roundsCount: controller.gameRound.value,
          ),
        );

        debugPrint(participants.length.toString());
        myNewChallengeController.roundValueOne();
        Get.off(
          MainChallengeScreen(
            challengeModel: ChallengeModel(
              id: Random().nextInt(50),
              challengeName: controller.challengeNameController.text,
              participants: participants,
              song: controller.selectedSong.value!,
              leftProfiles: leftProfiles,
              rightProfiles: rightProfiles,
              bottomProfiles: bottomProfiles,
              roundsCount: controller.gameRound.value,
            ),
          ),
        )!
            .then((value) {
          // controller.selectedMembers.value = [];
        });

        MySnackBarsHelper.showMessage(
          "Successfully ",
          "Challenge Created",
          CupertinoIcons.check_mark_circled,
        );
        controller.challengeNameController.clear();
      } else {
        if (controller.challengeNameController.text.isEmpty) {
          MySnackBarsHelper.showMessage(
            "To create the challenge.",
            "Please Enter Challenge Name",
            Icons.close,
          );
        } else if (controller.selectedSong.value == null) {
          MySnackBarsHelper.showMessage(
            "To create the challenge.",
            "Please Select Sound ",
            Icons.music_note,
          );
        } else if (controller.selectedMembers.isEmpty) {
          MySnackBarsHelper.showMessage(
            "To create the challenge.",
            "Please Select Participants ",
            Icons.person,
          );
        }
      }
    }
  }
}

class CreateChallengeImage extends StatelessWidget {
  const CreateChallengeImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.1),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: context.height * 0.15,
              width: context.width,
              child: Image.asset(MyAssetHelper.addChallengeBackground),
            ),
          ),
          Positioned.fill(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextWidget(
                    fontFamily: 'horta',
                    text: 'Create New Challenge',
                    fontWeight: FontWeight.w700,
                    fontSize: 26.0,
                    textColor: Colors.white,
                    isShadow: true,
                    shadow: const [
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        blurRadius: 5.0,
                        color: MyColorHelper.blue,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                )
              ])))
        ],
      ),
    );
  }
}
