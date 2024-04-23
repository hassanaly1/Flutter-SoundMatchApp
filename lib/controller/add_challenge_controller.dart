import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/view/challenge/challenge.dart';

class AddChallengeController extends GetxController {
  // RxBool isSoundPackSelected = false.obs;
  RxBool isMemberSelected = false.obs;
  RxInt numberOfRounds = 1.obs;

  final MyUniversalController universalController = Get.find();

  //CreateNewChallenge
  TextEditingController challengeNameController = TextEditingController();
  TextEditingController numberOfRoundsController = TextEditingController();
  //ParticipantsList
  RxList<Participant> selectedMembers =
      <Participant>[].obs; //for selectedMembers
  RxList<Participant> filteredMembers = <Participant>[].obs; //for searching
  //UsersSoundPackList
  //the sound user selects while creating the challenge
  RxBool isSoundSelected = false.obs;
  Rx<SoundModel?> selectedSound = Rx<SoundModel?>(null);

  RxList<SoundModel> sounds = <SoundModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    addListener(() {});
    filteredMembers.assignAll(participants);
  }

  void updateGameRound(String value) {
    numberOfRounds.value = int.parse(value);
  }

  void filterMembers(String query) {
    filteredMembers.assignAll(participants
        .where((participant) =>
            participant.name!.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  void addMembers(Participant member) {
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

  void selectSound(SoundModel songsModel) {
    if (selectedSound.value == songsModel) {
      // If the same sound is tapped again, deselect it
      isSoundSelected.value = false;
      selectedSound.value = null;
    } else {
      // Deselect the previously selected sound
      isSoundSelected.value = false;

      // Select the new sound
      isSoundSelected.value = true;
      selectedSound.value = songsModel;
    }
  }

  void createChallenge(ChallengeModel challenge) {
    if (!universalController.challenges.contains(challenge)) {
      universalController.challenges.add(challenge);
      debugPrint(
          'Challenges Length : ${universalController.challenges.length.toString()}');
      Get.off(() => ChallengeScreen(challengeModel: challenge));
    }
  }

  // Rx<ChallengeModel> challengeModel =
  //     ChallengeModel(participants: [], challengeName: "").obs;

  // void updateChallengeModel(ChallengeModel updatedModel) {
  //   challengeModel.value = updatedModel;
  // }
}
