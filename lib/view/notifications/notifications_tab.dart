import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return const CustomNotificationCard();
        });
  }
}

class CustomNotificationCard extends StatelessWidget {
  const CustomNotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                ),
                SizedBox(width: context.width * 0.02),
                const Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: 'notification.title!',
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          maxLines: 2,
                          textColor: MyColorHelper.white,
                        ),
                        CustomTextWidget(
                          text: 'notification.subtitle!',
                          fontSize: 13,
                          maxLines: 3,
                          textColor: MyColorHelper.white,
                        )
                      ],
                    )),
                const Expanded(
                  flex: 1,
                  child: CustomTextWidget(
                    text: 'notification.time!',
                    fontSize: 10,
                    textColor: MyColorHelper.white,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
