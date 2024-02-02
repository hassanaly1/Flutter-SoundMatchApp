import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  final MyNewChallengeController _myNewChallengeController =
      Get.put(MyNewChallengeController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: _myNewChallengeController.notifications.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final notification = _myNewChallengeController.notifications[index];
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
                        height: 60, // Adjust the height and width as needed
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover, // Adjust the fit as needed
                            image: NetworkImage(
                              notification.imagePath!,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
        });
  }
}
