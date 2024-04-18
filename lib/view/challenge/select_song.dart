// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:sound_app/controller/add_challenge_controller.dart';
// import 'package:sound_app/controller/universal_controller.dart';
// import 'package:sound_app/helper/asset_helper.dart';
// import 'package:sound_app/helper/colors.dart';
// import 'package:sound_app/view/challenge/widgets/custom_sound_avatar.dart';
// import 'package:sound_app/helper/custom_text_widget.dart';
//
// class SelectSongsScreen extends StatelessWidget {
//   SelectSongsScreen({super.key});
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     final MyUniversalController controller = Get.find();
//     final AddChallengeController addChallengeController = Get.find();
//     return SafeArea(
//         child: Stack(fit: StackFit.expand, children: [
//       SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
//       Padding(
//         padding: const EdgeInsets.only(top: 12.0),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: Scaffold(
//             key: scaffoldKey,
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               leading: IconButton(
//                   onPressed: () {
//                     // ScaffoldMessenger.of(context).removeCurrentSnackBar();
//                     Get.back();
//                   },
//                   icon: Obx(
//                     () => Container(
//                         padding: const EdgeInsets.all(4.0),
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: addChallengeController.selectedSong.value !=
//                                     null
//                                 ? Colors.lightGreen
//                                 : Colors.redAccent),
//                         child: Icon(
//                           addChallengeController.selectedSong.value != null
//                               ? Icons.done
//                               : Icons.close,
//                           color: Colors.white,
//                         )),
//                   )),
//               iconTheme: const IconThemeData(size: 20.0),
//               backgroundColor: Colors.transparent,
//               title: CustomTextWidget(
//                 text: 'Sound Treasury',
//                 fontFamily: 'horta',
//                 textColor: Colors.white,
//                 fontSize: 26.0,
//               ),
//               centerTitle: true,
//             ),
//             body: Obx(
//               () => controller.soundPacks.isEmpty
//                   ? Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomTextWidget(
//                               text:
//                                   'Your sound bucket is currently empty. To add sounds, explore the collection of Signature Sounds below.',
//                               fontSize: 14.0,
//                               fontWeight: FontWeight.w400,
//                               textColor: Colors.white,
//                               fontFamily: 'poppins',
//                               textAlign: TextAlign.center,
//                               maxLines: 3,
//                             ),
//                             const SizedBox(height: 20.0),
//                           ],
//                         ),
//                       ),
//                     )
//                   : DefaultTabController(
//                       length: controller.soundPacks.length,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             height: context.height * 0.2,
//                             color: Colors.transparent,
//                             child: TabBar(
//                               isScrollable: true,
//                               tabAlignment: TabAlignment.center,
//                               tabs: [
//                                 for (int i = 0;
//                                     i < controller.soundPacks.length;
//                                     i++)
//                                   // Create tabs based on the usersSongs.length
//                                   Tab(
//                                     height: context.height * 0.15,
//                                     child: CustomSoundAvatar(
//                                         soundPackModel:
//                                             controller.soundPacks[i]),
//                                   ),
//                               ],
//                               labelColor: MyColorHelper.white,
//                               unselectedLabelColor: Colors.grey,
//                               indicatorColor: Colors.white,
//                             ),
//                           ),
//                           Expanded(
//                             child: TabBarView(
//                               children: [
//                                 for (int i = 0;
//                                     i < controller.soundPacks.length;
//                                     i++)
//                                   ListView(
//                                     children: [
//                                       SizedBox(height: context.height * 0.02),
//                                       CustomTextWidget(
//                                         text: controller.soundPacks[i].packName,
//                                         fontSize: 14.0,
//                                         textAlign: TextAlign.center,
//                                         fontWeight: FontWeight.w600,
//                                         fontFamily: 'poppins',
//                                         textColor: Colors.white,
//                                       ),
//                                       ListView.builder(
//                                         shrinkWrap: true,
//                                         itemCount: 10,
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                         itemBuilder: (context, index) {
//                                           return Obx(
//                                             () => Container(
//                                               margin:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 8.0),
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       color: addChallengeController
//                                                                   .selectedSong
//                                                                   .value ==
//                                                               controller
//                                                                   .soundPacks[i]
//                                                                   .songs[index]
//                                                           ? Colors.white
//                                                           : Colors
//                                                               .transparent)),
//                                               child: ListTile(
//                                                 leading: CircleAvatar(
//                                                   backgroundImage: NetworkImage(
//                                                       controller
//                                                           .soundPacks[i]
//                                                           .songs[index]
//                                                           .songImage),
//                                                 ),
//                                                 title: CustomTextWidget(
//                                                   text: controller.soundPacks[i]
//                                                       .songs[index].songName,
//                                                   textColor:
//                                                       addChallengeController
//                                                                   .selectedSong
//                                                                   .value ==
//                                                               controller
//                                                                   .soundPacks[i]
//                                                                   .songs[index]
//                                                           ? Colors.white
//                                                           : Colors.white60,
//                                                   fontSize: 14.0,
//                                                   fontWeight:
//                                                       addChallengeController
//                                                                   .selectedSong
//                                                                   .value ==
//                                                               controller
//                                                                   .soundPacks[i]
//                                                                   .songs[index]
//                                                           ? FontWeight.w700
//                                                           : FontWeight.w400,
//                                                   fontFamily: 'poppins',
//                                                 ),
//                                                 trailing: Obx(
//                                                   () => Checkbox(
//                                                     activeColor: Colors.white70,
//                                                     checkColor: Colors.black,
//                                                     focusColor: Colors.white70,
//                                                     side: const BorderSide(
//                                                         color: Colors.white54),
//                                                     onChanged: (bool? value) {
//                                                       addChallengeController
//                                                           .selectedSong();
//                                                     },
//                                                     value: addChallengeController
//                                                             .isSoundPackSelected
//                                                             .value &&
//                                                         addChallengeController
//                                                                 .selectedSong
//                                                                 .value ==
//                                                             controller
//                                                                 .soundPacks[i]
//                                                                 .songs[index],
//                                                   ),
//                                                 ),
//                                                 onTap: () {
//                                                   addChallengeController
//                                                       .selectSound(controller
//                                                           .soundPacks[i]
//                                                           .songs[index]);
//                                                 },
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       )
//                                     ],
//                                   )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     ]));
//   }
// }
