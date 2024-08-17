import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/sounds_service.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/utils/storage_helper.dart';

class CreateChallengeController extends GetxController {
  var isParticipantsAreLoading = false.obs;
  RxBool isMemberSelected = false.obs;
  RxInt numberOfRounds = 1.obs;
  List<TextEditingController> passingCriteriaControllers = [];

  //CreateNewChallenge
  TextEditingController challengeNameController = TextEditingController();

  //ParticipantsList
  var participants = <Participant>[].obs;
  RxList<Participant> selectedParticipants = <Participant>[].obs;
  ScrollController scrollController = ScrollController();
  final RxInt _currentPage = 1.obs;

  //the sound user selects while creating the challenge
  RxBool isSoundSelected = false.obs;
  Rx<SoundModel?> selectedSound = Rx<SoundModel?>(null);

  void updateNumberOfRounds(int newCount) {
    numberOfRounds.value = newCount;
    passingCriteriaControllers = List.generate(
      newCount,
      (index) => TextEditingController(),
    );
  }

  @override
  void onInit() {
    super.onInit();
    updateNumberOfRounds(numberOfRounds.value);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isParticipantsAreLoading.value) {
          _loadNextPageParticipants();
        }
      }
    });
  }

  @override
  void onClose() {
    debugPrint('CreateChallengeControllerOnClosedCalled');
    challengeNameController.dispose();
    selectedParticipants.clear();
    scrollController.dispose();
    for (var controller in passingCriteriaControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void _loadNextPageParticipants() async {
    isParticipantsAreLoading.value = true;

    final List<Participant> nextPageParticipants = await SoundServices()
        .fetchParticipants(searchString: '', page: _currentPage.value);

    // Create a Set of existing participant IDs to avoid duplicates
    Set<String?> existingParticipantsIds =
        participants.map((participant) => participant.id).toSet();

    // Add only unique Participants
    for (var participant in nextPageParticipants) {
      if (!existingParticipantsIds.contains(participant.id)) {
        participants.add(participant);
        // Update the set with the new soundpack ID
        existingParticipantsIds.add(participant.id);
      }
    }

    // Only increment the page if we received a full page of soundpacks
    if (nextPageParticipants.length >= 10) {
      _currentPage.value++;
    }

    isParticipantsAreLoading.value = false;
  }

  Future<void> fetchParticipants({required String searchString}) async {
    participants.clear();
    try {
      List<Participant> fetchedParticipants = await SoundServices()
          .fetchParticipants(
              searchString: searchString, page: _currentPage.value);
      debugPrint('Fetched Participants: ${fetchedParticipants.length}');
      participants.addAll(fetchedParticipants);
      // Removing the current user from the participants list
      participants.removeWhere((participant) =>
          participant.id == MyAppStorage.storage.read('user_info')['_id']);
    } catch (e) {
      debugPrint('Error Fetching Participants: $e');
    }
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
}
