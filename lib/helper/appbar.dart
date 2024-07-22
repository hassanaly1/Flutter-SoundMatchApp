import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/utils/toast.dart';
import 'package:sound_app/view/auth/login.dart';
import 'package:sound_app/view/notifications/notification_screen.dart';

class CustomAppbar extends StatelessWidget {
  final bool showNotificationsIcon;
  final bool showLogoutIcon;

  const CustomAppbar({
    super.key,
    this.showNotificationsIcon = false,
    this.showLogoutIcon = false,
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
          Row(
            children: [
              showNotificationsIcon
                  ? InkWell(
                      onTap: () {
                        Get.to(() => const NotificationScreen(),
                            transition: Transition.upToDown);
                      },
                      child: const Padding(
                          padding: EdgeInsets.zero,
                          child: Icon(Icons.notifications,
                              color: Colors.white70, size: 30)))
                  : const SizedBox(),
              showLogoutIcon
                  ? IconButton(
                      onPressed: () async {
                        bool isSuccess =
                            await AuthService().logout(MyAppStorage.userId);

                        if (isSuccess) {
                          MyAppStorage().removeUser();
                          Get.offAll(() => const LoginScreen(),
                              transition: Transition.upToDown);
                          ToastMessage.showToastMessage(
                            message: 'Logout Successfully',
                            backgroundColor: Colors.green,
                          );
                        } else {
                          ToastMessage.showToastMessage(
                            message: 'Logout Operation Failed',
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}
