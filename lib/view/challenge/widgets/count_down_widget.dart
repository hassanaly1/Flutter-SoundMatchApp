// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// class Countdown extends StatefulWidget {
//   final Duration duration;
//   final VoidCallback? onFinished;
//
//   const Countdown({super.key,
//     required this.duration,
//     this.onFinished,
//   });
//
//   @override
//   _CountdownState createState() => _CountdownState();
// }
//
// class _CountdownState extends State<Countdown> {
//   late Timer _timer;
//   late Duration _remainingTime;
//
//   @override
//   void initState() {
//     super.initState();
//     _remainingTime = widget.duration;
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_remainingTime.inSeconds > 0) {
//           _remainingTime -= const Duration(seconds: 1);
//         } else {
//           _timer.cancel();
//           if (widget.onFinished != null) {
//             widget.onFinished!();
//           }
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
//     String seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
//
//     return Text(
//       '$minutes:$seconds',
//       style: const TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//         fontSize: 20.0,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
// }
