import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/add_challenge_controller.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/view/challenge/challenge.dart';
import 'package:sound_app/view/challenge/results.dart';

class ChallengeController extends GetxController {
  final AddChallengeController addChallengeController = Get.find();

  RxInt eachTurnDuration = 5.obs;
  RxInt originalTurnDuration = 5.obs;
  RxBool isDefaultAudioPlaying = false.obs;
  RxBool isUserAudioPlaying = false.obs;
  RxBool isUserRecording = false.obs;
  Timer? _timer;
  bool timerCompleted = false;

  // Track the current participant's turn
  RxInt currentTurnIndex = 0.obs;
  RxInt currentUserIndex = 0.obs;
  RxBool isCurrentTurn = false.obs;

  late List<Participant> totalParticipants;
  late Rx<SoundModel?> soundForChallenge;

  @override
  void onInit() {
    super.onInit();
    totalParticipants = addChallengeController.selectedMembers;
    soundForChallenge = addChallengeController.selectedSound;
    update();
  }

  RxBool isResultPopupVisible = false.obs;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void onGameStarts() {
    // Start the timer only if it's not already running
    if (_timer == null || !_timer!.isActive) {
      _startTimer();
    }
  }

  void _startTimer() {
    debugPrint('CurrentTurn: ${currentTurnIndex.value}');
    debugPrint('CurrentUser: ${currentUserIndex.value}');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (eachTurnDuration.value > 0) {
        eachTurnDuration.value--;
      } else {
        _timer?.cancel();
        eachTurnDuration.value = 5;
        currentTurnIndex.value++;
        isUserRecording.value = false;
        timerCompleted = true;
        update();
        if (currentTurnIndex.value < totalParticipants.length) {
          _restartTimer();
        }
        if (currentTurnIndex.value == totalParticipants.length) {
          showCalculatingResultPopup();
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

  void onLongPressedEnd() {
    isUserRecording.value = false;
    if (!timerCompleted) {
      currentTurnIndex.value++;
      _restartTimer(); // Restart the timer
    }
    timerCompleted = false;
    eachTurnDuration.value = 5;
    update();
    showCalculatingResultPopup();
  }

  void showCalculatingResultPopup() {
    if (currentTurnIndex.value >= totalParticipants.length) {
      isResultPopupVisible.value = true;
      Get.dialog(
        const AlertDialog(
          backgroundColor: Colors.transparent,
          content: CalculatingResultPopup(),
        ),
      );
      // Navigate to the ResultScreen when the results are calculated.
      Future.delayed(const Duration(seconds: 5), () {
        Get.off(() => const ResultScreen());
      });
    }
  }
}
