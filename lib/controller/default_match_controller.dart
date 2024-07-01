import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DefaultMatchController extends GetxController {
  RxBool isDefaultAudioPlaying = false.obs;
  RxBool isUserAudioPlaying = false.obs;
  RxBool isUserRecording = false.obs;
  RxBool isUserRecordingCompleted = false.obs;
  RxBool isResultCalculating = false.obs;
  RxBool isResultCalculated = false.obs;

  Rx<Duration> defaultAudioDuration = Duration.zero.obs;
  Rx<Duration> defaultAudioPosition = Duration.zero.obs;

  Rx<Duration> userRecordingDuration = Duration.zero.obs;
  Rx<Duration> userAudioDuration = Duration.zero.obs;
  Rx<Duration> userAudioPosition = Duration.zero.obs;

  final AudioPlayer _defaultAudioPlayer = AudioPlayer();
  final AudioPlayer _userAudioPlayer = AudioPlayer();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  Timer? _recordingTimer;
  String? recordedFilePath;

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

    _userAudioPlayer.onDurationChanged.listen((duration) {
      userAudioDuration.value = duration;
    });

    _userAudioPlayer.onPositionChanged.listen((position) {
      userAudioPosition.value = position;
    });

    _userAudioPlayer.onPlayerComplete.listen((event) {
      isUserAudioPlaying.value = false;
      userAudioPosition.value = Duration.zero;
    });
  }

  void resetValuesOnPlayAgain() {
    isDefaultAudioPlaying.value = false;
    isUserAudioPlaying.value = false;
    isUserRecording.value = false;
    isUserRecordingCompleted.value = false;
    isResultCalculating.value = false;
    isResultCalculated.value = false;
    userRecordingDuration.value = Duration.zero;
    userAudioDuration.value = Duration.zero;
    userAudioPosition.value = Duration.zero;

    _stopRecordingTimer();
  }

  Future<void> _initializeRecorder() async {
    try {
      await Permission.microphone.request();
      await _audioRecorder.openRecorder();
      _audioRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('Error initializing recorder: $e');
    }
  }

  @override
  void onClose() {
    _audioRecorder.closeRecorder();
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
              'https://sounds-match-api-production.up.railway.app/uploads/sounds/1719814297666-640226552.mp3'),
        );
        isDefaultAudioPlaying.value = true;
      }
    } catch (e) {
      debugPrint('Error playing default audio: $e');
    }
  }

  ///Toggle User Recorded Audio
  Future<void> toggleUserAudio() async {
    try {
      if (isUserAudioPlaying.value) {
        await _userAudioPlayer.pause();
        isUserAudioPlaying.value = false;
      } else {
        await _userAudioPlayer.stop();
        await _userAudioPlayer.play(DeviceFileSource(recordedFilePath!));
        isUserAudioPlaying.value = true;
      }
    } catch (e) {
      debugPrint('Error playing user audio: $e');
    }
  }

  ///Starts Recording
  Future<void> startRecording() async {
    isUserRecordingCompleted.value = false;
    try {
      final directory = await getApplicationDocumentsDirectory();
      recordedFilePath = '${directory.path}/recording.aac';
      await _audioRecorder.startRecorder(toFile: recordedFilePath);
      isUserRecording.value = true;
      _startRecordingTimer();
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  ///Stops Recording
  Future<void> stopRecording() async {
    try {
      await _audioRecorder.stopRecorder();
      isUserRecording.value = false;
      isUserRecordingCompleted.value = true;
      _stopRecordingTimer();
      debugPrint('RecordedAudioPath: $recordedFilePath');
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  ///Starts Timer for Recording
  void _startRecordingTimer() {
    userRecordingDuration.value = Duration.zero;
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      userRecordingDuration.value += const Duration(seconds: 1);
    });
  }

  ///Stops Timer for Recording
  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
  }

  Future<String> fileToBinaryString(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    return bytes.toString();
  }
}
