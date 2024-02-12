import 'package:flutter/material.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/container_decoration.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class CustomHistoryContainer extends StatelessWidget {
  final String title;
  final String subtilte;

  final Color containerColor;

  const CustomHistoryContainer(
      {super.key,
      required this.containerColor,
      required this.title,
      required this.subtilte});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: MyDecorationHelper.customBoxDecoration(color: containerColor),
      height: height * 0.22,
      width: width * 0.15,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: MyColorHelper.white, shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(MyAssetHelper.historyRank1),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          CustomTextWidget(
            text: title,
            fontSize: 17,
          ),
          CustomTextWidget(
            text: subtilte,
            fontSize: 14,
          )
        ],
      ),
    );
  }
}
