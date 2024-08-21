import 'package:animations/animations.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/data/socket_service.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/sound_pack_model.dart';
import 'package:sound_app/utils/api_endpoints.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/view/challenge/challenge.dart';
import 'package:sound_app/view/challenge/default_match.dart';
import 'package:sound_app/view/challenge/widgets/custom_match_card.dart';
import 'package:sound_app/view/create_challenge/create_challenge.dart';
import 'package:sound_app/view/profile/profile.dart';
import 'package:sound_app/view/soundpacks/purchase_songs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MyUniversalController controller;

  @override
  void initState() {
    controller = Get.put(MyUniversalController());
    // Initialize the socket service
    SocketService(); // This will call the constructor and initialize the socket
    connectToRoomAndWaitingToGetInvitations(context);
    getAllSoundPacksByUserId();
    super.initState();
  }

  void getAllSoundPacksByUserId() {
    io.Socket socket = SocketService().getSocket();
    try {
      final data = MyAppStorage.storage.read('user_info')['_id'];
      socket.emit('get_sound_packs_by_user', data);

      //Get the Users SoundPacks.
      socket.on(
        'soundpacks',
        (data) {
          print('UsersSoundPacksData: $data');
          controller.userSoundPacks.clear();
          for (var soundPackData in data) {
            SoundPackModel soundPack = SoundPackModel.fromJson(soundPackData);
            controller.userSoundPacks.add(soundPack);
          }
          debugPrint('UsersSoundPacks: ${controller.userSoundPacks.length}');
        },
      );
    } catch (e) {
      debugPrint('Error Getting SoundPacks: $e');
    }
  }

  void connectToRoomAndWaitingToGetInvitations(BuildContext context) {
    io.Socket socket = SocketService().getSocket();

    try {
      final data = {
        'user_id': MyAppStorage.storage.read('user_info')['_id'],
      };
      //Connect to their Room
      socket.emit(ApiEndPoints.connectToRoom, data);
      //Get the Invitations of Challenge if Received Any.
      socket.on(ApiEndPoints.getInvitations, (data) {
        debugPrint(
            '<------------------Received Challenge Invitation------------------>\nData: $data');
        var challengeRoomId = data['challenge_room']['_id'];
        var challengeRoomName =
            data['challenge_room']['challenge_group']['name'];
        var challengeCreatedBy = data['created_by']['first_name'] +
            ' ' +
            data['created_by']['last_name'];
        debugPrint('Challenge Room Id: $challengeRoomId');
        Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            boxShadows: const [
              BoxShadow(
                  color: Colors.blueGrey,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 3.0)
            ],
            margin: const EdgeInsets.all(12.0),
            borderRadius: BorderRadius.circular(12.0),
            backgroundGradient: const LinearGradient(
                colors: [Color(0XFF00B4B2), Color(0XFF03827B)]),
            isDismissible: false,
            duration: const Duration(seconds: 5),
            icon: const Icon(Icons.gamepad, color: Colors.black54),
            mainButton: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      debugPrint(
                          'Challenge Accepted for Room : $challengeRoomId');
                      socket.emit(
                        'entry_to_challenge_room',
                        {
                          'user_id':
                              MyAppStorage.storage.read('user_info')['_id'],
                          'room_id': challengeRoomId,
                        },
                      );
                      Get.to(
                        () => const ChallengeRoomScreen(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.lightGreen),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.redAccent),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            dismissDirection: FlushbarDismissDirection.HORIZONTAL,
            showProgressIndicator: true,
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation<Color>(Colors.white),
            progressIndicatorBackgroundColor: MyColorHelper.caribbeanCurrent,
            titleText: CustomTextWidget(
              text:
                  "Hello ${MyAppStorage.storage.read('user_info')['first_name']}",
              fontSize: 16.0,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w700,
              textColor: Colors.white,
            ),
            messageText: CustomTextWidget(
              text:
                  "$challengeCreatedBy has invited you to the Challenge Room: $challengeRoomName",
              fontSize: 14.0,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w500,
              maxLines: 3,
              textColor: Colors.white,
            )).show(context);
      });
    } catch (e) {
      debugPrint('Error Sending Challenge Data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(fit: StackFit.expand, children: [
        SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
                child: Column(
              children: [
                //Appbar
                HomeAppbar(),
                SizedBox(height: context.height * 0.002),
                const CreateNewChallenge(),
                SizedBox(height: context.height * 0.01),
                SizedBox(
                    height: 35,
                    width: context.width * 0.8,
                    child: Image.asset('assets/images/homeicon2.png')),
                OpenContainer(
                  openColor: Colors.transparent,
                  closedColor: Colors.transparent,
                  transitionDuration: const Duration(milliseconds: 500),
                  closedBuilder: (context, action) {
                    return CustomMatchCard(
                      onTap: action,
                    );
                  },
                  openBuilder: (context, action) {
                    return const DefaultMatchScreen();
                  },
                  openElevation: 0,
                  closedElevation: 0,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                SizedBox(
                  height: 35,
                  width: context.width * 0.8,
                  child: Image.asset('assets/images/homeicon3.png'),
                ),
                SoundPacksContainer(controller: controller)
              ],
            )))
      ]),
    );
  }
}

