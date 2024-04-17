import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/helper/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final Widget? suffixIcon;
  bool obscureText;
  final String? Function(String?)? validator;
  TextEditingController? controller;
  CustomTextField(
      {super.key,
      required this.hintText,
      this.labelText,
      this.controller,
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
      autofocus: false,
      cursorOpacityAnimates: true,
      style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: MyColorHelper.verdigris),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
            color: MyColorHelper.verdigris),
        hintStyle: GoogleFonts.poppins(
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
            color: Colors.grey.shade300),
        errorStyle: const TextStyle(fontFamily: 'poppins'),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColorHelper.verdigris)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColorHelper.white)),
      ),
    );
  }
}
