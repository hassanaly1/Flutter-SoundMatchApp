import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/sounds_service.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/models/sound_pack_model.dart';
import 'package:sound_app/utils/storage_helper.dart';

class MyUniversalController extends GetxController {
  RxBool isGuestUser = false.obs;

  RxList<SoundModel> soundsById = <SoundModel>[].obs;

  RxList<SoundPackModel> allSoundPacks = <SoundPackModel>[].obs;
  RxList<SoundPackModel> userSoundPacks = <SoundPackModel>[].obs;

  // RxList<Participant> participants = <Participant>[].obs;

  // Challenges
  RxList<ChallengeModel> challenges = <ChallengeModel>[
    ChallengeModel(
      challenge: Challenge(
        name: 'Free Sound Match',
        numberOfChallenges: '1',
        user: MyAppStorage.userId,
        sound: "",
        createdBy: MyAppStorage.userId,
      ),
      passingCriteria: [],
      challengeRoom: ChallengeRoom(
        users: [MyAppStorage.userId],
        totalMembers: 1,
        currentTurnHolder: MyAppStorage.userId,
      ),
      invitation: Invitation(
        type: 'challenge',
        recipients: [
          MyAppStorage.userId,
        ],
        createdBy: MyAppStorage.userId,
      ),
    )
  ].obs;

  // Add sound pack to the list
  void addOrRemoveSoundPack(SoundPackModel soundPack) {
    if (userSoundPacks.contains(soundPack)) {
      userSoundPacks.remove(soundPack);
      debugPrint(soundPack.packName);
    } else {
      userSoundPacks.add(soundPack);
      debugPrint(soundPack.packName);
    }
  }

  Future<void> fetchSoundPacks(int page) async {
    try {
      allSoundPacks.clear();

      final List<dynamic> fetchedSounds =
          await SoundServices().fetchSoundPacks(page);
      for (var soundPackData in fetchedSounds) {
        SoundPackModel soundPack = SoundPackModel.fromJson(soundPackData);
        allSoundPacks.add(soundPack);
      }
    } catch (e) {
      debugPrint('Error Fetching SoundPacks: $e');
    }
  }

  Future<void> fetchSoundsByPackId(String soundPackId) async {
    soundsById.clear();
    try {
      List<SoundModel> fetchedSounds =
          await SoundServices().fetchSoundsByPackId(soundPackId);
      soundsById.addAll(fetchedSounds);
      debugPrint(
          'Fetched Sounds for SoundPack ID $soundPackId: ${soundsById.length}');
    } catch (e) {
      debugPrint('Error Fetching Sounds for SoundPack ID $soundPackId: $e');
    }
  }

// Future<void> fetchParticipants(
//     {int page = 1, String searchString = ""}) async {
//   participants.clear();
//   try {
//     List<Participant> fetchedParticipants =
//         await SoundServices().fetchParticipants(searchString: searchString);
//     debugPrint('Fetched Participants: ${fetchedParticipants.length}');
//     participants.addAll(fetchedParticipants);
//     // Removing the current user from the participants list
//     participants
//         .removeWhere((participant) => participant.id == MyAppStorage.userId);
//   } catch (e) {
//     debugPrint('Error Fetching Participants: $e');
//   }
// }
}
