import 'package:domofit/Tools/sd_colors.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Widget child;
  final double elevation;
  final double diameter;
  final Color backgroundColor;
  final Color textColor;
  final Color splashColor;
  final GestureTapCallback? onPressed;

  const CircularButton({
    Key? key,
    required this.child,
    this.elevation = 2.0,
    this.diameter = 60,
    this.backgroundColor = Colors.white,
    this.textColor = SdColors.black,
    this.splashColor = SdColors.black,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        width: diameter,
        height: diameter,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            textStyle: TextStyle(
                color: textColor
            ),
            primary: backgroundColor,
            onPrimary: splashColor,
            padding: const EdgeInsets.all(0),
            shape: const CircleBorder(),
          ),
          onPressed: onPressed,
          child: child,
        ),
      );
  }

}