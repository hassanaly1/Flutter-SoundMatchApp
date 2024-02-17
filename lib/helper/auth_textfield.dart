import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/helper/colors.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  Widget? suffixIcon;
  double? fontSize;
  TextEditingController? controller;
  bool obscureText;
  final String? Function(String?)? validator;
  AuthTextField(
      {super.key,
      required this.hintText,
      this.controller,
      this.fontSize,
      this.suffixIcon,
      this.obscureText = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
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
        suffixIcon: suffixIcon,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColorHelper.verdigris)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColorHelper.white)),
      ),
    );
  }
}
