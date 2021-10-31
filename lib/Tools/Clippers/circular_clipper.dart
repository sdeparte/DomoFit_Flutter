import 'package:flutter/material.dart';

class CircularClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: (size.width / 2) - 4
    );
  }

  @override
  bool shouldReclip(CircularClipper oldClipper) => false;
}