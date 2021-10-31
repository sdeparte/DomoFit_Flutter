import 'package:flutter/material.dart';

class RoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height),
        radius: size.height / 2
    ));
    return path;
  }
  @override
  bool shouldReclip(RoundedClipper oldClipper) => false;
}