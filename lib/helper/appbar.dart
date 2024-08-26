import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/view/auth/login.dart';

class CustomAppbar extends StatelessWidget {
  final bool showLogoutIcon;

  CustomAppbar({
    super.key,
    this.showLogoutIcon = false,
  });

  final GuestController guestController = Get.find();

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
              size: 30,
            ),
          ),
          Row(
            children: [
              showLogoutIcon
                  ? IconButton(
                      onPressed: () async {
                        bool isSuccess;
                        if (guestController.isGuestUser.value) {
                          isSuccess = true;
                        } else {
                          isSuccess = await AuthService().logout(
                            MyAppStorage.storage.read('user_info')['_id'] ?? '',
                          );
                        }
                        // bool isSuccess = await AuthService().logout(
                        //     MyAppStorage.storage.read('user_info')['_id'] ??
                        //         '');

                        if (isSuccess) {
                          // MyAppStorage.instance.removeUser();
                          MyAppStorage.storage.remove('token');
                          MyAppStorage.storage.remove('user_info');
                          Get.offAll(() => const LoginScreen(),
                              transition: Transition.upToDown);
                          MySnackBarsHelper.showMessage(
                              'Logout Successfully',
                              'Please Login Again',
                              CupertinoIcons.checkmark_alt_circle);
                          print(
                              'After Logout: ${MyAppStorage.storage.read('token')}');
                          print(
                              'After Logout: ${MyAppStorage.storage.read('user_info')}');
                        } else {
                          MySnackBarsHelper.showError(
                              'Please try again.',
                              'Something went wrong during Logout Operation',
                              Icons.error);
                        }
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 30,
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
