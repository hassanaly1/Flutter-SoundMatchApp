import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/custom_user_card.dart';
import 'package:sound_app/helper/snackbars.dart';
import 'package:sound_app/models/member_screen.dart';

import '../../helper/colors.dart';

late MyNewChallengeController _myNewChallengeController;

class SocialMediaSharingBottomSheet extends StatefulWidget {
  const SocialMediaSharingBottomSheet({super.key});
  @override
  State<SocialMediaSharingBottomSheet> createState() =>
      _SocialMediaSharingBottomSheetState();
}

class _SocialMediaSharingBottomSheetState
    extends State<SocialMediaSharingBottomSheet> {
  @override
  void initState() {
    _myNewChallengeController =
        Get.put(MyNewChallengeController(), permanent: true);

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyNewChallengeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: Get.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
            fit: BoxFit.fill, image: AssetImage(MyAssetHelper.backgroundImage)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextWidget(
                  text: 'Share with your friends',
                  fontSize: 16.0,
                  textColor: MyColorHelper.white,
                  fontWeight: FontWeight.w500),
              const SizedBox(height: 10.0),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SocialMediaCard('assets/svgs/facebook.svg', 'Facebook'),
                    SocialMediaCard('assets/svgs/whatsapp.svg', 'WhatsApp'),
                    SocialMediaCard('assets/svgs/instagram.svg', 'Instagram'),
                    SocialMediaCard('assets/svgs/twitterx.svg', 'X'),
                    SocialMediaCard('assets/svgs/messenger.svg', 'Messenger')
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: context.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: _myNewChallengeController.members.length,
                  itemBuilder: (context, index) {
                    final member = _myNewChallengeController.members[index];
                    return CustomUserCard(
                      member.profilePath!,
                      member.name!,
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: MyColorHelper.white.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                ),
                child: ListTile(
                  title: CustomTextWidget(
                    text: 'Copy Link',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  subtitle: CustomTextWidget(
                    text: 'https://www.example.com',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () {
                    Get.back();

                    MySnackBarsHelper.showMessage(
                      "",
                      "Copied to Clipboard",
                      CupertinoIcons.doc,
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
