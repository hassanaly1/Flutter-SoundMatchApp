import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/create_challenge_controller.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/view/challenge/challenge.dart';
import 'package:sound_app/view/challenge/results.dart';

class ChallengeController extends GetxController {
  final CreateChallengeController addChallengeController = Get.find();

  RxBool isDefaultAudioPlaying = false.obs;
  RxBool isUserAudioPlaying = false.obs;
  RxBool isUserRecording = false.obs;
  Timer? _timer;

  // Track the current round
  RxInt currentRound = 1.obs;
  RxInt eachTurnDuration = 5.obs;
  RxInt originalTurnDuration = 5.obs;
  RxBool timerCompleted = false.obs;
  RxBool isRoundCompleted = false.obs;

  // Track the current participant's turn
  RxInt currentTurnIndex = 0.obs;
  RxInt currentUserIndex = 0.obs;
  RxBool isCurrentTurn = false.obs;

  // Track if the challenge is completed
  RxBool isChallengeCompleted = false.obs;
  RxInt countdownForNextRound = 60.obs;

  late List<Participant> totalParticipants;
  late Rx<SoundModel?> soundForChallenge;
  late RxInt totalRounds;

  @override
  void onInit() {
    super.onInit();
    debugPrint('ChallengeControllerInitialized');
    totalParticipants = addChallengeController.selectedParticipants;
    soundForChallenge = addChallengeController.selectedSound;
    totalRounds = addChallengeController.numberOfRounds;
    update();
  }

  ChallengeModel? challenge;

  @override
  void onClose() {
    debugPrint('ChallengeControllerOnClosedCalled');
    _timer?.cancel();
    super.onClose();
  }

  // updateChallengeModel(ChallengeModel challengeModel) {
  //   ChallengeModel updatedChallengeModel = ChallengeModel(
  //     id: challengeModel.id,
  //     challengeName: challengeModel.challengeName,
  //     participants: challengeModel.participants
  //         ?.where((p) => p.firstName == 'John Doe')
  //         .toList(),
  //     numberOfRounds: challengeModel.numberOfRounds,
  //     song: challengeModel.song,
  //   );
  //   return updatedChallengeModel;
  // }

  void onGameStarts(ChallengeModel challengeModel) {
    challenge = challengeModel;
    // Start the timer only if it's not already running
    if (_timer == null || !_timer!.isActive) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (eachTurnDuration.value > 0) {
        eachTurnDuration.value--;
      } else {
        _timer?.cancel();
        eachTurnDuration.value = 5;
        currentTurnIndex.value++;
        isUserRecording.value = false;
        timerCompleted.value = true;
        update();
        if (currentTurnIndex.value < totalParticipants.length) {
          _restartTimer();
        }
        if (currentTurnIndex.value == totalParticipants.length) {
          if (challenge != null) {
            showCalculatingResultPopup(challenge!);
          }

          isRoundCompleted.value = true;
          if (currentRound.value == totalRounds.value) {
            isChallengeCompleted.value = true;
          }
          update();
        }
      }
    });
  }

  void _restartTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _startTimer();
  }

  void onLongPressedStart() {
    isUserRecording.value = true;
    // Start the timer only if it's not already running
    if (_timer == null || !_timer!.isActive) {
      _startTimer();
    }
  }

  void onLongPressedEnd(ChallengeModel challengeModel) {
    isUserRecording.value = false;
    if (!timerCompleted.value) {
      currentTurnIndex.value++;
      _restartTimer(); // Restart the timer
    }
    timerCompleted.value = false;
    eachTurnDuration.value = 5;
    update();
    // showCalculatingResultPopup();
  }

  void showCalculatingResultPopup(ChallengeModel challengeModel) {
    if (currentTurnIndex.value >= totalParticipants.length) {
      Get.dialog(
        const AlertDialog(
          backgroundColor: Colors.transparent,
          content: CalculatingResultPopup(),
        ),
      );
      // Navigate to the ResultScreen when the results are calculated.
      Future.delayed(const Duration(seconds: 5), () {
        Get.off(() => ResultScreen(challengeModel: challengeModel));
      });
      if (currentRound.value == totalRounds.value) {
        isChallengeCompleted.value = true;
      }
    }
  }

  void resetControllerValues() {
    debugPrint('ResetControllerValuesCalled');
    currentRound.value++;
    eachTurnDuration.value = 5;
    originalTurnDuration.value = 5;
    timerCompleted.value = false;
    isRoundCompleted.value = false;
    currentTurnIndex.value = 0;
    currentUserIndex.value = 0;
    isCurrentTurn.value = false;
  }
}
