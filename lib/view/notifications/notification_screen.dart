import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/view/notifications/notifications_tab.dart';
import 'package:sound_app/view/notifications/request_tab.dart';

class NotificationScreen extends StatefulWidget {
  // final ChallengeModel challengeModel;

  const NotificationScreen({
    super.key,
    //required this.challengeModel,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyNewChallengeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              body: Column(
                children: [
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: MyColorHelper.white,
                                  size: 25,
                                )),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            TabBar(
                              isScrollable: false,
                              indicatorColor: MyColorHelper.primaryColor,
                              labelColor: MyColorHelper.white,
                              labelStyle: const TextStyle(
                                color: MyColorHelper.white,
                                fontFamily: "Horta",
                                fontSize: 20,
                              ),
                              unselectedLabelColor:
                                  MyColorHelper.white.withOpacity(0.7),
                              unselectedLabelStyle: TextStyle(
                                color: MyColorHelper.white.withOpacity(0.1),
                                fontFamily: "Horta",
                                fontSize: 22,
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
                                Tab(text: 'Notifications'),
                                Tab(text: 'Request'),
                              ],
                            ),
                            const Expanded(
                              child: TabBarView(
                                children: [
                                  NotificationsTab(),
                                  RequestTab(
                                      //  challengeModel: widget.challengeModel,
                                      ),
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
            ),
          )
        ],
      ),
    );
  }
}
