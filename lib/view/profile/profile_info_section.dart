import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/profile_text_field.dart';

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ProfileTextField(
              hintText: 'James Anderson',
              labelText: "Username",
            ),
            SizedBox(height: context.height * 0.02),
            const ProfileTextField(
              hintText: 'james@gmail.com',
              labelText: "Email",
            ),
            SizedBox(height: context.height * 0.02),
            Container(
              height: height * 0.08,
              decoration: BoxDecoration(
                  color: MyColorHelper.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MyColorHelper.verdigris)),
              child: Center(
                child: CustomTextWidget(
                  text: "Add Avatar",
                  textColor: MyColorHelper.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'poppins',
                ),
              ),
            ),
            SizedBox(height: context.height * 0.02),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: width * 0.6,
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
