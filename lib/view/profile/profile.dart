import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sound_app/helper/appbar.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/profile/challenges_section.dart';
import 'package:sound_app/view/profile/profile_info_section.dart';
import 'package:sound_app/view/profile/security_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isKeyboard)
                        BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              color: Colors.white.withOpacity(0.3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //appbar
                                  const CustomAppbar(
                                      showNotificationsIcon: true),
                                  //profile icon
                                  Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        CupertinoIcons.person_circle_fill,
                                        color: Colors.white60,
                                        size: height * 0.22,
                                      )),

                                  //name and email
                                  CustomTextWidget(
                                    text: storage
                                            .read('user_info')['first_name'] +
                                        " " +
                                        storage.read('user_info')['last_name'],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    textColor: MyColorHelper.white,
                                    fontFamily: "poppins",
                                  ),
                                  CustomTextWidget(
                                    text: storage.read('user_info')['email'],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    textColor: MyColorHelper.white,
                                    fontFamily: "poppins",
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                      //Tab bars

                      Expanded(
                        child: DefaultTabController(
                          length: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: context.height * 0.01,
                                horizontal: context.width * 0.03),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: height * 0.02),
                                TabBar(
                                  tabAlignment: TabAlignment.center,
                                  indicatorColor: MyColorHelper.primaryColor,
                                  labelColor: MyColorHelper.white,
                                  labelStyle: const TextStyle(
                                    color: MyColorHelper.white,
                                    fontFamily: "Horta",
                                    fontSize: 20,
                                  ),
                                  unselectedLabelColor: MyColorHelper.white,
                                  unselectedLabelStyle: const TextStyle(
                                    color: MyColorHelper.white,
                                    fontFamily: "Horta",
                                    fontSize: 20,
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: const Border(
                                      right: BorderSide.none,
                                      left: BorderSide.none,
                                      bottom: BorderSide(
                                        color: MyColorHelper.white,
                                        width: 5.0,
                                      ),
                                    ),
                                    color: MyColorHelper.tabColor,
                                  ),
                                  onTap: (index) {
                                    // _index.value = index;
                                  },
                                  tabs: const [
                                    Tab(text: 'Personal Info'),
                                    Tab(text: 'Challenges'),
                                    Tab(text: 'Security'),
                                  ],
                                ),
                                const Expanded(
                                  child: TabBarView(
                                    children: [
                                      PersonalInfoSection(),
                                      ChallengesSection(),
                                      SecuritySection(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
