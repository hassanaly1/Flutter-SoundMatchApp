import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/soundpacks/sound_pack_list.dart';
import 'package:sound_app/view/challenge/widgets/custom_soundpack_widget.dart';

class PurchaseSongsScreen extends StatelessWidget {
  PurchaseSongsScreen({super.key});
  final MyUniversalController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(fit: StackFit.expand, children: [
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
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white70)),
                iconTheme:
                    const IconThemeData(color: Colors.white60, size: 30.0),
                backgroundColor: Colors.transparent,
                title: CustomTextWidget(
                  text: 'Sound Treasury',
                  fontFamily: 'horta',
                  textColor: Colors.white,
                  fontSize: 26.0,
                ),
                centerTitle: true,
              ),
              body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        floating: true,
                        forceMaterialTransparency: true,
                        backgroundColor: Colors.transparent,
                        expandedHeight: context.height * 0.2,
                        flexibleSpace: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Image.asset(
                              'assets/images/shop.png',
                              height: context.height * 0.15,
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                          MyColorHelper.caribbeanCurrent.withOpacity(0.5),
                          MyColorHelper.verdigris.withOpacity(0.6),
                          MyColorHelper.white.withOpacity(0.4),
                          MyColorHelper.lightBlue.withOpacity(0.1),
                        ],
                        stops: const [0.1, 0.3, 0.9, 3],
                      ),
                    ),
                    child: ListView(
                      children: [
                        CustomTextWidget(
                          text: 'Your Sound Packs',
                          fontSize: 14.0,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          textColor: Colors.white,
                        ),
                        SizedBox(height: context.height * 0.02),
                        Obx(
                          () => Container(
                            color: Colors.transparent,
                            height: context.height * 0.2,
                            child: controller.userSoundPacks.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: CustomTextWidget(
                                        text:
                                            'Your sound bucket is currently empty. To add sounds, explore the collection of Signature Sounds below.',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        textColor: Colors.white,
                                        fontFamily: 'poppins',
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: controller.userSoundPacks.length,
                                    itemBuilder: (context, index) {
                                      final soundPack =
                                          controller.userSoundPacks[index];
                                      {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 80,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    controller.sounds
                                                        .clear(); //To remove the previously added sounds.
                                                    controller
                                                        .fetchSoundsByPackId(
                                                            soundPack.id);
                                                    debugPrint(
                                                        'SoundsLength: ${controller.sounds.length}');
                                                    Get.to(
                                                        () => SoundPackList(
                                                            soundPackModel:
                                                                soundPack,
                                                            sounds: controller
                                                                .sounds),
                                                        transition:
                                                            Transition.zoom,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500));
                                                  },
                                                  // onTap: () {
                                                  //   //   Get.to(
                                                  //   //   () => SoundPackList(
                                                  //   //     soundPackModel:
                                                  //   //         universalController
                                                  //   //                 .userSoundPacks[
                                                  //   //             index],
                                                  //   //   ),
                                                  //   //   transition: Transition.zoom,
                                                  //   //   duration: const Duration(
                                                  //   //       milliseconds: 500),
                                                  //   // );
                                                  // },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    backgroundImage:
                                                        NetworkImage(soundPack
                                                            .packImage),
                                                    radius: 40,
                                                  ),
                                                ),
                                                CustomTextWidget(
                                                  text: soundPack.packName,
                                                  textColor: Colors.white70,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                          ),
                        ),
                        const Divider(),
                        SizedBox(height: context.height * 0.02),
                        CustomTextWidget(
                          text: 'Discover Signature Sound Packs',
                          fontSize: 14.0,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          textColor: Colors.white,
                        ),
                        controller.allSoundPacks.isEmpty
                            ? const Center(
                                heightFactor: 5.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.allSoundPacks
                                    .where((soundPack) =>
                                        soundPack.isPaid == false)
                                    .length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.6,
                                ),
                                itemBuilder: (context, index) {
                                  final paidSoundPacks = controller
                                      .allSoundPacks
                                      .where((soundPack) =>
                                          soundPack.isPaid == false)
                                      .toList();
                                  if (index < paidSoundPacks.length) {
                                    // Show paid soundPacks
                                    return CustomSoundPackWidget(
                                      soundPackModel: paidSoundPacks[index],
                                      // showTickIcon: false,
                                      // showAddIcon: true,
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
                  )),
            ),
          ),
        )
      ]),
    );
  }
}
