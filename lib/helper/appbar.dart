import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/view/notifications/notification_screen.dart';

class CustomAppbar extends StatelessWidget {
  final bool showNotificationsIcon;

  const CustomAppbar({
    super.key,
    required this.showNotificationsIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
          ),
          InkWell(
              onTap: () {
                showNotificationsIcon
                    ? Get.to(const NotificationScreen(),
                        transition: Transition.upToDown)
                    : null;
              },
              child: Padding(
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.notifications,
                      color: showNotificationsIcon
                          ? Colors.white70
                          : Colors.transparent,
                      size: 30)))
        ],
      ),
    );
  }
}
