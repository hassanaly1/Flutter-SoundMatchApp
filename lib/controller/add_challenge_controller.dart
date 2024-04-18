import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/member_model.dart';
import 'package:sound_app/models/songs_model.dart';
import 'package:sound_app/models/sound_pack_model.dart';

class AddChallengeController extends GetxController {
  // RxBool isSoundPackSelected = false.obs;
  RxBool isMemberSelected = false.obs;
  RxInt gameRound = 1.obs;

  final MyUniversalController universalController = Get.find();

  // //Challenges
  // RxList<ChallengeModel> challenges = <ChallengeModel>[
  //   ChallengeModel(
  //       challengeName: 'Free Sound Match',
  //       song: SongsModel(songName: '', songImage: ''))
  // ].obs;
  //
  // //UsersSoundPackList
  // RxList<SoundPackModel> soundPacks = <SoundPackModel>[].obs;

  //CreateNewChallenge
  TextEditingController challengeNameController = TextEditingController();
  TextEditingController numberOfRounds = TextEditingController();
  //ParticipantsList
  RxList<Member> selectedMembers = <Member>[].obs; //for selectedMembers
  RxList<Member> filteredMembers = <Member>[].obs; //for searching
  //UsersSoundPackList
  //the sound user selects while creating the challenge
  Rx<SongsModel?> selectedSong = Rx<SongsModel?>(null);

  @override
  void onInit() {
    super.onInit();
    addListener(() {});
    filteredMembers.assignAll(members);
  }

  void updateGameRound(String value) {
    gameRound.value = int.parse(value);
  }

  void filterMembers(String query) {
    filteredMembers.assignAll(members
        .where((member) =>
            member.name!.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  void addMembers(Member member) {
    if (selectedMembers.contains(member)) {
      selectedMembers.remove(member);
    } else {
      selectedMembers.add(member);
    }
  }

  // void addSoundPack(SoundPackModel soundPack) {
  //   if (soundPacks.contains(soundPack)) {
  //     soundPacks.remove(soundPack);
  //     debugPrint(soundPack.packName);
  //     if (selectedSoundPack.value == soundPack) {
  //       // If the same sound is tapped again, deselect it
  //       isSoundPackSelected.value = false;
  //       selectedSoundPack.value = null;
  //     }
  //   } else {
  //     soundPacks.add(soundPack);
  //     debugPrint(soundPack.packName);
  //   }
  // }

  // void selectSound(SongsModel songsModel) {
  //   if (selectedSong.value == songsModel) {
  //     // If the same sound is tapped again, deselect it
  //     isSoundPackSelected.value = false;
  //     selectedSong.value = null;
  //   } else {
  //     // Deselect the previously selected sound
  //     isSoundPackSelected.value = false;
  //
  //     // Select the new sound
  //     isSoundPackSelected.value = true;
  //     selectedSong.value = songsModel;
  //   }
  // }

  void createChallenge(ChallengeModel challenge) {
    if (!universalController.challenges.contains(challenge)) {
      universalController.challenges.add(challenge);
      debugPrint(
          'Challenges Length : ${universalController.challenges.length.toString()}');
    }
  }

  // Rx<ChallengeModel> challengeModel =
  //     ChallengeModel(participants: [], challengeName: "").obs;

  // void updateChallengeModel(ChallengeModel updatedModel) {
  //   challengeModel.value = updatedModel;
  // }
}
