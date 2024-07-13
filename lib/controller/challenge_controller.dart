import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_app/data/challenge_service.dart';
import 'package:sound_app/models/challenge_room_model.dart';
import 'package:sound_app/models/participant_model.dart';
import 'package:sound_app/models/sound_model.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/view/challenge/challenge.dart';
import 'package:sound_app/view/challenge/results.dart';

class ChallengeController extends GetxController {
  ///AudioPlaying
  RxBool isDefaultAudioPlaying = false.obs;
  Rx<Duration> defaultAudioDuration = Duration.zero.obs;
  Rx<Duration> defaultAudioPosition = Duration.zero.obs;
  final AudioPlayer _defaultAudioPlayer = AudioPlayer(); //AudioPlayer
  RxBool isUserAudioPlaying = false.obs;
  RxBool isUserRecording = false.obs;
  Timer? recordingTimer;

  ///Audio Recording
  String? recordedFilePath;
  final FlutterSoundRecorder _audioRecorder =
      FlutterSoundRecorder(); //AudioRecorder

  /// Track the current participant's turn
  RxString currentTurnParticipantId = ''.obs;

  /// Track the current round status
  RxInt eachTurnDuration = 15.obs;
  RxInt originalTurnDuration = 15.obs;
  RxBool hasChallengeStarted = false.obs;
  RxBool isChallengeStarts = false.obs;
  RxBool isRoundCompleted = false.obs;
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
    recordingTimer?.cancel();
    recordingTimer = null;
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

  void onGameStarts({required String currentUserId, required String roomId}) {
    debugPrint('onGameStarts');
    // Start the timer only if it's not already running
    if (recordingTimer == null || !recordingTimer!.isActive) {
      debugPrint('StartTimerCalled');
      startTimer(currentUserId: currentUserId, roomId: roomId);
    }
  }

  void startTimer({required String currentUserId, required String roomId}) {
    recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (eachTurnDuration.value > 0) {
        eachTurnDuration.value--;
      } else {
        if (currentUserId == MyAppStorage.userId) {
          bool isSuccess = await ChallengeService().uploadUserSound(
              userRecordingInBytes: null,
              userId: currentUserId,
              roomId: roomId);
          if (isSuccess) {
            debugPrint(
                'Recording Uploaded Successfully of User $currentUserId in Room $roomId');
          }
        }
        update();
      }
    });
  }

  Future<void> onLongPressedStart() async {
    isUserRecording.value = true;
    await startRecording();
  }

  Future<void> onLongPressedEnd(
      {required String userId, required String roomId}) async {
    await stopRecording();
    if (userId == MyAppStorage.userId) {
      if (recordedFilePath != null) {
        final file = File(recordedFilePath!);
        final bytes = await file.readAsBytes();
        bool isSuccess = await ChallengeService().uploadUserSound(
            userRecordingInBytes: bytes, userId: userId, roomId: roomId);
        if (isSuccess) {
          debugPrint(
              'Recording Uploaded Successfully of User $userId  in Room $roomId');
        }
      }
    }
    update();
  }

  ///Starts Recording
  Future<void> startRecording() async {
    // isUserRecordingCompleted.value = false;
    try {
      final directory = await getApplicationDocumentsDirectory();
      recordedFilePath = '${directory.path}/recording.aac';
      await _audioRecorder.startRecorder(toFile: recordedFilePath);
      isUserRecording.value = true;
      // _startRecordingTimer();
    } catch (e) {
      debugPrint('Error Starting Recording: $e');
    }
  }

  ///Stops Recording
  Future<void> stopRecording() async {
    try {
      print('StoppingRecording');
      await _audioRecorder.stopRecorder();
      print('StoppedRecording');
      isUserRecording.value = false;
      // isUserRecordingCompleted.value = true;
      // _stopRecordingTimer();
      debugPrint('RecordedAudioPath: $recordedFilePath');
    } catch (e) {
      debugPrint('Error Stopping Recording: $e');
    }
  }

  void showCalculatingResultPopup(ChallengeRoomModel model) {
    debugPrint('ShowCalculatingResultPopupCalled');

    recordingTimer?.cancel();
    isUserRecording.value = false;
    hasChallengeStarted.value = false;
    eachTurnDuration.value = originalTurnDuration.value;
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
  }

  void resetControllerValues() {
    debugPrint('ResetControllerValuesCalled');
    eachTurnDuration.value = 15;
    originalTurnDuration.value = 15;
    isRoundCompleted.value = false;
  }
}
