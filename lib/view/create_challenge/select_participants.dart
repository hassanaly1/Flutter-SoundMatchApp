import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/create_challenge_controller.dart';
import 'package:sound_app/controller/universal_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/searchbar.dart';
import 'package:sound_app/view/challenge/widgets/custom_participant_widget.dart';

class SelectParticipantsScreen extends StatefulWidget {
  const SelectParticipantsScreen({
    super.key,
  });

  @override
  State<SelectParticipantsScreen> createState() =>
      _SelectParticipantsScreenState();
}

class _SelectParticipantsScreenState extends State<SelectParticipantsScreen> {
  final CreateChallengeController _controller = Get.find();
  final MyUniversalController _universalController = Get.find();

  @override
  void initState() {
    _universalController.fetchParticipants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              color: _controller.selectedParticipants.isNotEmpty
                                  ? Colors.lightGreen
                                  : Colors.redAccent),
                          child: Icon(
                            _controller.selectedParticipants.isNotEmpty
                                ? Icons.done
                                : Icons.close,
                            color: Colors.white,
                          )),
                    )),
                iconTheme: const IconThemeData(size: 20.0),
                backgroundColor: Colors.transparent,
                title: const CustomTextWidget(
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
                        const CustomTextWidget(
                          text: 'Invite Friends & Family',
                          fontSize: 16.0,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          textColor: Colors.white,
                        ),
                        SizedBox(height: context.height * 0.01),
                        CustomSearchBar(
                          onChanged: (value) {
                            _universalController.fetchParticipants(
                                searchString: value);
                          },
                        ),
                        const Divider(
                            color: Colors.grey, indent: 15.0, endIndent: 15.0),
                        SizedBox(height: context.height * 0.01),
                        Obx(
                          () => _universalController.participants.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CustomTextWidget(
                                      text: 'No Participants found',
                                      fontSize: 14.0,
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
                                  itemCount:
                                      _universalController.participants.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemBuilder: (context, index) {
                                    final participant = _universalController
                                        .participants[index];
                                    return CustomParticipantWidget(
                                      participant: participant,
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
