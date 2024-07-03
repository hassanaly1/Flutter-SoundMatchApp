import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sound_app/controller/create_challenge_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/appbar.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/create_account_popup.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/view/auth/signup.dart';
import 'package:sound_app/view/create_challenge/select_participants.dart';
import 'package:sound_app/view/create_challenge/select_song.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({super.key});

  @override
  State<CreateChallenge> createState() => _CreateChallengeState();
}

class _CreateChallengeState extends State<CreateChallenge> {
  late CreateChallengeController controller;
  final MyUniversalController universalController = Get.find();
  late io.Socket socket;

  @override
  void initState() {
    controller = Get.put(CreateChallengeController());

    super.initState();
  }

  @override
  void dispose() {
    socket.dispose();
    controller.dispose();
    universalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    RxInt currentPage = 0.obs;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
                  padding:
                      EdgeInsets.symmetric(horizontal: context.width * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: CustomAppbar(showNotificationsIcon: false),
                        ),
                        const CreateChallengeImage(),
                        Container(
                          height: context.height * 0.7,
                          padding: EdgeInsets.symmetric(
                            vertical: context.height * 0.15,
                            horizontal: context.width * 0.07,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage(MyAssetHelper.challengeContainer),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: pageController,
                            onPageChanged: (value) {
                              currentPage.value = value;
                            },
                            children: [
                              MyPageView1(
                                context,
                                controller,
                                universalController,
                                pageController,
                              ),
                              MyPageView2(
                                context,
                                controller,
                                universalController,
                                pageController,
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
    );
  }

  Widget MyPageView1(
    BuildContext context,
    CreateChallengeController controller,
    MyUniversalController universalController,
    PageController pageController,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomTextWidget(
            text: 'Enter Challenge Name',
            fontFamily: 'Horta',
            textColor: MyColorHelper.blue,
            fontSize: 22.0,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: context.height * 0.01),
          SizedBox(
            height: context.height * 0.07,
            width: context.width * 0.6,
            child: CustomTextField(
              hintText: 'Challenge Name',
              controller: controller.challengeNameController,
            ),
          ),
          SizedBox(height: context.height * 0.02),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Obx(
                () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIcon(
                        icon: Icons.account_circle,
                        color: controller.selectedParticipants.isEmpty
                            ? Colors.redAccent.shade100.withOpacity(0.6)
                            : MyColorHelper.blue,
                        context: context,
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return const SelectParticipantsScreen();
                            },
                          );
                        },
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomTextWidget(
                            text: 'Select Rounds',
                            fontFamily: 'Horta',
                            textColor: MyColorHelper.blue,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(height: context.height * 0.01),
                          SizedBox(
                            height: context.height * 0.08,
                            width: context.width * 0.15,
                            child: TextFormField(
                              readOnly: true,
                              onChanged: controller.updateGameRound,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: MyColorHelper.verdigris,
                                fontFamily: 'poppins',
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    controller.numberOfRounds.value.toString(),
                                hintStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: MyColorHelper.verdigris,
                                  fontFamily: 'poppins',
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: MyColorHelper.verdigris,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: MyColorHelper.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(children: _buildRadioButtons(controller)),
                        ],
                      ),
                      _buildIcon(
                        icon: Icons.play_circle,
                        color: controller.selectedSound.value == null
                            ? Colors.redAccent.shade100.withOpacity(0.6)
                            : MyColorHelper.blue,
                        context: context,
                        onTap: () {
                          if (universalController.userSoundPacks.isNotEmpty) {
                            universalController.fetchSoundsByPackId(
                              universalController.userSoundPacks[0].id,
                            );
                          }
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return const SelectSongsScreen();
                            },
                          );
                        },
                      )
                    ]),
              )),
          SizedBox(height: context.height * 0.01),
          InkWell(
            onTap: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubicEmphasized,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                MyAssetHelper.next,
                height: 50,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget MyPageView2(
    BuildContext context,
    CreateChallengeController controller,
    MyUniversalController universalController,
    PageController pageController,
  ) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () => pageController.previousPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOutCubicEmphasized,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            const CustomTextWidget(
              text: 'Enter Passing Criteria',
              fontSize: 22.0,
              fontFamily: 'Horta',
              textColor: MyColorHelper.verdigris,
            ),
            ...List.generate(
              controller.numberOfRounds.value,
              (index) => SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    hintText: 'Round ${index + 1}',
                    controller: controller.passingCriteriaControllers[index],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.height * 0.01),
            InkWell(
              onTap: () {
                // connectToSocket();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  MyAssetHelper.startNow,
                  height: 50,
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
      required CreateChallengeController controller,
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
          controller.selectedParticipants.isNotEmpty) {
        List<Participant> participants = controller.selectedParticipants;

        // controller.createChallenge(
        //   ChallengeModel(
        //     id: Random().nextInt(50),
        //     challengeName: controller.challengeNameController.text,
        //     participants: participants,
        //     song: controller.selectedSound.value!,
        //     numberOfRounds: controller.numberOfRounds.value,
        //   ),
        // );

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
        } else if (controller.selectedParticipants.isEmpty) {
          MySnackBarsHelper.showMessage(
            "To create the challenge.",
            "Please Select Participants ",
            Icons.person,
          );
        }
      }
    }
  }

  ///todo: ConnectToSocket

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

  List<Widget> _buildRadioButtons(CreateChallengeController controller) {
    const List<int> radioValues = [1, 2, 3];

    return radioValues.map((value) {
      return Radio(
        autofocus: true,
        splashRadius: 20.0,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MyColorHelper.blue;
          }
          // inactive
          return Colors.white60;
        }),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        activeColor: MyColorHelper.blue,
        value: value,
        groupValue: controller.numberOfRounds.value,
        onChanged: (int? selectedValue) {
          if (selectedValue != null) {
            controller.numberOfRounds.value = selectedValue;
            controller.updateNumberOfRounds(controller.numberOfRounds.value);
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
          const Positioned.fill(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextWidget(
                    fontFamily: 'horta',
                    text: 'Create New Challenge',
                    fontWeight: FontWeight.w700,
                    fontSize: 26.0,
                    textColor: Colors.white,
                    isShadow: true,
                    shadow: [
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
