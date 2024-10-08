import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/helper/appbar.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/view/profile/all_challenges_section.dart';
import 'package:sound_app/view/profile/profile_info_section.dart';
import 'package:sound_app/view/profile/security_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final MyUniversalController universalController = Get.find();
  final GuestController guestController = Get.find();

  RxBool circularLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    /// Check weather the keyboard is open or not
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(MyAssetHelper.backgroundImage, fit: BoxFit.cover),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //appbar
                                  CustomAppbar(showLogoutIcon: true),

                                  InkWell(
                                    // onTap: updateUserImage,
                                    onTap: () {
                                      if (guestController.isGuestUser.value) {
                                        MySnackBarsHelper.showMessage(
                                          "To Update the Profile Picture",
                                          "Please Create Account",
                                          Icons.no_accounts,
                                        );
                                      } else {
                                        updateUserImage();
                                      }
                                    },
                                    child: Obx(
                                      () => CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.white,
                                        backgroundImage: guestController
                                                .isGuestUser.value
                                            ? const AssetImage(
                                                'assets/images/guest_user_profile.PNG')
                                            : universalController.userImageURL
                                                    .value.isNotEmpty
                                                ? NetworkImage(
                                                    universalController
                                                        .userImageURL.value)
                                                : const AssetImage(
                                                        'assets/images/placeholder.png')
                                                    as ImageProvider,
                                      ),
                                    ),
                                  ),
                                  if (circularLoading.value)
                                    const CircularProgressIndicator(
                                      color: MyColorHelper.primaryColor,
                                      strokeWidth: 2.0,
                                    ),
                                  const SizedBox(height: 12.0),
                                  Obx(
                                    () => CustomTextWidget(
                                      text:
                                          '${universalController.firstName.value} ${universalController.lastName.value}',
                                      // text: (universalController
                                      //             .userInfo['first_name'] ??
                                      //         'Guest') +
                                      //     ' ' +
                                      //     (universalController
                                      //             .userInfo['last_name'] ??
                                      //         'User'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      textColor: MyColorHelper.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  CustomTextWidget(
                                    text:
                                        universalController.userInfo['email'] ??
                                            'guest.user@soundmatch.com',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    textColor: MyColorHelper.white,
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  tabAlignment: TabAlignment.center,
                                  isScrollable: true,
                                  indicatorColor: MyColorHelper.primaryColor,
                                  labelColor: MyColorHelper.white,
                                  labelStyle: const TextStyle(
                                    color: MyColorHelper.white,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                  unselectedLabelColor: MyColorHelper.white,
                                  unselectedLabelStyle: const TextStyle(
                                    color: MyColorHelper.white,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
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
                                  tabs: const [
                                    Tab(text: 'Personal Info'),
                                    Tab(text: 'All Challenges'),
                                    Tab(text: 'Security'),
                                  ],
                                ),
                                const Expanded(
                                  child: TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      PersonalInfoSection(),
                                      AllChallengesSection(),
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

  Future<void> updateUserImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      circularLoading.value = true;
      if (image != null) {
        universalController.userImage = image;
        universalController.userImageURL.value = image.path;
        universalController.userImageInBytes =
            (await universalController.userImage?.readAsBytes())!;
        UpdateUserImageResult result = await AuthService().updateUserImage(
          userImageInBytes: universalController.userImageInBytes!,
        );

        if (result.isSuccess) {
          if (result.profileUrl != null && result.profileUrl!.isNotEmpty) {
            debugPrint('AfterUpdateProfileLink: ${result.profileUrl}');
            universalController.setUserImageUrl = result.profileUrl ?? '';
            debugPrint(
                'AfterUpdate: ${universalController.userImageURL.value}');
            MySnackBarsHelper.showMessage(
                '',
                'Profile Image Updated Successfully',
                CupertinoIcons.checkmark_alt_circle);
          } else {
            MySnackBarsHelper.showError(
                'Please try again.', 'Something went wrong.', Icons.error);
          }
        } else {
          MySnackBarsHelper.showError(
              'Please try again.', 'Something went wrong.', Icons.error);
        }
        circularLoading.value = false;
        setState(() {});
      } else {
        debugPrint('No image selected');
        MySnackBarsHelper.showError(
            'Please try again.', 'No image selected.', Icons.error);
        circularLoading.value = false;
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      MySnackBarsHelper.showError('Please try again.',
          'Something went wrong during Updating Profile Image', Icons.error);
    }
  }
}
