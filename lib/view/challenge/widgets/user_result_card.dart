import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/result_model.dart';

class UserResultCard extends StatelessWidget {
  final ResultModel resultModel;
  final int index;
  final bool isQualified;
  final bool isOverAllResult;

  const UserResultCard({
    super.key,
    required this.index,
    required this.resultModel,
    required this.isQualified,
    required this.isOverAllResult,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Stack(
        children: [
          Image.asset(
            MyAssetHelper.rankContainerBackground,
            fit: BoxFit.fill,
            height: context.height * 0.22,
            // width: context.width * 0.8,
          ),
          Positioned.fill(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 35.0, bottom: 20.0, left: 10.0),
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
                        resultModel.usersResult?[index].participant?.profile ??
                            '',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: CustomTextWidget(
                  text: isOverAllResult
                      ? '${resultModel.calculateAverageResult?[index].participant?.firstName} ${resultModel.calculateAverageResult?[index].participant?.lastName} '
                      : '${resultModel.usersResult?[index].participant?.firstName} ${resultModel.usersResult?[index].participant?.lastName} ',
                  fontFamily: "Horta",
                  textColor: MyColorHelper.white,
                  fontSize: 18,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      text: isOverAllResult
                          ? "Avg Result: ${resultModel.usersResult?[index].achievedPercentage}%"
                          : "Result: ${resultModel.calculateAverageResult?[index].averageAchievedPercentage}%",
                      fontFamily: "horta",
                      textColor: MyColorHelper.white,
                      fontSize: 18,
                      maxLines: 2,
                    ),
                    Visibility(
                      visible: !isOverAllResult,
                      child: CustomTextWidget(
                        text: isQualified ? "Qualified" : "Not Qualified",
                        fontFamily: "Horta",
                        textColor: MyColorHelper.white,
                        fontSize: 18,
                      ),
                    ),
                    // CustomTextWidget(
                    //   text: getOrdinalSuffix(index + 1),
                    //   fontFamily: "Horta",
                    //   textColor: MyColorHelper.white,
                    //   fontSize: 30,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// String getOrdinalSuffix(int number) {
//   if (number % 100 >= 11 && number % 100 <= 13) {
//     return '$number' 'th';
//   } else {
//     switch (number % 10) {
//       case 1:
//         return '$number' 'st';
//       case 2:
//         return '$number' 'nd';
//       case 3:
//         return '$number' 'rd';
//       default:
//         return '$number' 'th';
//     }
//   }
// }
