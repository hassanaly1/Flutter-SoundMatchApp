import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_app/data/default_challenge_service.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/sound_model.dart';

class DefaultMatchController extends GetxController {
  RxBool isDefaultAudioPlaying = false.obs;
  RxBool isUserAudioPlaying = false.obs;
  RxBool isUserRecording = false.obs;
  RxBool isUserRecordingCompleted = false.obs;
  RxBool isResultCalculating = false.obs;
  RxBool isResultCalculated = false.obs;
  RxList freeMatchSounds = <SoundModel>[].obs;
  Rx<SoundModel?> selectedSound = Rx<SoundModel?>(null);

  Rx<Duration> defaultAudioDuration = Duration.zero.obs;
  Rx<Duration> defaultAudioPosition = Duration.zero.obs;

  Rx<Duration> userRecordingDuration = Duration.zero.obs;
  Rx<Duration> userAudioDuration = Duration.zero.obs;
  Rx<Duration> userAudioPosition = Duration.zero.obs;

  final AudioPlayer _defaultAudioPlayer = AudioPlayer(); //AudioPlayer
  final AudioPlayer _userAudioPlayer = AudioPlayer(); //AudioPlayer
  final FlutterSoundRecorder _audioRecorder =
      FlutterSoundRecorder(); // AudioRecorder
  Timer? _recordingTimer;
  String? recordedFilePath;

  // Add a variable to store the match percentage
  RxInt matchPercentage = 0.obs;

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
    // fetchSoundsForDefaultMatch();
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
      debugPrint('Error Initializing Recorder: $e');
    }
  }

  @override
  void onClose() {
    debugPrint('DefaultMatchControllerOnClosedCalled');
    _audioRecorder.closeRecorder();
    _audioRecorder.stopRecorder();
    _defaultAudioPlayer.stop();
    _defaultAudioPlayer.dispose();
    _userAudioPlayer.stop();
    _userAudioPlayer.dispose();
    _recordingTimer?.cancel();

    super.onClose();
  }

  ///Fetch Sounds For DefaultMatch
  void fetchSoundsForDefaultMatch() async {
    try {
      List<SoundModel> sounds = await DefaultChallengeService().fetchSounds();
      if (sounds.isNotEmpty) {
        freeMatchSounds.assignAll(sounds);
        selectedSound.value = freeMatchSounds[0];
        debugPrint('Free Match Sounds: ${freeMatchSounds.length}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
            // UrlSource(
            //   'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3',
            // ),
            UrlSource(selectedSound.value?.url ?? ''));
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

  // ///Starts Recording
  // Future<void> startRecording() async {
  //   isUserRecordingCompleted.value = false;
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     recordedFilePath = '${directory.path}/recording.aac';
  //     await _audioRecorder.startRecorder(toFile: recordedFilePath);
  //     isUserRecording.value = true;
  //     _startRecordingTimer();
  //   } catch (e) {
  //     debugPrint('Error Starting Recording: $e');
  //   }
  // }

  // Future<void> startRecording() async {
  //   // Check for microphone permission
  //   var status = await Permission.microphone.status;
  //   if (status.isDenied) {
  //     // Request permission if not granted
  //     status = await Permission.microphone.request();
  //   }
  //
  //   if (status.isGranted) {
  //     // If permission is granted, start recording
  //     isUserRecordingCompleted.value = false;
  //     try {
  //       final directory = await getApplicationDocumentsDirectory();
  //       recordedFilePath = '${directory.path}/recording.aac';
  //       await _audioRecorder.startRecorder(toFile: recordedFilePath);
  //       isUserRecording.value = true;
  //       _startRecordingTimer();
  //     } catch (e) {
  //       debugPrint('Error Starting Recording: $e');
  //     }
  //   } else if (status.isPermanentlyDenied) {
  //     // If permission is permanently denied, open app settings
  //     debugPrint(
  //         'Microphone permission permanently denied. Opening app settings...');
  //     await openAppSettings();
  //   } else {
  //     // Handle other cases (like restricted, limited, etc.)
  //     debugPrint('Microphone permission denied');
  //     await openAppSettings();
  //   }
  // }

  Future<void> startRecording(BuildContext context) async {
    isUserRecordingCompleted.value = false;

    // Check for microphone permission
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isLimited || status.isRestricted) {
      // Show permission dialog first
      _showPermissionDialog(context, onDialogDismiss: () async {
        // Request permission after dialog is dismissed
        status = await Permission.microphone.request();
        _handlePermissionStatus(context, status);
      });
    } else {
      // Handle the current permission status
      _handlePermissionStatus(context, status);
    }
  }

  void _handlePermissionStatus(BuildContext context, PermissionStatus status) {
    if (status.isGranted) {
      // If permission is granted, start recording
      _startRecording(context);
    } else if (status.isPermanentlyDenied) {
      // If permission is permanently denied, open app settings
      debugPrint(
          'Microphone permission permanently denied. Opening app settings...');
      openAppSettings();
    } else {
      // Handle other cases (like restricted, limited, etc.)
      debugPrint('Microphone permission denied');
    }
  }

  Future<void> _startRecording(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      recordedFilePath = '${directory.path}/recording.aac';
      await _audioRecorder.startRecorder(toFile: recordedFilePath);
      isUserRecording.value = true;
      _startRecordingTimer();
    } catch (e) {
      debugPrint('Error Starting Recording: $e');
    }
  }

  void _showPermissionDialog(BuildContext context,
      {required VoidCallback onDialogDismiss}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomTextWidget(
            text: 'Microphone Permission Needed',
            textColor: Colors.black87,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          content: const CustomTextWidget(
            text: 'This app needs access to your microphone to record audio.',
            textColor: Colors.black87,
          ),
          actions: <Widget>[
            TextButton(
              child: const CustomTextWidget(
                text: 'OK',
                textColor: Colors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onDialogDismiss();
              },
            ),
          ],
        );
      },
    );
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
      debugPrint('Error Stopping Recording: $e');
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
}
