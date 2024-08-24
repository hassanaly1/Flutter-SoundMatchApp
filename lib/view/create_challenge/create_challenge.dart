import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/controller/create_challenge_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/data/socket_service.dart';
import 'package:sound_app/helper/appbar.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/create_account_popup.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/view/auth/signup.dart';
import 'package:sound_app/view/challenge/challenge.dart';
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
  final PageController pageController = PageController(initialPage: 0);
  RxInt currentPage = 0.obs;

  @override
  void initState() {
    controller = Get.put(CreateChallengeController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(MyAssetHelper.backgroundImage, fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: CustomAppbar(),
                      ),
                      SizedBox(
                        height: context.height * 0.15,
                        width: context.width,
                        child:
                            Image.asset(MyAssetHelper.addChallengeBackground),
                      ),
                      Container(
                        height: context.height * 0.7,
                        padding: EdgeInsets.symmetric(
                          vertical: context.height * 0.1,
                          horizontal: context.width * 0.07,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(MyAssetHelper.challengeContainer),
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
            width: context.width * 0.7,
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
                          if (controller.participants.isEmpty) {
                            controller.fetchParticipants(searchString: '');
                          }
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
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
                          // if (universalController.userSoundPacks.isNotEmpty) {
                          //   universalController.fetchSoundsByPackId(
                          //     universalController.userSoundPacks[0].id,
                          //   );
                          // }
                          // getAllSoundPacksByUserId();
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOutCubicEmphasized,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: MyColorHelper.verdigris,
                  ),
                )),
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
                createChallenge(
                  universalController: universalController,
                  controller: controller,
                  context: context,
                );
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
    final GuestController guestController = Get.find();
    if (guestController.isGuestUser.value) {
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
                imagePath: 'assets/images/create-account.png',
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
        callChallengeSocket();
        MySnackBarsHelper.showMessage(
          "Successfully ",
          "Challenge Created",
          CupertinoIcons.check_mark_circled,
        );
        // controller.challengeNameController.clear();
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

  void callChallengeSocket() {
    io.Socket socket = SocketService().getSocket();
    ChallengeModel challengeModel = ChallengeModel(
      challenge: Challenge(
        name: controller.challengeNameController.text,
        numberOfChallenges: controller.numberOfRounds.value.toString(),
        user: MyAppStorage.storage.read('user_info')['_id'] ?? '',
        sound: controller.selectedSound.value!.id.toString(),
        createdBy: MyAppStorage.storage.read('user_info')['_id'] ?? '',
      ),
      passingCriteria: List.generate(
        controller.numberOfRounds.value,
        (index) => PassingCriteria(
          percentage: int.parse(
              controller.passingCriteriaControllers[index].text.trim()),
          room: index + 1,
        ),
      ),
      challengeRoom: ChallengeRoom(
        users: [MyAppStorage.storage.read('user_info')['_id'] ?? ''],
        totalMembers: 1,
        currentTurnHolder: MyAppStorage.storage.read('user_info')['_id'] ?? '',
      ),
      invitation: Invitation(
        type: 'challenge',
        recipients: [
          // MyAppStorage.userId,
          ...controller.selectedParticipants.map((e) => e.id.toString()),
        ],
        createdBy: MyAppStorage.storage.read('user_info')['_id'] ?? '',
      ),
    );

    try {
      final data = challengeModel.toJson();
      socket.emit(ApiEndPoints.connectToCreateChallenge, data);
      // socket.on(
      //   'challenge_room',
      //   (data) {
      //     print('Challenge Room: $data');
      //     ChallengeRoomModel challengeRoomModel =
      //         ChallengeRoomModel.fromJson(data['challenge_room']);
      //     print('Challenge Room Model: ${challengeRoomModel.toJson()}');
      Get.off(
        () => const ChallengeRoomScreen(),
      );
      //   },
      // );
    } catch (e) {
      debugPrint('Error sending challenge data: $e');
    }
  }

  Widget _buildIcon({
    required IconData icon,
    required Color? color,
    required BuildContext context,
    void Function()? onTap,
  }) {
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
