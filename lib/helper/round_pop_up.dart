

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/custom_pop_up.dart';

class RoundStartPopUp extends StatelessWidget {
  const RoundStartPopUp({
    super.key,
    required MyNewChallengeController myNewChallengeController,
  }) : _myNewChallengeController = myNewChallengeController;

  final MyNewChallengeController _myNewChallengeController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
      child: BackdropFilter(
        filter: !_myNewChallengeController.isRoundStarted.value
            ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Visibility(
          visible: !_myNewChallengeController.isRoundStarted.value,
          child: CustomPopUp(
            myNewChallengeController: _myNewChallengeController,
            lottiePath: MyAssetHelper.roundAnimation,
            text:
            'Round ${_myNewChallengeController.roundValue.value} started',
            opacity: _myNewChallengeController.isRoundStarted.value
                ? 0.0
                : 1.0,
          ),
        ),
      ),
    ));
  }
}
