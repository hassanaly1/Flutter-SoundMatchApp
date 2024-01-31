import 'package:flutter/material.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class ChallengesSection extends StatefulWidget {
  const ChallengesSection({super.key});

  @override
  State<ChallengesSection> createState() => _ChallengesSectionState();
}

class _ChallengesSectionState extends State<ChallengesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CustomTextWidget(
            text: "You have not created any challenge",
            textColor: MyColorHelper.white,
            fontFamily: 'poppins',
            maxLines: 2,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
