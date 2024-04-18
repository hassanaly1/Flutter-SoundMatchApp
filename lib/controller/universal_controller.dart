import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/sounds_service.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/songs_model.dart';
import 'package:sound_app/models/sound_pack_model.dart';

class MyUniversalController extends GetxController {
  // Reactive variables and lists
  RxBool isGuestUser = false.obs;
  Rx<SoundPackModel?> selectedSoundPack = Rx<SoundPackModel?>(null);
  RxBool isSoundPackSelected = false.obs;

  @override
  onInit() async {
    await fetchSoundPacks(1);
    debugPrint('SoundPacks: ${allSoundPacks.length}');
    super.onInit();
  }

  // Challenges
  RxList<ChallengeModel> challenges = <ChallengeModel>[
    ChallengeModel(
        challengeName: 'Free Sound Match', song: SongsModel(name: '', url: ''))
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

  // Method to fetch and integrate sounds for a specific sound pack
  // Future<void> fetchAndIntegrateSoundsForSoundPack(String soundPackId) async {
  //   // Create an instance of SoundServices
  //   SoundServices soundServices = SoundServices();
  //
  //   try {
  //     // Fetch sounds by sound pack ID
  //     final List<dynamic> fetchedSounds =
  //         await soundServices.fetchSoundById(soundPackId);
  //
  //     // Find the specific sound pack in the soundPacks list
  //     SoundPackModel? soundPackToUpdate = soundPacks
  //         .firstWhereOrNull((soundPack) => soundPack.id == soundPackId);
  //
  //     // If sound pack is found, integrate fetched sounds
  //     if (soundPackToUpdate != null) {
  //       // Clear existing sounds and integrate fetched sounds
  //       soundPackToUpdate.sounds.clear();
  //       for (var soundData in fetchedSounds) {
  //         SongsModel song = SongsModel.fromJson(soundData);
  //         soundPackToUpdate.sounds.add(song);
  //       }
  //
  //       // Update the sound pack in the list
  //       final index = soundPacks.indexOf(soundPackToUpdate);
  //       if (index != -1) {
  //         soundPacks[index] = soundPackToUpdate;
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching sounds for sound pack: $e');
  //   }
  // }

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
}
