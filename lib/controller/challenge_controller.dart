import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChallengeController extends GetxController {
  RxBool isDefaultAudioPlaying = false.obs;
  RxBool isUserAudioPlaying = false.obs;
  RxBool isUserRecording = false.obs;

  // RxInt to track the current participant's turn
  RxInt currentTurnIndex = 0.obs;

  final CountDownController countDownController = CountDownController();

  void onLongPressedStart() {
    debugPrint('ON-LONG-PRESS-START');
  }

  void onLongPressedEnd() {
    debugPrint('ON-LONG-PRESS-END');
    countDownController.restart();
    currentTurnIndex.value++;
    debugPrint('CURRENT-INDEX-VALUE: ${currentTurnIndex.value}');
    update();
  }

  void onCountdownComplete() {
    debugPrint('ON-COUNTDOWN-COMPLETE-CALLED');

    currentTurnIndex.value++;
    debugPrint('CURRENT-INDEX-VALUE: ${currentTurnIndex.value}');
    update();
    countDownController.restart(duration: 2);
  }

  // Method to set the current turn index
  void setCurrentTurn(int index) {
    currentTurnIndex.value = index;
  }
}
