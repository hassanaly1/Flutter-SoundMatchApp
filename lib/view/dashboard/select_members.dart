import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/add_challenge_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_participant_widget.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/searchbar.dart';
import 'package:sound_app/models/member_model.dart';

class SelectMemberScreen extends StatelessWidget {
  final RxList<Member> selectedMembers;
  final RxList<Member> filteredMembers;
  final Function(String) onSearchChanged;
  const SelectMemberScreen(
      {super.key,
      required this.selectedMembers,
      required this.filteredMembers,
      required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    final AddChallengeController controller = Get.find();
    return SafeArea(
      child: Stack(fit: StackFit.expand, children: [
        SvgPicture.asset(MyAssetHelper.backgroundImage, fit: BoxFit.fill),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Obx(
                      () => Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.selectedMembers.isNotEmpty
                                  ? Colors.lightGreen
                                  : Colors.redAccent),
                          child: Icon(
                            controller.selectedMembers.isNotEmpty
                                ? Icons.done
                                : Icons.close,
                            color: Colors.white,
                          )),
                    )),
                iconTheme: const IconThemeData(size: 20.0),
                backgroundColor: Colors.transparent,
                title: CustomTextWidget(
                  text: 'Select Participants',
                  fontFamily: 'horta',
                  textColor: Colors.white,
                  fontSize: 26.0,
                ),
                centerTitle: true,
              ),
              body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        floating: true,
                        forceMaterialTransparency: true,
                        backgroundColor: Colors.transparent,
                        expandedHeight: context.height * 0.2,
                        flexibleSpace: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            SvgPicture.asset(
                              MyAssetHelper.addParticipants,
                              height: context.height * 0.2,
                              fit: BoxFit.contain,
                            ),
                            //Select Name Section
                          ],
                        ),
                      ),
                    ];
                  },
                  body: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                          MyColorHelper.caribbeanCurrent.withOpacity(0.5),
                          MyColorHelper.verdigris.withOpacity(0.5),
                          MyColorHelper.lightBlue.withOpacity(0.3),
                          MyColorHelper.white.withOpacity(0.2),
                        ],
                        stops: const [0.1, 0.3, 0.9, 3],
                      ),
                    ),
                    child: ListView(
                      children: [
                        CustomTextWidget(
                          text: 'Invite Friends & Family',
                          fontSize: 16.0,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          textColor: Colors.white,
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomSearchBar(
                          onChanged: onSearchChanged,
                        ),
                        const Divider(
                            color: Colors.grey, indent: 15.0, endIndent: 15.0),
                        SizedBox(height: context.height * 0.01),
                        Obx(
                          () => filteredMembers.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CustomTextWidget(
                                      text: 'No Match found',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      textColor: Colors.white70,
                                      fontFamily: 'poppins',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filteredMembers.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemBuilder: (context, index) {
                                    final member = filteredMembers[index];
                                    return CustomParticipantWidget(
                                      member: member,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        )
      ]),
    );
  }
}
