import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/utils/toast.dart';
import 'package:sound_app/view/auth/login.dart';

class CustomAppbar extends StatelessWidget {
  final bool showLogoutIcon;

  const CustomAppbar({
    super.key,
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
              showLogoutIcon
                  ? IconButton(
                      onPressed: () async {
                        bool isSuccess = await AuthService().logout(
                            MyAppStorage.storage.read('user_info')['_id'] ??
                                '');

                        if (isSuccess) {
                          // MyAppStorage.instance.removeUser();
                          MyAppStorage.storage.remove('token');
                          MyAppStorage.storage.remove('user_info');
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
