import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';

class CreateChallengeController extends GetxController {
  // RxBool isSoundPackSelected = false.obs;
  RxBool isMemberSelected = false.obs;
  RxInt numberOfRounds = 1.obs;
  List<TextEditingController> passingCriteriaControllers = [];

  // final MyUniversalController universalController = Get.find();

  //CreateNewChallenge
  TextEditingController challengeNameController = TextEditingController();

  //ParticipantsList
  RxList<Participant> selectedParticipants = <Participant>[].obs;

  //the sound user selects while creating the challenge
  RxBool isSoundSelected = false.obs;
  Rx<SoundModel?> selectedSound = Rx<SoundModel?>(null);

  RxList<SoundModel> sounds = <SoundModel>[].obs;

  void updateNumberOfRounds(int newCount) {
    numberOfRounds.value = newCount;
    passingCriteriaControllers = List.generate(
      newCount,
      (index) => TextEditingController(),
    );
  }

  @override
  void onInit() {
    updateNumberOfRounds(numberOfRounds.value);
    super.onInit();
  }

  @override
  void onClose() {
    for (var controller in passingCriteriaControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void updateGameRound(String value) {
    numberOfRounds.value = int.parse(value);
  }

  void addMembers(Participant participant) {
    if (selectedParticipants.contains(participant)) {
      selectedParticipants.remove(participant);
    } else {
      selectedParticipants.add(participant);
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

  void selectSound(SoundModel sound) {
    if (selectedSound.value == sound) {
      // If the same sound is tapped again, deselect it
      isSoundSelected.value = false;
      selectedSound.value = null;
    } else {
      // Deselect the previously selected sound
      isSoundSelected.value = false;

      // Select the new sound
      isSoundSelected.value = true;
      selectedSound.value = sound;
    }
  }

// void createChallenge(ChallengeModel challenge) {
//   if (!universalController.challenges.contains(challenge)) {
//     universalController.challenges.add(challenge);
//     debugPrint(
//         'Challenges Length : ${universalController.challenges.length.toString()}');
//     Get.off(() => ChallengeScreen(challengeModel: challenge));
//   }
// }

// Rx<ChallengeModel> challengeModel =
//     ChallengeModel(participants: [], challengeName: "").obs;

// void updateChallengeModel(ChallengeModel updatedModel) {
//   challengeModel.value = updatedModel;
// }
}
