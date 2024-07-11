import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/create_challenge_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/challenge/widgets/custom_sound_avatar.dart';

class SelectSongsScreen extends StatelessWidget {
  const SelectSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MyUniversalController controller = Get.find();
    final CreateChallengeController addChallengeController = Get.find();
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Get.back();
                        controller.soundsById.clear();
                      },
                      icon: Obx(
                        () => Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: addChallengeController
                                            .selectedSound.value !=
                                        null
                                    ? Colors.lightGreen
                                    : Colors.redAccent),
                            child: Icon(
                              addChallengeController.selectedSound.value != null
                                  ? Icons.done
                                  : Icons.close,
                              color: Colors.white,
                            )),
                      )),
                  iconTheme: const IconThemeData(size: 20.0),
                  backgroundColor: Colors.transparent,
                  title: Obx(
                    () => CustomTextWidget(
                      text:
                          'Sound Treasury ${addChallengeController.selectedSound.value?.id}',
                      fontFamily: 'horta',
                      textColor: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: Obx(
                  () => controller.userSoundPacks.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextWidget(
                                  text:
                                      'Your sound bucket is currently empty. To add sounds, explore the collection of Signature Sounds below.',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  textColor: Colors.white,
                                  fontFamily: 'poppins',
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        )
                      : DefaultTabController(
                          length: controller.userSoundPacks.length,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // height: context.height * 0.3,
                                  color: Colors.transparent,
                                  child: TabBar(
                                    onTap: (value) {
                                      controller.soundsById.clear();
                                      controller.fetchSoundsByPackId(
                                          controller.userSoundPacks[value].id);
                                    },
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.center,
                                    tabs: [
                                      for (int i = 0;
                                          i < controller.userSoundPacks.length;
                                          i++)
                                        // Create tabs based on the usersSongs.length
                                        Tab(
                                          height: context.height * 0.2,
                                          child: CustomSoundAvatar(
                                            soundPackModel:
                                                controller.userSoundPacks[i],
                                          ),
                                        ),
                                    ],
                                    labelColor: MyColorHelper.white,
                                    unselectedLabelColor: Colors.grey,
                                    indicatorColor: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    for (int i = 0;
                                        i < controller.userSoundPacks.length;
                                        i++)
                                      ListView(
                                        children: [
                                          SizedBox(
                                              height: context.height * 0.02),
                                          CustomTextWidget(
                                            text: controller
                                                .userSoundPacks[i].packName,
                                            fontSize: 16.0,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'poppins',
                                            textColor: Colors.white,
                                          ),
                                          controller.soundsById.isEmpty
                                              ? const Center(
                                                  heightFactor: 10,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white70,
                                                    strokeCap: StrokeCap.butt,
                                                  ),
                                                )
                                              : Obx(
                                                  () => ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: controller
                                                        .soundsById.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return CustomSoundWidget(
                                                        index: index,
                                                        addChallengeController:
                                                            addChallengeController,
                                                        controller: controller,
                                                      );
                                                    },
                                                  ),
                                                )
                                        ],
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
          ),
        ],
      ),
    );
  }
}

class CustomSoundWidget extends StatelessWidget {
  const CustomSoundWidget({
    super.key,
    required this.addChallengeController,
    required this.controller,
    required this.index,
  });

  final CreateChallengeController addChallengeController;
  final MyUniversalController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: addChallengeController.selectedSound.value?.id ==
                      controller.soundsById[index].id
                  ? Colors.white54
                  : Colors.transparent,
              width: 3.0,
            ),
          ),
          child: ListTile(
            onTap: () {
              addChallengeController.selectSound(
                controller.soundsById[index],
              );
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              // backgroundImage:
              // NetworkImage(
              //     controller
              //             .sounds[
              //                 index]
              //             .url ??
              //         ''),
            ),
            title: CustomTextWidget(
              text: controller.soundsById[index].name ?? '',
              fontSize: 16.0,
              textColor: Colors.white,
              fontFamily: 'poppins',
              fontWeight: (addChallengeController.selectedSound.value ==
                      controller.soundsById[index]
                  ? FontWeight.w500
                  : FontWeight.w300),
            ),
            trailing: Checkbox(
              value: addChallengeController.selectedSound.value?.id ==
                  controller.soundsById[index].id,
              onChanged: (value) {
                addChallengeController.selectSound(
                  controller.soundsById[index],
                );
              },
              activeColor: Colors.white70,
              checkColor: Colors.black,
              focusColor: Colors.white70,
              side: const BorderSide(color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }
}
