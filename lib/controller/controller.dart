import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/challenge_model.dart';
import 'package:sound_app/models/challenge_requestModel.dart';
import 'package:sound_app/models/member_model.dart';
import 'package:sound_app/models/notification_model.dart';
import 'package:sound_app/models/profile.dart';
import 'package:sound_app/models/rank_screen_model.dart';
import 'package:sound_app/view/dashboard/result_screen.dart';
import 'package:sound_app/view/dashboard/result_screen_2.dart';

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


  final List<RankScreenModel> _ranks = List.generate(
      7,
          (index) =>
          RankScreenModel(
              name: "User $index",
              profilePath: MyAssetHelper.getDummyImage(),
              accuracy: 70 + index));

  final List<NotificationModel> _notifications = List.generate(
      7,
          (index) =>
          NotificationModel(
            title: "New Challenge ${index + 1}",
            time: "now",
            subtitle:
            "Leader ${index + 1} has sent you invitation to join his game",
            imagePath: MyAssetHelper.getDummyImage(),
          ));

  final List<ChallengeRequestModel> _challengeRequestList = List.generate(
      15,
          (index) =>
          ChallengeRequestModel(
            leaderName: "Leader ${index + 1}",
            participantName: "User ${index + 1}",
            gameName: "Game Name ${index + 1}",
            gameDescription:
            "Leader ${index + 1} has sent you invitation to join his game",
            imagePath: MyAssetHelper.getDummyImage(),
          ));

  final List<MyProfile> _members = List.generate(
      10,
          (index) =>
          MyProfile(
            name: "User ${index + 1}",
            profilePath: MyAssetHelper.getDummyImage(),
          ));


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





  List<ChallengeRequestModel> get challengeRequestList => _challengeRequestList;

  List<RankScreenModel> get rank => _ranks;

  List<NotificationModel> get notifications => _notifications;

  List<MyProfile> get members => _members;



  void loaderClicked(int value) {
    pressedIndex.value = value;
  }

  void micPressed(bool value) {
    isMicPressed.value = value;
  }




  RxBool isAudioFileVisible = false.obs;

  void audioFileVisible() {
    isAudioFileVisible.value = true;
  }

  void audioFileInvisible() {
    isAudioFileVisible.value = false;
  }



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

  RxBool firstBorder = false.obs;

  void showFirstBorderMethod(bool value) {
    firstBorder.value = value;
  }

  RxBool secondBorder = false.obs;

  void showSecondBorderMethod(bool value) {
    secondBorder.value = value;
  }




  RxInt currentIndex = 0.obs;
  RxBool micPressedForIncreaseIndex = false.obs;
  RxInt currentIndex1 = 0.obs;
  RxInt currentIndex2 = 0.obs;


  void toggleMicPressedForIncreaseIndex(bool value) {
    micPressedForIncreaseIndex.value = value;
  }


  void makeIndexZero() {
    currentIndex.value = 0;
    currentIndex1.value = 0;
    currentIndex2.value = 0;
  }






  RxBool loaderWaiting = false.obs;

  void loaderWaitingMethod(bool value) {
    loaderWaiting.value = value;
  }

  RxBool loaderRoundEntered = false.obs;

  void loaderRoundEnteredMethod(bool value) {
    loaderRoundEntered.value = value;
  }

  RxBool thirdBorder = false.obs;

  void showThirdBorderMethod(bool value) {
    thirdBorder.value = value;
  }

  void increaseIndexBottomProfile() {
    currentIndex2.value++;
  }


  RxInt t=0.obs;
  RxInt indexAll=0.obs;
  void makeIndexAllZero(){
    indexAll.value=0;
  }


  RxInt maxTime=30.obs;

  void timerStart1(int participantsLength,List<Member>  leftProfiles,List<Member> rightProfiles,
      List<Member> bottomProfiles,CountDownController controller,
      ChallengeModel challengeModel,
      ScrollController scrollController,
      BuildContext context
      ) {
    controller.start();
    showFirstBorderMethod(true);
    showSecondBorderMethod(true);
    MySnackBarsHelper.showMessage(
        "Record your voice by long pressing on mic",
        "Now your turn ${leftProfiles[indexAll.value].name}",
        CupertinoIcons.mic);

    Timer.periodic(Duration(seconds: 1), (Timer timer) {

      if(indexAll.value<participantsLength){


        if (t.value < maxTime.value) {
          t.value++;
          // print("-----------------------> t= "+t.value.toString());
          // print("-----------------------> index= "+indexAll.value.toString());
        } else {
          t.value = 0;
          controller.start();
          indexAll.value++;

          if(indexAll.value>0 && indexAll<=2){
            MySnackBarsHelper.showMessage(
                "Record your voice by long pressing on mic",
                "Now your turn ${leftProfiles[indexAll.value].name}",
                CupertinoIcons.mic);

          }
          if(indexAll.value>2&& indexAll.value<6){
            MySnackBarsHelper.showMessage(
                "Record your voice by long pressing on mic",
                "Now your turn ${rightProfiles[indexAll.value-3].name}",
                CupertinoIcons.mic);

          }
          if(indexAll.value>5&&indexAll.value<participantsLength){
            if (indexAll.value > 8) {
              double offset = (scrollController.position.pixels + 80) +
                  (MediaQuery.of(context).size.width * 0.08);
              scrollController.animateTo(offset,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            }
            MySnackBarsHelper.showMessage(
                "Record your voice by long pressing on mic",
                "Now your turn ${bottomProfiles[indexAll.value-6].name}",
                CupertinoIcons.mic);

          }



        }



      }else{
        timer.cancel();
        toggleThink(true);
        Future.delayed(const Duration(seconds: 5), () {
          toggleThink(false);
          showFirstBorderMethod(false);

          showSecondBorderMethod(false);
          showThirdBorderMethod(false);

          Get.off(
              ResultScreen2(challengeModel: challengeModel));
          startGame(false);
        });
      }

    });
  }


void nextTimer(CountDownController controller,List<Member>  leftProfiles,List<Member> rightProfiles,
    List<Member> bottomProfiles,int participantsLength,  ScrollController scrollController,   BuildContext context){
  t.value=0;

    controller.start();


  indexAll++;
  if(indexAll.value>0 && indexAll<=2){
    MySnackBarsHelper.showMessage(
        "Record your voice by long pressing on mic",
        "Now your turn ${leftProfiles[indexAll.value].name}",
        CupertinoIcons.mic);

  }
  if(indexAll.value>2&& indexAll.value<6){
    MySnackBarsHelper.showMessage(
        "Record your voice by long pressing on mic",
        "Now your turn ${rightProfiles[indexAll.value-3].name}",
        CupertinoIcons.mic);

  }
  if(indexAll.value>5&&indexAll.value<participantsLength){
    MySnackBarsHelper.showMessage(
        "Record your voice by long pressing on mic",
        "Now your turn ${bottomProfiles[indexAll.value-6].name}",
        CupertinoIcons.mic);
    if (indexAll.value > 8) {
      double offset = (scrollController.position.pixels + 80) +
          (MediaQuery.of(context).size.width * 0.07);
      scrollController.animateTo(offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);
    }

  }


}











}