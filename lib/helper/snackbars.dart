import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

import 'colors.dart';

class MySnackBarsHelper {
  static void showRequired(String value, String required) =>
      Get.snackbar(required, value,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          isDismissible: true,
          titleText: CustomTextWidget(
            text: value,
            fontSize: 16.0,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w500,
            textColor: Colors.white,
          ),
          backgroundColor: MyColorHelper.caribbeanCurrent.withOpacity(0.80));

  static void showError(String value, String error, IconData icon) =>
      Get.snackbar(error, value,
          icon: Icon(icon),
          titleText: CustomTextWidget(
            text: error,
            fontSize: 16.0,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w600,
            textColor: Colors.white,
          ),
          duration: const Duration(seconds: 1),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.80));

  static void showMessage(String value, String title, IconData icon) =>
      Get.snackbar(title, value,
          icon: Icon(icon),
          duration: const Duration(seconds: 1),
          colorText: Colors.black,
          margin: const EdgeInsets.all(10),
          titleText: CustomTextWidget(
            text: title,
            fontSize: 16.0,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w600,
            textColor: Colors.black87,
          ),
          isDismissible: true,
          dismissDirection: DismissDirection.up,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: MyColorHelper.white.withOpacity(0.80));
}
