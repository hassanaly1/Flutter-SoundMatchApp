import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/data/auth_service.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/utils/toast.dart';
import 'package:sound_app/utils/validator.dart';
import 'package:sound_app/view/profile/profile_info_section.dart';

class SecuritySection extends StatefulWidget {
  const SecuritySection({super.key});

  @override
  State<SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState extends State<SecuritySection> {
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
                    if (changePasswordKey.currentState!.validate()) {
                      if (newPasswordController.text.trim() ==
                          confirmNewPasswordController.text.trim()) {
                        bool isSuccess = await changePasswordInApp();
                        if (isSuccess) {
                          currentPasswordController.clear();
                          newPasswordController.clear();
                          confirmNewPasswordController.clear();
                        }
                      } else {
                        ToastMessage.showToastMessage(
                            message:
                                'New Password and Confirm New Password does not match',
                            backgroundColor: Colors.red);
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
          ToastMessage.showToastMessage(
            message: 'Password Changed Successfully.',
            backgroundColor: Colors.green,
          );
          return true;
        } else {
          ToastMessage.showToastMessage(
              message: response['message'], backgroundColor: Colors.red);
          return false;
        }
      } catch (e) {
        ToastMessage.showToastMessage(
          message:
              'Something went wrong during Changing Password, please try again.',
          backgroundColor: Colors.red,
        );
        return false;
      } finally {
        isLoading.value = false;
      }
    } else {
      return false;
    }
  }
}
