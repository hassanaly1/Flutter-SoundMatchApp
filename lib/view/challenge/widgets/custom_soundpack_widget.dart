import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/sound_pack_model.dart';
import 'package:sound_app/view/soundpacks/sound_pack_list.dart';

class CustomSoundPackWidget extends StatelessWidget {
  final SoundPackModel soundPackModel;

  // final bool? showAddIcon;
  // final bool showTickIcon;

  CustomSoundPackWidget({
    super.key,
    required this.soundPackModel,
    // this.showAddIcon = true,
    // required this.showTickIcon,
  });

  final MyUniversalController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          controller.soundsById
              .clear(); //To remove the previously added sounds.
          controller.fetchSoundsByPackId(soundPackModel.id);
          debugPrint('SoundsLength: ${controller.soundsById.length}');
          Get.to(
              () => SoundPackList(
                  soundPackModel: soundPackModel,
                  sounds: controller.soundsById),
              transition: Transition.zoom,
              duration: const Duration(milliseconds: 500));
          // showTickIcon == true
          //     ? controller.selectedSoundPack(soundPackModel)
          //     : Get.to(
          //         () => SoundPackList(
          //           soundPackModel: soundPackModel,
          //         ),
          //         transition: Transition.zoom,
          //         duration: const Duration(milliseconds: 500),
          //       );
        },
        child: SizedBox(
          width: 100,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.network(
                        soundPackModel.packImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      )),
                  CustomTextWidget(
                    text: soundPackModel.packName,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'poppins',
                    textColor: Colors.white,
                  ),
                ],
              ),
              Obx(
                () => Positioned(
                  top: 10,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      controller.addOrRemoveSoundPack(soundPackModel);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.lightGreen),
                      child: Icon(
                          controller.userSoundPacks.contains(soundPackModel)
                              ? Icons.done
                              : Icons.add,
                          size: 20,
                          color: Colors.black87),
                    ),
                  ),
                ),
              ),
              // showTickIcon == true
              //     ? Obx(
              //         () => Visibility(
              //           visible: controller.isSoundPackSelected.value &&
              //               controller.selectedSoundPack.value ==
              //                   soundPackModel,
              //           child: Positioned(
              //             top: 10,
              //             right: 0,
              //             child: Container(
              //               padding: const EdgeInsets.all(4.0),
              //               decoration: const BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: Colors.lightGreen),
              //               child: const Icon(
              //                 Icons.done,
              //                 size: 12,
              //                 color: Colors.black87,
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : Obx(
              //         () => Visibility(
              //           visible: showAddIcon == true,
              //           child: Positioned(
              //             top: 10,
              //             right: 0,
              //             child: GestureDetector(
              //               onTap: () {
              //                 controller.userSoundPacks.contains(soundPackModel)
              //                     ? showDialog(
              //                         context: context,
              //                         builder: (BuildContext context) {
              //                           return AlertDialog(
              //                             insetPadding:
              //                                 const EdgeInsets.symmetric(
              //                                     horizontal: 10),
              //                             backgroundColor: Colors.transparent,
              //                             content: CreateAccountPopup(
              //                                 onTap: () {
              //                                   controller.addOrRemoveSoundPack(
              //                                       soundPackModel);
              //                                   Get.back();
              //                                 },
              //                                 buttonText: 'Remove',
              //                                 isSvg: false,
              //                                 imagePath:
              //                                     'assets/images/remove.png',
              //                                 text:
              //                                     'Are you sure to remove this sound pack from your bucket?',
              //                                 opacity: 1),
              //                           );
              //                         },
              //                       )
              //                     : showDialog(
              //                         context: context,
              //                         builder: (BuildContext context) {
              //                           return AlertDialog(
              //                             insetPadding:
              //                                 const EdgeInsets.symmetric(
              //                                     horizontal: 10),
              //                             backgroundColor: Colors.transparent,
              //                             content: CreateAccountPopup(
              //                                 onTap: () {
              //                                   controller.addOrRemoveSoundPack(
              //                                       soundPackModel);
              //                                   Get.back();
              //                                 },
              //                                 buttonText: 'Buy Now',
              //                                 isSvg: true,
              //                                 imagePath:
              //                                     'assets/svgs/payment.svg',
              //                                 text:
              //                                     'Upgrade your gaming sound with this amazing sound pack!',
              //                                 opacity: 1),
              //                           );
              //                         },
              //                       );
              //               },
              //               child: Container(
              //                 padding: const EdgeInsets.all(4.0),
              //                 decoration: BoxDecoration(
              //                     shape: BoxShape.circle,
              //                     color: controller.userSoundPacks
              //                             .contains(soundPackModel)
              //                         ? Colors.lightGreen
              //                         : Colors.white70),
              //                 child: Icon(
              //                   controller.userSoundPacks
              //                           .contains(soundPackModel)
              //                       ? Icons.done
              //                       : Icons.add,
              //                   size: 22,
              //                   color: Colors.black,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}
