// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class SquareBorder extends OutlinedBorder {
  final double width;
  final double height;
  final BorderSide side;
  final BorderRadiusGeometry? borderRadius;

  const SquareBorder({
    required this.width,
    required this.height,
    this.side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) => SquareBorder(
    width: width * t,
    height: height * t,
    side: side.scale(t),
    borderRadius: (borderRadius ?? BorderRadius.zero) * t,
  );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is SquareBorder) {
      return SquareBorder(
        width: a.width,
        height: a.height,
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t),
      );
    }

    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is SquareBorder) {
      return SquareBorder(
        width: b.width,
        height: b.height,
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t),
      );
    }

    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
    double width = this.width - side.width;
    double height = this.height - side.width;
    Rect newRect = Rect.fromLTWH(
        rect.center.dx - (width / 2),
        rect.center.dy - (height / 2),
        width,
        height
    );

    return Path()
      ..addRRect(borderRadius!.resolve(textDirection).toRRect(newRect));
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    Rect newRect = Rect.fromLTWH(
        rect.center.dx - (width / 2),
        rect.center.dy - (height / 2),
        width,
        height
    );

    return Path()
      ..addRRect(borderRadius!.resolve(textDirection).toRRect(newRect));
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        double width = math.max(0.0, this.width - side.width);
        double height = math.max(0.0, this.height - side.width);
        Rect newRect = Rect.fromLTWH(
            rect.center.dx - (width / 2),
            rect.center.dy - (height / 2),
            width,
            height
        );

        canvas.drawRRect(borderRadius!.resolve(textDirection).toRRect(newRect), side.toPaint());
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    final SquareBorder typedOther = other;
    return side == typedOther.side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '$runtimeType($side)';
  }

  @override
  SquareBorder copyWith({ double? width, double? height, BorderSide? side, BorderRadiusGeometry? borderRadius }) {
    return SquareBorder(
      width: width ?? this.width,
      height: height ?? this.height,
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