class SoundPacksContainer extends StatelessWidget {
  final MyUniversalController controller;

  const SoundPacksContainer({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openColor: Colors.transparent,
      closedColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 500),
      closedBuilder: (context, action) {
        return SizedBox(
          height: context.height * 0.25,
          child: InkWell(
            onTap: action,
            child: Stack(children: [
              SvgPicture.asset(
                MyAssetHelper.soundPackBackground,
                height: context.height * 0.3,
                fit: BoxFit.cover,
              ),
              Positioned(
                  //   top: context.height * 0.07,
                  left: 0,
                  right: 0,
                  bottom: context.height * 0.1,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/music.png',
                          height: 40,
                        ),
                        const SizedBox(width: 12.0),
                        const CustomTextWidget(
                            fontFamily: 'horta',
                            text: 'Sound Pack',
                            fontWeight: FontWeight.w700,
                            fontSize: 28.0,
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
                                color: MyColorHelper.primaryColor,
                                offset: Offset(0, 0),
                              ),
                            ]),
                      ],
                    ),
                  ))
            ]),
          ),
        );
      },
      openBuilder: (context, action) {
        return const PurchaseSongsScreen();
      },
      openElevation: 0,
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }
}

class CreateNewChallenge extends StatelessWidget {
  const CreateNewChallenge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return const CreateChallenge();
          },
        );
      },
      child: Image.asset(
        'assets/images/create-new-challenge.png',
        height: context.height * 0.2,
        width: context.width,
      ),
      // child: Stack(children: [
      //   Image.asset(
      //     'assets/images/homeicon5.png',
      //     height: context.height * 0.2,
      //     width: context.width,
      //   ),
      //   Positioned(
      //       top: context.height * 0.07,
      //       left: 0,
      //       right: 0,
      //       child: const Center(
      //           child: CustomTextWidget(
      //               fontFamily: 'horta',
      //               text: 'Create New Challenge',
      //               fontWeight: FontWeight.w700,
      //               fontSize: 32.0,
      //               textColor: Colors.white,
      //               isShadow: true,
      //               shadow: [
      //             Shadow(
      //               blurRadius: 15.0,
      //               color: Colors.black,
      //               offset: Offset(0, 0),
      //             ),
      //             Shadow(
      //               blurRadius: 5.0,
      //               color: MyColorHelper.primaryColor,
      //               offset: Offset(0, 0),
      //             ),
      //           ])))
      // ]),
    );
  }
}

class HomeAppbar extends StatelessWidget {
  HomeAppbar({
    super.key,
  });

  final MyUniversalController universalController = Get.find();
  final GuestController guestController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.notifications,
            color: Colors.transparent,
          ),
          InkWell(
              onTap: () => Get.to(() => const ProfileScreen(),
                  transition: Transition.upToDown),
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
                child: Obx(
                  () => CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: guestController.isGuestUser.value
                        ? const AssetImage(
                            'assets/images/guest_user_profile.PNG')
                        : universalController.userImageURL.value.isNotEmpty
                            ? NetworkImage(
                                universalController.userImageURL.value)
                            : const AssetImage('assets/images/placeholder.png')
                                as ImageProvider,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
// assets/images/placeholder.png
