import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/utils/storage_helper.dart';
import 'package:sound_app/utils/toast.dart';
import 'package:sound_app/utils/validator.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  final MyUniversalController universalController = Get.find();
  final GuestController guestController = Get.find();
  RxBool isLoading = false.obs;
  GlobalKey<FormState> updateProfileKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Form(
            key: updateProfileKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => CustomTextField(
                    hintText: firstNameController.text =
                        universalController.userInfo['first_name'] ?? 'Guest',
                    labelText: "First Name",
                    controller: firstNameController,
                    onTap: () => firstNameController.text =
                        universalController.userInfo['first_name'] ?? '',
                    validator: (p0) => AppValidator.validateEmptyText(
                      fieldName: 'First Name',
                      value: p0,
                    ),
                  ),
                ),
                SizedBox(height: context.height * 0.03),
                Obx(
                  () => CustomTextField(
                    hintText: lastNameController.text =
                        universalController.userInfo['last_name'] ?? 'User',
                    labelText: "Last Name",
                    controller: lastNameController,
                    onTap: () => lastNameController.text =
                        universalController.userInfo['last_name'] ?? '',
                    validator: (p0) => AppValidator.validateEmptyText(
                      fieldName: 'Last Name',
                      value: p0,
                    ),
                  ),
                ),
                SizedBox(height: context.height * 0.03),
                CustomTextField(
                  hintText: universalController.userInfo['email'] ??
                      'guest.user@soundmatch.com',
                  labelText: "Email",
                  readOnly: true,
                ),
                SizedBox(height: context.height * 0.03),
                Obx(
                  () => CustomProfileButton(
                    isLoading: isLoading.value,
                    buttonText: 'Update',
                    onTap: () {
                      if (updateProfileKey.currentState!.validate()) {
                        if (guestController.isGuestUser.value) {
                          MySnackBarsHelper.showMessage(
                            "To Update the Profile,",
                            "Please Create Account",
                            Icons.no_accounts,
                          );
                        } else {
                          updateProfileInfo();
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      }
                      // if (GuestController().isGuestUser.value) {
                      //   ToastMessage.showToastMessage(
                      //       message: 'Please login to update profile',
                      //       backgroundColor: Colors.red);
                      //   return;
                      // } else {
                      //   if (firstNameController.text.isEmpty &&
                      //       lastNameController.text.isEmpty) {
                      //     ToastMessage.showToastMessage(
                      //         message: 'All fields are required',
                      //         backgroundColor: Colors.red);
                      //     return;
                      //   }
                      // }
                      // FocusManager.instance.primaryFocus?.unfocus();
                      // updateProfileInfo();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProfileInfo() async {
    try {
      isLoading.value = true;
      bool success = await AuthService().updateProfileInfo(
          firstName: firstNameController.text.trim().isEmpty
              ? universalController.userInfo['first_name']
              : firstNameController.text.trim(),
          lastName: lastNameController.text.trim().isEmpty
              ? universalController.userInfo['last_name']
              : lastNameController.text.trim(),
          token: MyAppStorage.storage.read('token'));
      isLoading.value = false;

      if (success) {
        setState(() {});
        ToastMessage.showToastMessage(
            message: 'Profile updated successfully',
            backgroundColor: Colors.green);
        // Profile update successful
      } else {
        // Profile update failed
        ToastMessage.showToastMessage(
            message: 'Something went wrong, try again',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      ToastMessage.showToastMessage(
          message: 'Something went wrong, try again',
          backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }
}

class CustomProfileButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool isLoading;

  const CustomProfileButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
        decoration: BoxDecoration(
            color: MyColorHelper.blue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColorHelper.verdigris)),
        child: Center(
          child: isLoading
              ? const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20.0,
                )
              : CustomTextWidget(
                  text: buttonText,
                  textColor: MyColorHelper.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'poppins',
                ),
        ),
      ),
    );
  }
}
