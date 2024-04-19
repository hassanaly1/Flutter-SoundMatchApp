import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/sounds_service.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/models/sound_pack_model.dart';

class MyUniversalController extends GetxController {
  // Reactive variables and lists
  RxBool isGuestUser = false.obs;
  Rx<SoundPackModel?> selectedSoundPack = Rx<SoundPackModel?>(null);
  RxBool isSoundPackSelected = false.obs;

  // Reactive list for sounds based on sound pack ID
  RxList<SoundModel> sounds = <SoundModel>[].obs;

  @override
  onInit() async {
    await fetchSoundPacks(1);
    debugPrint('SoundPacks: ${allSoundPacks.length}');
    super.onInit();
  }

  // Challenges
  RxList<ChallengeModel> challenges = <ChallengeModel>[
    ChallengeModel(
        challengeName: 'Free Sound Match', song: SoundModel(name: '', url: ''))
  ].obs;

  // all sound pack list
  RxList<SoundPackModel> allSoundPacks = <SoundPackModel>[].obs;
  // user sound pack list
  RxList<SoundPackModel> userSoundPacks = <SoundPackModel>[].obs;

  // Add sound pack to the list
  void addOrRemoveSoundPack(SoundPackModel soundPack) {
    if (userSoundPacks.contains(soundPack)) {
      userSoundPacks.remove(soundPack);
      debugPrint(soundPack.packName);
      // if (selectedSoundPack.value == soundPack) {
      //   // If the same sound is tapped again, deselect it
      //   isSoundPackSelected.value = false;
      //   selectedSoundPack.value = null;
      // }
    } else {
      userSoundPacks.add(soundPack);
      debugPrint(soundPack.packName);
    }
  }

  //ApiCalls
  Future<void> fetchSoundPacks(int page) async {
    try {
      final List<dynamic> fetchedSounds =
          await SoundServices().fetchSoundPacks(page);
      // Convert fetchedSounds to SoundPackModel and add them to soundPacks list
      for (var soundData in fetchedSounds) {
        SoundPackModel soundPack = SoundPackModel.fromJson(soundData);
        allSoundPacks.add(soundPack);
      }
    } catch (e) {
      debugPrint('Error fetching sounds: $e');
    }
  }

  // Method to fetch sounds of a particular sound pack
  Future<void> fetchSoundsByPackId(String soundPackId) async {
    try {
      List<SoundModel> fetchedSounds =
          await SoundServices().fetchSoundsByPackId(soundPackId);
      sounds.clear();
      sounds.addAll(fetchedSounds);

      debugPrint(
          'Fetched sounds for sound pack ID $soundPackId: ${sounds.length}');
    } catch (e) {
      debugPrint('Error fetching sounds for sound pack ID $soundPackId: $e');
    }
  }
}
