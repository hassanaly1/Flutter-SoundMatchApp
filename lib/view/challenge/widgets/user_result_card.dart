import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/participant_model.dart';

class UserResultCard extends StatelessWidget {
  final Participant participant;
  final int index;
  const UserResultCard({
    super.key,
    required this.index,
    required this.participant,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Stack(
        children: [
          // Background image
          Image.asset(
            MyAssetHelper.rankContainerBackground,
            fit: BoxFit.fill,
            height: context.height * 0.2,
            width: context.width * 0.6,
          ),
          // Positioned widget to center the Row
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: ListTile(
                    isThreeLine: true,
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            participant.imageUrl ?? '',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: CustomTextWidget(
                      text: participant.name ?? '',
                      fontFamily: "Horta",
                      textColor: MyColorHelper.white,
                      fontSize: 18,
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: "Avg Score: 50%",
                          fontFamily: "horta",
                          textColor: MyColorHelper.white,
                          fontSize: 18,
                        ),
                        // CustomTextWidget(
                        //   text: getOrdinalSuffix(index + 1),
                        //   fontFamily: "Horta",
                        //   textColor: MyColorHelper.white,
                        //   fontSize: 30,
                        // ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

String getOrdinalSuffix(int number) {
  if (number % 100 >= 11 && number % 100 <= 13) {
    return '$number' 'th';
  } else {
    switch (number % 10) {
      case 1:
        return '$number' 'st';
      case 2:
        return '$number' 'nd';
      case 3:
        return '$number' 'rd';
      default:
        return '$number' 'th';
    }
  }
}
