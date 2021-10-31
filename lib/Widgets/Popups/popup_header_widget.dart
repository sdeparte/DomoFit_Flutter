import 'package:domofit/Tools/Animations/fade_in_and_translate_y_animation.dart';
import 'package:flutter/material.dart';

class PopupHeaderWidget extends StatelessWidget {
  final IconData primaryIcon;
  final IconData secondaryIcon;
  final Color backgroundColor;

  const PopupHeaderWidget({
    Key? key,
    required this.primaryIcon,
    required this.secondaryIcon,
    this.backgroundColor = Colors.lightBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: 100,
      color: backgroundColor,
      child: Stack(
        children: [
          Positioned(
            top: 5,
            left: screenWidth * 8/50,
            child: FadeInAndTranslateYAnimation(
              delay: 0.5,
              child: Icon(
                secondaryIcon,
                color: const Color(0x77FFFFFF),
                size: 17,
              ),
            ),
          ),
          Positioned(
            top: 55,
            left: screenWidth * 5/50,
            child: FadeInAndTranslateYAnimation(
              delay: 0.25,
              child: Icon(
                secondaryIcon,
                color: const Color(0x88FFFFFF),
                size: 20,
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: screenWidth * 13/50,
            child: FadeInAndTranslateYAnimation(
              delay: 0.5,
              child: Icon(
                secondaryIcon,
                color: const Color(0x55FFFFFF),
                size: 12,
              ),
            ),
          ),
          Positioned(
            top: 25,
            left: screenWidth * 9/50,
            child: FadeInAndTranslateYAnimation(
              delay: 0.75,
              child: Icon(
                secondaryIcon,
                color: const Color(0xAAFFFFFF),
                size: 30,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: screenWidth * 11/50,
            child: FadeInAndTranslateYAnimation(
              delay: 0.25,
              child: Icon(
                secondaryIcon,
                color: const Color(0x88FFFFFF),
                size: 20,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: screenWidth * 7/50,
            child: FadeInAndTranslateYAnimation(
              delay: 0.75,
              child: Icon(
                secondaryIcon,
                color: const Color(0x55FFFFFF),
                size: 12,
              ),
            ),
          ),
          Positioned(
            top: 35,
            right: screenWidth * 9/50,
            child: FadeInAndTranslateYAnimation(
              delay: 0.5,
              child: Icon(
                secondaryIcon,
                color: const Color(0x99FFFFFF),
                size: 25,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: screenWidth * 6/50,
            child: FadeInAndTranslateYAnimation(
              delay: 1,
              child: Icon(
                secondaryIcon,
                color: const Color(0x66FFFFFF),
                size: 15,
              ),
            ),
          ),
          Center(
            child: FadeInAndTranslateYAnimation(
              delay: 0,
              child: Icon(
                primaryIcon,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}