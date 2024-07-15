import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sound_app/data/sounds_service.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/models/sound_pack_model.dart';
import 'package:sound_app/utils/storage_helper.dart';

class MyUniversalController extends GetxController {
  RxBool isGuestUser = false.obs;
  RxBool isConnectedToInternet = false.obs;
  StreamSubscription? _internetConnectionStreamSubscription;
  RxList<SoundModel> soundsById = <SoundModel>[].obs;

  RxList<SoundPackModel> allSoundPacks = <SoundPackModel>[].obs;
  RxList<SoundPackModel> userSoundPacks = <SoundPackModel>[].obs;

  @override
  void onInit() {
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen(
      (event) {
        debugPrint('Internet Status: $event');
        switch (event) {
          case InternetStatus.connected:
            isConnectedToInternet.value = true;
            break;
          case InternetStatus.disconnected:
            isConnectedToInternet.value = false;
            break;
          default:
            isConnectedToInternet.value = false;
            break;
        }
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    _internetConnectionStreamSubscription?.cancel();
    super.onClose();
  }

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
}
