import 'package:flutter/material.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 150); // Start from the bottom left corner
    path.quadraticBezierTo(size.width / 2, size.height, size.width,
        size.height - 150); // Draw a concave curve
    path.lineTo(size.width, 0); // Draw the right edge
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
