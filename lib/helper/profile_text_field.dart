import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_app/helper/colors.dart';

class ProfileTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final IconData? suffixIcon;
  final VoidCallback? iconTap;
  final EdgeInsetsGeometry? contentPadding;
  const ProfileTextField(
      {super.key,
      required this.hintText,
      this.labelText,
      this.contentPadding,
      this.iconTap,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: MyColorHelper.lightBlue,
      autofocus: false,
      cursorOpacityAnimates: true,
      style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: MyColorHelper.verdigris),
      decoration: InputDecoration(
        contentPadding: contentPadding, // Adjust the content padding
        suffixIcon: GestureDetector(
            onTap: iconTap,
            child: Icon(
              suffixIcon,
              color: MyColorHelper.verdigris,
            )),
        hintText: hintText,
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
            color: MyColorHelper.verdigris),
        hintStyle: GoogleFonts.poppins(
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
            color: MyColorHelper.white),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColorHelper.verdigris)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColorHelper.white)),
      ),
    );
  }
}
