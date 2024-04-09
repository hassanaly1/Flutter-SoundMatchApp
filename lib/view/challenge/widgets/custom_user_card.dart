//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:sound_app/helper/colors.dart';
// import 'package:sound_app/helper/custom_text_widget.dart';
// import 'package:sound_app/helper/snackbars.dart';
// class CustomUserCard extends StatelessWidget {
//   final String imagePath;
//   final String appName;
//   const CustomUserCard(this.imagePath, this.appName, {super.key});
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Get.back();
//
//         MySnackBarsHelper.showMessage("Invitation Shared to $appName ", "Challenge Invitation",CupertinoIcons.share,);
//
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ClipOval(
//                 child: Image.network(
//                   fit: BoxFit.cover,
//                   imagePath,
//                   width: 60.0,
//                   height: 60.0,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               CustomTextWidget(
//                 text: appName,
//                 fontSize: 14.0,
//                 textColor:MyColorHelper.white,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
