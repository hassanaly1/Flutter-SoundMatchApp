import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

late MyNewChallengeController _myNewChallengeController;

class NotificationsWithoutRequest extends StatefulWidget {
  const NotificationsWithoutRequest({super.key});

  @override
  State<NotificationsWithoutRequest> createState() =>
      _NotificationsWithoutRequestState();
}

class _NotificationsWithoutRequestState
    extends State<NotificationsWithoutRequest> {
  @override
  void initState() {
    _myNewChallengeController = Get.put(MyNewChallengeController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyNewChallengeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: MyColorHelper.white),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: CustomTextWidget(
                text: "Notifications",
                textColor: MyColorHelper.white,
                fontFamily: "Horta",
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.transparent,
            body: ListView.builder(
                itemCount: _myNewChallengeController.notifications.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final notification =
                      _myNewChallengeController.notifications[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(18)),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    60, // Adjust the height and width as needed
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit
                                        .cover, // Adjust the fit as needed
                                    image: NetworkImage(
                                      notification.imagePath!,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextWidget(
                                        text: notification.title!,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        maxLines: 2,
                                        textColor: MyColorHelper.white,
                                        fontFamily: "Poppins",
                                      ),
                                      CustomTextWidget(
                                        text: notification.subtitle!,
                                        fontSize: 13,
                                        maxLines: 3,
                                        textColor: MyColorHelper.white,
                                        fontFamily: "Poppins",
                                      )
                                    ],
                                  )),
                              Expanded(
                                flex: 1,
                                child: CustomTextWidget(
                                  text: notification.time!,
                                  fontSize: 10,
                                  textColor: MyColorHelper.white,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Poppins",
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
