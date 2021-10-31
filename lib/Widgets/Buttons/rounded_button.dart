import 'package:domofit/Tools/Borders/square_boder.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Widget child;
  final double elevation;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final Color splashColor;
  final BorderRadius? borderRadius;
  final GestureTapCallback? onPressed;

  const RoundedButton({
    Key? key,
    required this.child,
    this.elevation = 2.0,
    this.width = 40,
    this.height = 40,
    this.backgroundColor = Colors.white,
    this.textColor = SdColors.black,
    this.splashColor = SdColors.black,
    this.borderRadius,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            textStyle: TextStyle(
                color: textColor
            ),
            primary: backgroundColor,
            onPrimary: splashColor,
            padding: const EdgeInsets.all(0),
            shape: SquareBorder(
                width: width,
                height: height,
                borderRadius: borderRadius ?? BorderRadius.circular(5.0)
            ),
          ),
          onPressed: onPressed,
          child: child,
        ),
      );
  }

}