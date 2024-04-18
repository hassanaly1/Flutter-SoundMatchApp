import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';
import 'package:sound_app/models/sound_pack_model.dart';

class SoundPackList extends StatelessWidget {
  final SoundPackModel soundPackModel;
  const SoundPackList({super.key, required this.soundPackModel});
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
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white70)),
                iconTheme:
                    const IconThemeData(color: Colors.white60, size: 30.0),
                backgroundColor: Colors.transparent,
                title: CustomTextWidget(
                  text: 'Sound Treasury',
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
                              'assets/images/shop.png',
                              height: context.height * 0.15,
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: Container(
                    padding: const EdgeInsets.all(12.0),
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
                          text: '${soundPackModel.packName} Collection',
                          fontSize: 16.0,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          textColor: Colors.white,
                        ),
                        const Divider(),
                        SizedBox(height: context.height * 0.02),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              // leading: CircleAvatar(
                              //   backgroundImage: NetworkImage(
                              //       soundPackModel.sounds[index].songImage),
                              // ),
                              // title: CustomTextWidget(
                              //   text: soundPackModel.songs[index].songName,
                              //   textColor: Colors.white,
                              //   fontSize: 14.0,
                              //   fontWeight: FontWeight.w500,
                              //   fontFamily: 'poppins',
                              // ),
                              trailing: InkWell(
                                onTap: () {},
                                child: const Icon(
                                  CupertinoIcons.play_circle_fill,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          },
                        )
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
