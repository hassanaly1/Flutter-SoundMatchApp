import 'package:flutter/material.dart';
import 'package:sound_app/helper/colors.dart';
import 'package:sound_app/helper/custom_text_widget.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: labelText ?? '',
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 4.0),
        TextFormField(
          onTap: onTap,
          readOnly: readOnly,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          cursorColor: MyColorHelper.lightBlue,
          autofocus: false,
          cursorOpacityAnimates: true,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hintText,
            // labelText: labelText,
            labelStyle: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
              color: MyColorHelper.verdigris,
              fontFamily: 'Poppins',
            ),
            hintStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              fontFamily: 'Poppins',
              color: Colors.white60,
            ),
            errorStyle: const TextStyle(
                fontFamily: 'poppins', color: Colors.red, fontSize: 14.0),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: MyColorHelper.verdigris)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
