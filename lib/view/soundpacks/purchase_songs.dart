import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/challenge/widgets/custom_soundpack_widget.dart';
import 'package:sound_app/view/soundpacks/sound_pack_list.dart';

class PurchaseSongsScreen extends StatefulWidget {
  const PurchaseSongsScreen({super.key});

  @override
  State<PurchaseSongsScreen> createState() => _PurchaseSongsScreenState();
}

class _PurchaseSongsScreenState extends State<PurchaseSongsScreen> {
  final MyUniversalController controller = Get.find();

  @override
  void initState() {
    fetchSoundPacks();
    // getAllSoundPacksByUserId();
    super.initState();
  }

  // void getAllSoundPacksByUserId() {
  //   io.Socket socket = SocketService().getSocket();
  //   try {
  //     final data = MyAppStorage.storage.read('user_info')['_id'];
  //     socket.emit('get_sound_packs_by_user', data);
  //
  //     //Get the Users SoundPacks.
  //     socket.on(
  //       'soundpacks',
  //       (data) {
  //         print('UsersSoundPacksData: $data');
  //         controller.userSoundPacks.clear();
  //         for (var soundPackData in data) {
  //           SoundPackModel soundPack = SoundPackModel.fromJson(soundPackData);
  //           controller.userSoundPacks.add(soundPack);
  //         }
  //         debugPrint('UsersSoundPacks: ${controller.userSoundPacks.length}');
  //       },
  //     );
  //   } catch (e) {
  //     debugPrint('Error Getting SoundPacks: $e');
  //   }
  // }

  Future<void> fetchSoundPacks() async {
    await controller.fetchSoundPacks();
    debugPrint('AllSoundPacks: ${controller.allSoundPacks.length}');
  }

  @override
  Widget build(BuildContext context) {
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
                        if (controller.userSoundPacks.isNotEmpty) {
                          controller.fetchSoundsByPackId(
                            controller.userSoundPacks[0].id,
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white70)),
                  iconTheme:
                      const IconThemeData(color: Colors.white60, size: 30.0),
                  backgroundColor: Colors.transparent,
                  title: const CustomTextWidget(
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
                              // physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Image.asset('assets/images/shop.png',
                                    height: context.height * 0.15)
                              ])),
                    ];
                  },
                  body: RefreshIndicator(
                    onRefresh: () => controller.fetchSoundPacks(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16.0,
                      ),
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
                              MyColorHelper.lightBlue.withOpacity(0.1)
                            ],
                            stops: const [0.1, 0.3, 0.9, 3],
                          )),
                      child: ListView(
                        controller: controller.scrollController,
                        // physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const CustomTextWidget(
                              text: 'Your Sound Packs',
                              fontSize: 16.0,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w600,
                              textColor: Colors.white),
                          SizedBox(height: context.height * 0.02),
                          UsersSoundPacksWidget(controller: controller),
                          const Divider(),
                          SizedBox(height: context.height * 0.02),
                          const CustomTextWidget(
                              text: 'Discover Signature Sound Packs',
                              fontSize: 16.0,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w600,
                              textColor: Colors.white),
                          SizedBox(height: context.height * 0.02),
                          AllSoundPacksWidget(controller: controller),
                        ],
                      ),
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
}

class AllSoundPacksWidget extends StatelessWidget {
  const AllSoundPacksWidget({
    super.key,
    required this.controller,
  });

  final MyUniversalController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.allSoundPacks.isEmpty
        ? const Center(
            heightFactor: 5.0,
            child: SpinKitFadingCircle(color: Colors.black87))
        : Wrap(
            children: controller.allSoundPacks
                .map((soundPack) =>
                    CustomSoundPackWidget(soundPackModel: soundPack))
                .toList(),
          ));
  }
}

class UsersSoundPacksWidget extends StatelessWidget {
  const UsersSoundPacksWidget({
    super.key,
    required this.controller,
  });

  final MyUniversalController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.transparent,
        height: context.height * 0.2,
        child: controller.userSoundPacks.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
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
                  final userSoundPack = controller.userSoundPacks[index];
                  {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.soundsById.clear();
                                controller.fetchSoundsByPackId(
                                  userSoundPack.id,
                                );
                                Get.to(
                                  () => SoundPackList(
                                    soundPackModel: userSoundPack,
                                    sounds: controller.soundsById,
                                  ),
                                  transition: Transition.zoom,
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: NetworkImage(
                                  userSoundPack.packImage,
                                ),
                                radius: 40,
                              ),
                            ),
                            CustomTextWidget(
                              text: userSoundPack.packName,
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
    );
  }
}
