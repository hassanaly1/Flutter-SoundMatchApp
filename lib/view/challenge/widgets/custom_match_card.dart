import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomMatchCard extends StatelessWidget {
  final VoidCallback onTap;

  const CustomMatchCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
          height: context.height * 0.25,
          width: context.width * 0.8,
          child: Image.asset(
            'assets/images/free-match.png',
          )),
      // child: Stack(
      //   children: [
      //     SizedBox(
      //         height: context.height * 0.25,
      //         width: context.width * 0.8,
      //         child: Image.asset(
      //           'assets/images/homeicon4.png',
      //         )),
      //     Positioned.fill(
      //       child: Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             const CustomTextWidget(
      //               fontFamily: 'horta',
      //               isShadow: true,
      //               shadow: [
      //                 Shadow(
      //                   blurRadius: 15.0,
      //                   color: Colors.black,
      //                   offset: Offset(0, 0),
      //                 ),
      //                 Shadow(
      //                   blurRadius: 5.0,
      //                   color: MyColorHelper.primaryColor,
      //                   offset: Offset(0, 0),
      //                 ),
      //               ],
      //               text: 'Free Challenge',
      //               fontWeight: FontWeight.w700,
      //               fontSize: 30.0,
      //               textColor: Colors.white,
      //               maxLines: 1,
      //             ),
      //             Image.asset(
      //               MyAssetHelper.onboardingTwo,
      //               height: 80,
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
