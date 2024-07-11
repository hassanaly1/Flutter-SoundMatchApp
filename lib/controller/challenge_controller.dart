import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_app/models/challenge_room_model.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/view/challenge/challenge.dart';
import 'package:sound_app/view/challenge/results.dart';

class ChallengeController extends GetxController {
  RxBool isDefaultAudioPlaying = false.obs;
  Rx<Duration> defaultAudioDuration = Duration.zero.obs;
  Rx<Duration> defaultAudioPosition = Duration.zero.obs;
  final AudioPlayer _defaultAudioPlayer = AudioPlayer();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  RxBool isUserAudioPlaying = false.obs;
  RxBool isUserRecording = false.obs;
  Timer? _timer;

  // Track the current round
  RxInt currentRound = 1.obs;
  RxInt eachTurnDuration = 60.obs;
  RxInt originalTurnDuration = 5.obs;
  RxBool isRoundCompleted = false.obs;

  // Track the current participant's turn
  RxInt currentTurnIndex = 0.obs;
  RxInt currentUserIndex = 0.obs;
  RxBool isCurrentTurn = false.obs;

  // Track if the challenge is completed
  RxBool isChallengeStarts = false.obs;
  RxBool isChallengeCompleted = false.obs;
  RxInt countdownForNextRound = 60.obs;

  var totalParticipants = <Participant>[].obs;
  late Rx<SoundModel?> soundForChallenge;
  late RxInt totalRounds;

  @override
  void onInit() {
    super.onInit();
    _initializeRecorder();
    _defaultAudioPlayer.onDurationChanged.listen((duration) {
      defaultAudioDuration.value = duration;
    });

    _defaultAudioPlayer.onPositionChanged.listen((position) {
      defaultAudioPosition.value = position;
    });

    _defaultAudioPlayer.onPlayerComplete.listen((event) {
      isDefaultAudioPlaying.value = false;
      defaultAudioPosition.value = Duration.zero;
    });
  }

  Future<void> _initializeRecorder() async {
    try {
      await Permission.microphone.request();
      await _audioRecorder.openRecorder();
      _audioRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('Error Initializing Recorder: $e');
    }
  }

  ChallengeRoomModel? challenge;

  @override
  void onClose() {
    debugPrint('ChallengeControllerOnClosedCalled');
    _audioRecorder.closeRecorder();
    _timer?.cancel();
    super.onClose();
  }

  ///Toggle Default Audio
  Future<void> toggleDefaultAudio() async {
    try {
      if (isDefaultAudioPlaying.value) {
        await _defaultAudioPlayer.pause();
        isDefaultAudioPlaying.value = false;
      } else {
        await _defaultAudioPlayer.stop();
        // await _defaultAudioPlayer.play(AssetSource('music/music2.mp3'));
        await _defaultAudioPlayer.play(
          UrlSource(
            'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3',
          ),
        );
        isDefaultAudioPlaying.value = true;
      }
    } catch (e) {
      debugPrint('Error playing default audio: $e');
    }
  }

  void onGameStarts() {
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
        eachTurnDuration.value = 60;
        currentTurnIndex.value++;
        isUserRecording.value = false;
        update();
      }
    });
  }

  // void _startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (eachTurnDuration.value > 0) {
  //       eachTurnDuration.value--;
  //     } else {
  //       _timer?.cancel();
  //       eachTurnDuration.value = 60;
  //       currentTurnIndex.value++;
  //       isUserRecording.value = false;
  //       timerCompleted.value = true;
  //       update();
  //       if (currentTurnIndex.value < totalParticipants.length) {
  //         _restartTimer();
  //       }
  //       if (currentTurnIndex.value == totalParticipants.length) {
  //         if (challenge != null) {
  //           showCalculatingResultPopup(challenge!);
  //         }
  //
  //         isRoundCompleted.value = true;
  //         if (currentRound.value == totalRounds.value) {
  //           isChallengeCompleted.value = true;
  //         }
  //         update();
  //       }
  //     }
  //   });
  // }
  //
  // void _restartTimer() {
  //   if (_timer != null && _timer!.isActive) {
  //     _timer!.cancel();
  //   }
  //   _startTimer();
  // }
  //
  // void onLongPressedStart() {
  //   isUserRecording.value = true;
  //   // Start the timer only if it's not already running
  //   if (_timer == null || !_timer!.isActive) {
  //     _startTimer();
  //   }
  // }
  //
  // void onLongPressedEnd() {
  //   isUserRecording.value = false;
  //   if (!timerCompleted.value) {
  //     currentTurnIndex.value++;
  //     _restartTimer(); // Restart the timer
  //   }
  //   timerCompleted.value = false;
  //   eachTurnDuration.value = 5;
  //   update();
  //   // showCalculatingResultPopup();
  // }

  void showCalculatingResultPopup(ChallengeRoomModel model) {
    if (currentTurnIndex.value >= totalParticipants.length) {
      Get.dialog(
        const AlertDialog(
          backgroundColor: Colors.transparent,
          content: CalculatingResultPopup(),
        ),
      );
      // Navigate to the ResultScreen when the results are calculated.
      Future.delayed(const Duration(seconds: 5), () {
        Get.off(() => ResultScreen(model: model));
      });
      if (currentRound.value == totalRounds.value) {
        isChallengeCompleted.value = true;
      }
    }
  }

  void resetControllerValues() {
    debugPrint('ResetControllerValuesCalled');
    currentRound.value++;
    eachTurnDuration.value = 60;
    originalTurnDuration.value = 5;
    isRoundCompleted.value = false;
    currentTurnIndex.value = 0;
    currentUserIndex.value = 0;
    isCurrentTurn.value = false;
  }
}
