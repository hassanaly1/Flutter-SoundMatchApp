import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class RequestTab extends StatelessWidget {
  const RequestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(MyAssetHelper.requestBackground),
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextWidget(
                    text: 'gameName!',
                    fontFamily: "Horta",
                    isShadow: true,
                    textColor: MyColorHelper.white,
                    fontSize: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(radius: 20),
                          SizedBox(width: context.width * 0.02),
                          CustomTextWidget(
                              text: 'participantName!',
                              fontFamily: "Poppins",
                              textColor: MyColorHelper.white,
                              maxLines: 2,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)
                        ],
                      ),
                      SizedBox(width: context.width * 0.03),
                      const Icon(Icons.check_circle, color: Colors.green),
                      const Icon(Icons.cancel, color: Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
