import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sound_app/helper/asset_helper.dart';
import 'package:sound_app/helper/colors.dart';

import '../../../helper/custom_text_widget.dart';

class RanksLoader extends StatelessWidget {
  const RanksLoader({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      height: height * 0.4,
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage(MyAssetHelper.leaderBackground),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                MyAssetHelper.robot,
                height: height * 0.15,
              ),
              const Expanded(
                child: CustomTextWidget(
                  text:
                      "All recordings have been received.\n Please wait, Result are Loading...... ",
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  fontFamily: 'poppins',
                  textColor: MyColorHelper.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SpinKitSpinningLines(
            color: Colors.white,
            size: height * 0.1,
            lineWidth: 4.0,
          )
        ],
      ),
    );
  }
}
