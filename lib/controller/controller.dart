import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/models/challenge_requestModel.dart';
import 'package:sound_app/models/notification_model.dart';
import 'package:sound_app/models/profile.dart';
import 'package:sound_app/models/rank_screen_model.dart';

import '../helper/custom_text_widget.dart';

class MyNewChallengeController extends GetxController {
  final _switchValue = false.obs;
  final _passwordIconTap = false.obs;
  final _confirmPasswordIconTap = false.obs;
  final _checkBoxValue = false.obs;

  bool get switchValue => _switchValue.value;
  bool get passwordIconTap => _passwordIconTap.value;
  bool get confirmPasswordIconTap => _confirmPasswordIconTap.value;
  bool get checkBoxValue => _checkBoxValue.value;

  set setSwitchValue(value) => _switchValue.value = value;
  set setCheckBoxValue(value) => _checkBoxValue.value = value;

  void toggleIconButton() {
    _passwordIconTap.value = !_passwordIconTap.value;
  }

  void toggleConfirmIconButton() {
    _confirmPasswordIconTap.value = !_confirmPasswordIconTap.value;
  }

  final List<MyProfile> _profileInitial = <MyProfile>[].obs;
  final List<MyProfile> _profilesLeft = <MyProfile>[].obs;
  final List<MyProfile> _profilesRight = <MyProfile>[].obs;
  final List<MyProfile> _profilesBottom = <MyProfile>[].obs;
  final List<int> _popUpShowList = <int>[].obs;

  final List<RankScreenModel> _ranks = List.generate(
      7,
      (index) => RankScreenModel(
          name: "User $index",
          profilePath: MyAssetHelper.getDummyImage(),
          accuracy: 70 + index));

  final List<NotificationModel> _notifications = List.generate(
      7,
      (index) => NotificationModel(
            title: "New Challenge ${index + 1}",
            time: "now",
            subtitle:
                "Leader ${index + 1} has sent you invitation to join his game",
            imagePath: MyAssetHelper.getDummyImage(),
          ));

  final List<ChallengeRequestModel> _challengeRequestList = List.generate(
      15,
      (index) => ChallengeRequestModel(
            leaderName: "Leader ${index + 1}",
            participantName: "User ${index + 1}",
            gameName: "Game Name ${index + 1}",
            gameDescription:
                "Leader ${index + 1} has sent you invitation to join his game",
            imagePath: MyAssetHelper.getDummyImage(),
          ));

  final List<MyProfile> _members = List.generate(
      10,
      (index) => MyProfile(
            name: "User ${index + 1}",
            profilePath: MyAssetHelper.getDummyImage(),
          ));

  void addContainer(MyProfile myProfile) {
    if (_profileInitial.length < 6) {
      _profileInitial.add(myProfile);
      if (_profilesLeft.length <= _profilesRight.length) {
        _profilesLeft.add(myProfile);
      } else {
        _profilesRight.add(myProfile);
      }
    } else {
      _profilesBottom.add(myProfile);
    }
  }

  void removeChallengeRequest(int index) {
    if (index >= 0 && index < _challengeRequestList.length) {
      _challengeRequestList.removeAt(index);
      update();
    }
  }

  RxInt pressedIndex = 0.obs;

  RxInt tabIndex = 0.obs;
  void setIndex(int index) {
    tabIndex.value = index;
  }

  RxBool isMicPressed = false.obs;

  List<MyProfile> get profileInitial => _profileInitial;
  List<MyProfile> get profilesLeft => _profilesLeft;
  List<MyProfile> get profilesRight => _profilesRight;
  List<MyProfile> get profilesBottom => _profilesBottom;
  List<ChallengeRequestModel> get challengeRequestList => _challengeRequestList;

  List<RankScreenModel> get rank => _ranks;
  List<NotificationModel> get notifications => _notifications;
  List<MyProfile> get members => _members;
  List<int> get popUpShowList => _popUpShowList;

  void addPopUpIndex(int index) {
    _popUpShowList.add(index);
  }

  void loaderClicked(int value) {
    pressedIndex.value = value;
  }

  void micPressed() {
    isMicPressed.value = true;
  }

  void stopMicAnimation() {
    isMicPressed.value = false;
  }

  RxString pickedFile = ''.obs;
  Future<void> pickAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        pickedFile.value = file.path!;
        debugPrint('File path------------------->: ${file.path}');
      } else {
        debugPrint('User canceled the picker');
      }
    } catch (e) {
      debugPrint('Error picking audio: $e');
    }
  }

  RxBool isAudioFileVisible = false.obs;

  void audioFileVisible() {
    isAudioFileVisible.value = true;
  }

  void audioFileInvisible() {
    isAudioFileVisible.value = false;
  }

  // RxInt visibleDriversCount = 0.obs;
  //
  // void visibleDriversCounter(){
  //   visibleDriversCount.value++;
  // }

  RxBool isUserPlaying = false.obs;
  RxBool isLeaderPlaying = false.obs;

  void userTogglePlayer(bool value) {
    isUserPlaying.value = value;
  }

  void leaderTogglePlayer(bool value) {
    isLeaderPlaying.value = value;
  }

  RxBool think = false.obs;

  void toggleThink(bool value) {
    think.value = value;
  }

  void showLottiePopup(BuildContext context, String message, lottiePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Done'),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  lottiePath, // Replace with your Lottie animation file path
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: Get.height * 0.002,
              ),
              CustomTextWidget(
                text: message,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ],
          ),
        );
      },
    );
  }

  RxBool isGameStarted = false.obs;

  void startGame(bool value) {
    isGameStarted.value = value;
  }

  RxBool visibleCountDown = false.obs;

  void toggleVisibleCountdown(bool value) {
    visibleCountDown.value = value;
  }

  RxInt roundValue = 1.obs;
  RxBool gameCompleted = false.obs;

  void increaseRound(int roundsCount) {
    if (roundValue.value < roundsCount) {
      roundValue.value++;
    } else {
      gameCompleted.value = true;
    }
  }

  void roundValueOne() {
    roundValue.value = 1;
  }

  RxBool isRoundStarted = false.obs;

  void startRound(bool value) {
    isRoundStarted.value = value;
  }

  RxBool nextButtonPressed = false.obs;

  void nextButton(bool value) {
    nextButtonPressed.value = value;
  
  
  }
RxBool firstBorder=false.obs;

  void showFirstBorderMethod(bool value){
    firstBorder.value=value;

  }
  RxBool secondBorder=false.obs;

  void showSecondBorderMethod(bool value){
    secondBorder.value=value;

  }
    RxBool lastBorder=false.obs;

  void closeLastBorderMethod (bool value){
    lastBorder.value=value;

  }
}
