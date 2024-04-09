import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

import '../../helper/colors.dart';
import '../../helper/snackbars.dart';

class SocialMediaCard extends StatelessWidget {
  final String imagePath;
  final String appName;
  const SocialMediaCard(this.imagePath, this.appName, {super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
        MySnackBarsHelper.showMessage(
          "Challenge posted on $appName account ",
          "Challenge Invitation",
          CupertinoIcons.share,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SvgPicture.asset(
              imagePath,
              width: 60,
              height: 60,
              // Adjust width and height as needed
            ),
            const SizedBox(height: 8),
            CustomTextWidget(
              text: appName,
              textColor: MyColorHelper.white,
            ),
          ],
        ),
      ),
    );
  }
}
