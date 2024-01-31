import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/profile_text_field.dart';

class SecuritySection extends StatefulWidget {
  const SecuritySection({super.key});

  @override
  State<SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState extends State<SecuritySection> {
  MyNewChallengeController myNewChallengeController = Get.find();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            SizedBox(height: context.height * 0.01),
            CustomTextWidget(
              text: "Two-Factor Authentication",
              textColor: MyColorHelper.white,
              fontSize: 16,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: context.height * 0.03),

            //two factor description
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextWidget(
                    text:
                        "Enable two factor authentication to add extra security to your account",
                    maxLines: 2,
                    textColor: MyColorHelper.white,
                    fontSize: 12,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => CupertinoSwitch(
                      activeColor: MyColorHelper.primaryColor,
                      value: myNewChallengeController.switchValue,
                      onChanged: (value) {
                        myNewChallengeController.setSwitchValue = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.height * 0.03),
            Obx(
              () => ProfileTextField(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                hintText: "Password",
                suffixIcon: myNewChallengeController.passwordIconTap
                    ? CupertinoIcons.eye_fill
                    : CupertinoIcons.eye_slash_fill,
                iconTap: () {
                  myNewChallengeController.toggleIconButton();
                },
              ),
            ),
            SizedBox(height: context.height * 0.02),
            Obx(
              () => ProfileTextField(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                hintText: "Confirm Password",
                suffixIcon: myNewChallengeController.confirmPasswordIconTap
                    ? CupertinoIcons.eye_fill
                    : CupertinoIcons.eye_slash_fill,
                iconTap: () {
                  myNewChallengeController.toggleConfirmIconButton();
                },
              ),
            ),

            // Obx(
            //   () => CheckboxListTile(
            //     controlAffinity: ListTileControlAffinity
            //         .leading, // Align checkbox to the start
            //     dense: true,
            //     side: const BorderSide(color: MyColorHelper.white),
            //     contentPadding: EdgeInsets.zero,
            //     activeColor: MyColorHelper.primaryColor,
            //     title: CustomTextWidget(
            //       text: "Logout from all devices",
            //       textColor: MyColorHelper.white,
            //       fontSize: 14,
            //       fontFamily: 'poppins',
            //       fontWeight: FontWeight.w400,
            //     ),
            //     checkColor: MyColorHelper.white,
            //     value: myNewChallengeController.checkBoxValue,
            //     onChanged: (value) {
            //       myNewChallengeController.setCheckBoxValue = value;
            //     },
            //   ),
            // ),
            SizedBox(height: context.height * 0.03),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.15),
                height: height * 0.08,
                decoration: BoxDecoration(
                    color: MyColorHelper.primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: CustomTextWidget(
                    text: "Save",
                    fontFamily: 'poppins',
                    textColor: MyColorHelper.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
