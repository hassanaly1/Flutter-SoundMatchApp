import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/view/profile/profile_info_section.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              Flexible(
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
              CupertinoSwitch(
                activeColor: MyColorHelper.primaryColor,
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
          const Spacer(),
          CustomProfileButton(
            buttonText: 'Save',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
