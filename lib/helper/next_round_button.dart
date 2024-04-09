// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sound_app/helper/colors.dart';
// import 'package:sound_app/helper/custom_text_widget.dart';
//
// class NextRoundButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final Color? color;
//   const NextRoundButton({
//     super.key,
//     required this.text,
//     this.color,
//     required this.onTap,
//   });
//
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 70),
//         height: context.height*0.07,
//         decoration: BoxDecoration(
//             color:color?? MyColorHelper.verdigris.withOpacity(0.7),
//             borderRadius: const BorderRadius.all(Radius.circular(22.0))),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 22.0),
//               child: CustomTextWidget(
//                 text: text,
//                 fontSize: 18.0,
//                 textAlign: TextAlign.center,
//                 fontFamily: 'poppins',
//                 textColor: Colors.white70,
//               ),
//             ),
//             Container(
//               width: 70,
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white70.withOpacity(0.2),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(22.0),
//                   bottomRight: Radius.circular(22.0),
//                   topRight: Radius.circular(22.0),
//                 ),
//               ),
//               child: const Icon(
//                 CupertinoIcons.arrow_right,
//                 color: Colors.white70,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
