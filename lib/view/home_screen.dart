import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/challenge/default_match.dart';
import 'package:sound_app/view/create_challenge/create_challenge.dart';
import 'package:sound_app/view/soundpacks/purchase_songs.dart';
import 'package:sound_app/view/challenge/widgets/custom_match_card.dart';
import 'package:sound_app/view/notifications/notification_screen.dart';
import 'package:sound_app/view/profile/profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final AddChallengeController challengeController =
    //     Get.put(AddChallengeController());
    final MyUniversalController controller = Get.find();
    final CarouselSliderController carouselController =
        Get.put(CarouselSliderController());
    return SafeArea(
      child: Stack(fit: StackFit.expand, children: [
        SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
                child: Column(
              children: [
                //Appbar
                const HomeAppbar(),
                SizedBox(height: context.height * 0.002),
                const CreateNewChallenge(),
                SizedBox(height: context.height * 0.01),
                SizedBox(
                    height: 35,
                    width: context.width * 0.8,
                    child: Image.asset('assets/images/homeicon2.png')),
                ChallengesList(
                  universalController: controller,
                  controller: carouselController,
                ),
                SizedBox(
                  height: 35,
                  width: context.width * 0.8,
                  child: Image.asset('assets/images/homeicon3.png'),
                ),
                DotsIndicator(
                  universalController: controller,
                  controller: carouselController,
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
                        CustomTextWidget(
                            fontFamily: 'horta',
                            text: 'Sound Pack',
                            fontWeight: FontWeight.w700,
                            fontSize: 28.0,
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
        return PurchaseSongsScreen();
      },
      openElevation: 0,
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }
}

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.universalController,
    required this.controller,
  });

  final MyUniversalController universalController;
  final CarouselSliderController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: universalController.challenges.asMap().entries.map((entry) {
          final int i = entry.key; // Get the index of the challenge
          return Container(
            width: 18.0,
            height: 12.0,
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 4.0,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade100
                      : Colors.white70)
                  .withOpacity(controller.currentIndex.value == i ? 0.9 : 0.4),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ChallengesList extends StatelessWidget {
  const ChallengesList({
    super.key,
    required this.universalController,
    required this.controller,
  });

  final MyUniversalController universalController;
  final CarouselSliderController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.height * 0.25,
        width: double.infinity,
        color: Colors.transparent,
        child: Obx(
          () => CarouselSlider(
            items: universalController.challenges.asMap().entries.map((entry) {
              final int index = entry.key; // Get the index of the challenge
              final challenge = entry.value;
              return OpenContainer(
                openColor: Colors.transparent,
                closedColor: Colors.transparent,
                transitionDuration: const Duration(milliseconds: 500),
                closedBuilder: (context, action) {
                  return CustomMatchCard(
                    index: index,
                    onTap: action,
                    challenge: challenge,
                  );
                },
                openBuilder: (context, action) {
                  if (index == 0) {
                    return DefaultMatchScreen();
                    return Container();
                  } else {
                    // return const FinalResultScreen2();
                    return Container();
                    // return FinalResultScreen();
                  }
                },
                openElevation: 0,
                closedElevation: 0,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              animateToClosest: true,
              autoPlay: false,
              enableInfiniteScroll: false,
              viewportFraction: 0.75,
              onPageChanged: (index, _) {
                controller.onPageChanged(index);
              },
              enlargeCenterPage: true,
            ),
          ),
        ));
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
          isScrollControlled: true,
          builder: (BuildContext context) {
            return const CreateChallenge();
          },
        );
      },
      child: Stack(children: [
        Image.asset(
          'assets/images/homeicon5.png',
          height: context.height * 0.2,
          width: context.width,
        ),
        Positioned(
            top: context.height * 0.07,
            left: 0,
            right: 0,
            child: Center(
                child: CustomTextWidget(
                    fontFamily: 'horta',
                    text: 'Create New Challenge',
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
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
                    color: MyColorHelper.primaryColor,
                    offset: Offset(0, 0),
                  ),
                ])))
      ]),
    );
  }
}

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({
    super.key,
  });

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
          Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.to(
                        const NotificationScreen(
                            //  challengeModel: challengeModel,
                            ),
                        transition: Transition.upToDown);
                  },
                  child: const Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.notifications,
                          color: Colors.white70, size: 30))),
              const SizedBox(width: 10.0),
              InkWell(
                  onTap: () {
                    Get.to(const ProfileScreen(),
                        transition: Transition.upToDown);
                  },
                  child: const Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        CupertinoIcons.profile_circled,
                        color: Colors.white70,
                        size: 30,
                      )))
            ],
          )
        ],
      ),
    );
  }
}
