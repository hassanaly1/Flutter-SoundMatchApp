import 'package:flutter/material.dart';

class MyLeftCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 30);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height - 30);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomLeftShapeCard extends StatelessWidget {
  const CustomLeftShapeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      width: 300,
      child: ClipPath(
        clipper: MyLeftCustomClipper(),
        child: Container(
          decoration: const BoxDecoration(color: Colors.red),
          height: 200, // Set the height of the container
        ),
      ),
    );
  }
}

class MyRightCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 30);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height - 30);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomRightShapeCard extends StatelessWidget {
  const CustomRightShapeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      width: 300,
      child: ClipPath(
        clipper: MyRightCustomClipper(),
        child: Container(
          decoration: const BoxDecoration(color: Colors.red),
          height: 200, // Set the height of the container
        ),
      ),
    );
  }
}
