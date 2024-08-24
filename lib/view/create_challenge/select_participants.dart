import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sound_app/controller/create_challenge_controller.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/helper/searchbar.dart';
import 'package:sound_app/models/participant_model.dart';

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

  @override
  void initState() {
    // _controller.fetchParticipants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(fit: StackFit.expand, children: [
        Image.asset(MyAssetHelper.backgroundImage, fit: BoxFit.cover),
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
                            Image.asset(
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
                      controller: _controller.scrollController,
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
                            _controller.fetchParticipants(searchString: value);
                          },
                        ),
                        const Divider(
                            color: Colors.grey, indent: 15.0, endIndent: 15.0),
                        SizedBox(height: context.height * 0.01),
                        Obx(
                          () => _controller.participants.isEmpty
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
                                  itemCount: _controller.participants.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemBuilder: (context, index) {
                                    final participant =
                                        _controller.participants[index];
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

class CustomParticipantWidget extends StatelessWidget {
  final Participant participant;
  final bool? showAddIcon;

  CustomParticipantWidget({
    super.key,
    required this.participant,
    this.showAddIcon = true,
  });

  final CreateChallengeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: InkWell(
        onTap: () {
          _controller.addMembers(participant);
        },
        child: Container(
          color: Colors.transparent,
          width: 60,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 80,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: participant.profile == ''
                        ? Image.asset('assets/images/guest_user_profile.PNG')
                        : Image.network(
                            participant.profile.toString(),
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                  ),
                  CustomTextWidget(
                    text: '${participant.firstName} ${participant.lastName}',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'poppins',
                    textAlign: TextAlign.center,
                    textColor: Colors.white,
                  ),
                ],
              ),
              Obx(
                () => Visibility(
                  visible: showAddIcon == true,
                  child: Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        _controller.addMembers(participant);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _controller.selectedParticipants
                                  .contains(participant)
                              ? Colors.lightGreen
                              : Colors.white70,
                        ),
                        child: Icon(
                          _controller.selectedParticipants.contains(participant)
                              ? Icons.done
                              : Icons.add,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
