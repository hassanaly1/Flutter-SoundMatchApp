import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_field.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/utils/storage_helper.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              hintText: MyAppStorage.fullName,
              labelText: "Username",
            ),
            SizedBox(height: context.height * 0.02),
            CustomTextField(
              hintText: MyAppStorage.userEmail,
              labelText: "Email",
            ),
            SizedBox(height: context.height * 0.02),
            CustomProfileButton(
              buttonText: 'Add Avatar',
              onTap: () {},
            ),
            SizedBox(height: context.height * 0.02),
            CustomProfileButton(
              buttonText: 'Save',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProfileButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const CustomProfileButton({
    super.key,
    required this.buttonText,
    required this.onTap,
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
          child: CustomTextWidget(
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
