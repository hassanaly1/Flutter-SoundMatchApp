import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

import '../models/member_model.dart';

class ProfileListView extends StatelessWidget {
  final MyNewChallengeController myNewChallengeController;
  final int currentIndex;
  final bool showBorder;
  final double height;
  final List<Member> profiles;

  const ProfileListView({
    super.key,
    required this.currentIndex,
    required this.height,
    required this.profiles,
     required this.showBorder,
    required this.myNewChallengeController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              children: [

                 Container(
                    decoration: BoxDecoration(
                      border:

                     showBorder?   currentIndex == index
                              ? Border.all(
                                  color: MyColorHelper.lightBlue,
                                  width: 2.0) // Add border styling
                              : null:null,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          MyAssetHelper.userBackground,
                        ),
                      ),
                    ),
                    child:Obx(()
                      => profiles[index].imageUrl != null
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: myNewChallengeController.loaderWaiting.value==false? CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  profiles[index].imageUrl!,
                                ),
                              ):CircularProgressIndicator(color: MyColorHelper.primaryColor,),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(MyAssetHelper.personPlaceholder),
                            ),
                    ),
                  ),

                CustomTextWidget(
                  text: profiles[index].name!,
                  shadow: const [],
                  fontFamily: "Horta",
                  textColor: MyColorHelper.primaryColor,
                  fontSize: 17,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
