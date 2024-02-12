import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/helper/colors.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  double? fontSize;
  TextEditingController? controller;
  AuthTextField(
      {super.key, required this.hintText, this.controller, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: MyColorHelper.lightBlue,
      cursorOpacityAnimates: true,
      style: GoogleFonts.poppins(
          fontSize: fontSize ?? 14.0,
          fontWeight: FontWeight.w400,
          color: MyColorHelper.verdigris),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
            fontSize: fontSize ?? 14.0,
            fontWeight: FontWeight.w400,
            color: MyColorHelper.verdigris),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColorHelper.verdigris)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColorHelper.white)),
      ),
    );
  }
}
