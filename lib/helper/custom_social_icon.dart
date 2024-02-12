import 'package:flutter/material.dart';

class CustomSocialIcon extends StatelessWidget {
  final String imagePath;
  const CustomSocialIcon({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      child: IconButton(
        onPressed: () {},
        icon: Image(height: 40.0, image: AssetImage(imagePath)),
      ),
    );
  }
}
