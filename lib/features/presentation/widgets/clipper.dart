import 'package:flutter/material.dart';

class BoxClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double sideRadius = 6.0;
    double midPoint = size.width * 0.85; // Adjusted for width
    double cornerRadius = 10.0;

    path.moveTo(0, cornerRadius);

    // TopLeft Corner
    path.quadraticBezierTo(
        0, 0,
        cornerRadius, 0
    );

    path.lineTo((midPoint - sideRadius), 0);

    // Top Arc
    path.quadraticBezierTo(
        midPoint - sideRadius, sideRadius,
        midPoint, sideRadius
    );
    path.quadraticBezierTo(
        midPoint + sideRadius, sideRadius,
        midPoint + sideRadius, 0
    );

    path.lineTo(size.width - cornerRadius, 0);

    // TopRight Corner
    path.quadraticBezierTo(
        size.width, 0,
        size.width, cornerRadius
    );

    path.lineTo(size.width, size.height - cornerRadius);

    // BottomRight Corner
    path.quadraticBezierTo(
        size.width, size.height,
        size.width - cornerRadius, size.height
    );

    path.lineTo(midPoint + sideRadius, size.height);

    // Bottom Arc
    path.quadraticBezierTo(
        midPoint + sideRadius, size.height - sideRadius,
        midPoint, size.height - sideRadius
    );
    path.quadraticBezierTo(
        midPoint - sideRadius, size.height - sideRadius,
        midPoint - sideRadius, size.height
    );

    path.lineTo(cornerRadius, size.height);

    // BottomLeft Corner
    path.quadraticBezierTo(
        0, size.height,
        0, size.height - cornerRadius
    );

    path.lineTo(0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
