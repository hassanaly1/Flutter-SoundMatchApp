import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/view/notifications/notification_without_request.dart';
import 'package:sound_app/view/profile/profile.dart';

class AppbarWithIcons extends StatelessWidget {
  const AppbarWithIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.notifications,
            color: Colors.transparent,
          ),
          Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.to(const NotificationsWithoutRequest(),
                        transition: Transition.upToDown);
                  },
                  child: const Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.notifications,
                          color: Colors.white70, size: 30))),
              const SizedBox(width: 10.0),
              InkWell(
                  onTap: () {
                    Get.to(const ProfileScreen(),
                        transition: Transition.upToDown);
                  },
                  child: const Padding(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        CupertinoIcons.profile_circled,
                        color: Colors.white70,
                        size: 30,
                      )))
            ],
          )
        ],
      ),
    );
  }
}
