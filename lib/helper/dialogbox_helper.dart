// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:sound_app/helper/custom_text_widget.dart';
//
// class MyDialogBoxHelper{
//
//
//
//    void showLottiePopup(BuildContext context,String message,lottiePath) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: const Text('Done'),
//             ),
//           ],
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 width: 200,
//                 height: 200,
//                 child: Lottie.asset(
//                   lottiePath, // Replace with your Lottie animation file path
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(
//                 height: Get.height * 0.002,
//               ),
//               CustomTextWidget(
//                 text: message,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
// }
