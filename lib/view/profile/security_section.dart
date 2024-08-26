import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/carousel_controller.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/utils/validator.dart';
import 'package:sound_app/view/profile/profile_info_section.dart';

class SecuritySection extends StatefulWidget {
  const SecuritySection({super.key});

  @override
  State<SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState extends State<SecuritySection> {
  final GuestController guestController = Get.find();
  RxBool isLoading = false.obs;
  GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: changePasswordKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                hintText: 'Current Password',
                labelText: "Current Password",
                controller: currentPasswordController,
                validator: (p0) => AppValidator.validateEmptyText(
                  fieldName: 'Current Password',
                  value: p0,
                ),
              ),
              SizedBox(height: context.height * 0.03),
              CustomTextField(
                hintText: 'New Password',
                labelText: 'New Password',
                controller: newPasswordController,
                validator: (p0) => AppValidator.validateEmptyText(
                  fieldName: 'New Password',
                  value: p0,
                ),
              ),
              SizedBox(height: context.height * 0.03),
              CustomTextField(
                hintText: 'Confirm New Password',
                labelText: 'Confirm New Password',
                controller: confirmNewPasswordController,
                validator: (p0) => AppValidator.validateEmptyText(
                  fieldName: 'Confirm New Password',
                  value: p0,
                ),
              ),
              SizedBox(height: context.height * 0.03),
              Obx(
                () => CustomProfileButton(
                  isLoading: isLoading.value,
                  buttonText: 'Save',
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (guestController.isGuestUser.value) {
                      MySnackBarsHelper.showMessage(
                        "To Change the Password,",
                        "Please Create Account",
                        Icons.no_accounts,
                      );
                    } else if (changePasswordKey.currentState!.validate()) {
                      if (newPasswordController.text.trim() ==
                          confirmNewPasswordController.text.trim()) {
                        bool isSuccess = await changePasswordInApp();
                        if (isSuccess) {
                          currentPasswordController.clear();
                          newPasswordController.clear();
                          confirmNewPasswordController.clear();
                        }
                      } else {
                        MySnackBarsHelper.showError(
                            'Please try again.',
                            'New Password and Confirm New Password does not match',
                            Icons.error);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> changePasswordInApp() async {
    if (newPasswordController.text.isNotEmpty &&
        confirmNewPasswordController.text.isNotEmpty) {
      isLoading.value = true;

      try {
        Map<String, dynamic> response = await AuthService().changePasswordInApp(
          currentPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
          confirmNewPassword: confirmNewPasswordController.text,
        );
        if (response['status'] == 'success') {
          MySnackBarsHelper.showMessage('', 'Password Changed Successfully.',
              CupertinoIcons.checkmark_alt_circle);
          return true;
        } else {
          MySnackBarsHelper.showError(
              'Please try again.', response['message'], Icons.error);
          return false;
        }
      } catch (e) {
        MySnackBarsHelper.showError('Please try again.',
            'Something went wrong during Changing Password', Icons.error);
        return false;
      } finally {
        isLoading.value = false;
      }
    } else {
      return false;
    }
  }
}
