import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sound_app/controller/add_challenge_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/appbar.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/create_account_popup.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/participant_model.dart';
// import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/view/auth/signup.dart';
import 'package:sound_app/view/create_challenge/select_members.dart';
import 'package:sound_app/view/create_challenge/select_song.dart';

class CreateChallenge extends StatelessWidget {
  const CreateChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    final MyUniversalController universalController = Get.find();
    final AddChallengeController controller = Get.put(AddChallengeController());

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: context.height * 0.03),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const CustomAppbar(showNotificationsIcon: true),
                        //Create New Challenge Image
                        const CreateChallengeImage(),
                        //MainChallengeContainer
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.width * 0.05),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: SizedBox(
                                    height: context.height * 0.6,
                                    width: context.width,
                                    child: Image.asset(
                                        MyAssetHelper.challengeContainer,
                                        fit: BoxFit.fill)),
                              ),
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: context.height * 0.07,
                                        width: context.width * 0.6,
                                        child: CustomTextField(
                                          hintText: 'Enter Challenge Name',
                                          controller: controller
                                              .challengeNameController,
                                        ),
                                      ),
                                      SizedBox(height: context.height * 0.02),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Obx(
                                            () => Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  _buildIcon(
                                                    icon: Icons.account_circle,
                                                    color: controller
                                                            .selectedMembers
                                                            .isEmpty
                                                        ? Colors
                                                            .redAccent.shade100
                                                            .withOpacity(0.6)
                                                        : MyColorHelper.blue,
                                                    context: context,
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (BuildContext
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
                                                        text: 'Select Rounds',
                                                        fontFamily: 'poppins',
                                                        textColor:
                                                            MyColorHelper.blue,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              context.height *
                                                                  0.01),
                                                      SizedBox(
                                                          height: context
                                                                  .height *
                                                              0.08,
                                                          width: context.width *
                                                              0.15,
                                                          child: TextFormField(
                                                              controller: controller
                                                                  .numberOfRoundsController,
                                                              onChanged: controller
                                                                  .updateGameRound, // controller: controller
                                                              //     .numberOfRounds,
                                                              // onChanged:
                                                              //     (value) {
                                                              //   controller
                                                              //           .gameRound
                                                              //           .value =
                                                              //       value
                                                              //           as int;
                                                              // },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: MyColorHelper
                                                                    .verdigris,
                                                              ),
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          '1',
                                                                      hintStyle:
                                                                          GoogleFonts
                                                                              .poppins(
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: MyColorHelper
                                                                            .verdigris,
                                                                      ),
                                                                      enabledBorder:
                                                                          const OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: MyColorHelper.verdigris),
                                                                      ),
                                                                      focusedBorder:
                                                                          const OutlineInputBorder(
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
                                                    icon: Icons.play_circle,
                                                    color: controller
                                                                .selectedSound
                                                                .value ==
                                                            null
                                                        ? Colors
                                                            .redAccent.shade100
                                                            .withOpacity(0.6)
                                                        : MyColorHelper.blue,
                                                    context: context,
                                                    onTap: () {
                                                      if (universalController
                                                          .userSoundPacks
                                                          .isNotEmpty) {
                                                        universalController
                                                            .fetchSoundsByPackId(
                                                          universalController
                                                              .userSoundPacks[0]
                                                              .id,
                                                        );
                                                      }
                                                      showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const SelectSongsScreen();
                                                        },
                                                      );
                                                    },
                                                  )
                                                ]),
                                          )),
                                      SizedBox(height: context.height * 0.02),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            createChallenge(
                                                universalController:
                                                    universalController,
                                                controller: controller,
                                                context: context);
                                            // print('TAPPED');
                                            // IO.Socket socket = IO.io(
                                            //   ApiEndPoints.baseUrl,
                                            //   IO.OptionBuilder().setTransports(
                                            //       ['websocket']).build(),
                                            // );
                                            // socket.on('connect', (_) {
                                            //   print('connect');
                                            //   socket.emit('create_challenge', {
                                            //     'name': controller
                                            //         .challengeNameController
                                            //         .text
                                            //         .trim(),
                                            //     'number_of_challenges':
                                            //         controller.gameRound.value,
                                            //   });
                                            // });
                                            // socket.onConnect((_) {
                                            //   print('connect');
                                            // });
                                            // socket.onConnectError((_) {
                                            //   print('connect error');
                                            // });
                                            // socket.onDisconnect(
                                            //     (_) => print('disconnect'));
                                          },
                                          child: Image.asset(
                                              MyAssetHelper.startNow,
                                              height: context.height * 0.05),
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
            )
          ],
        ),
      ),
    );
  }

  void createChallenge(
      {required MyUniversalController universalController,
      required AddChallengeController controller,
      // required MyNewChallengeController myNewChallengeController,
      required BuildContext context}) {
    if (universalController.isGuestUser.value) {
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
          controller.selectedSound.value != null &&
          controller.selectedMembers.isNotEmpty) {
        List<Participant> participants = controller.selectedMembers;

        controller.createChallenge(
          ChallengeModel(
            id: Random().nextInt(50),
            challengeName: controller.challengeNameController.text,
            participants: participants,
            song: controller.selectedSound.value!,
            numberOfRounds: controller.numberOfRounds.value,
          ),
        );

        // List<Participant> leftProfiles = participants.length >= 3
        //     ? participants.sublist(0, 3)
        //     : participants.sublist(0, min(participants.length, 3));
        // List<Participant> rightProfiles = participants.length >= 6
        //     ? participants.sublist(3, 6)
        //     : participants.length >= 3
        //         ? participants.sublist(3)
        //         : [];
        // List<Participant> bottomProfiles =
        //     participants.length >= 6 ? participants.sublist(6) : [];
        //
        // controller.createChallenge(
        //   ChallengeModel(
        //     id: Random().nextInt(50),
        //     challengeName: controller.challengeNameController.text,
        //     participants: participants,
        //     song: controller.selectedSound.value!,
        //     leftProfiles: leftProfiles,
        //     rightProfiles: rightProfiles,
        //     bottomProfiles: bottomProfiles,
        //     roundsCount: controller.gameRound.value,
        //   ),
        // );

        // myNewChallengeController.roundValueOne();
        // Get.off(
        //   MainChallengeScreen(
        //     challengeModel: ChallengeModel(
        //       id: Random().nextInt(50),
        //       challengeName: controller.challengeNameController.text,
        //       participants: participants,
        //       song: controller.selectedSong.value!,
        //       leftProfiles: leftProfiles,
        //       rightProfiles: rightProfiles,
        //       bottomProfiles: bottomProfiles,
        //       roundsCount: controller.gameRound.value,
        //     ),
        //   ),
        // )!

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
        } else if (controller.selectedSound.value == null) {
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
        groupValue: controller.numberOfRounds.value,
        onChanged: (int? selectedValue) {
          if (selectedValue != null) {
            controller.numberOfRounds.value = selectedValue;
            controller.numberOfRoundsController.text = selectedValue.toString();
          }
        },
      );
    }).toList();
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
