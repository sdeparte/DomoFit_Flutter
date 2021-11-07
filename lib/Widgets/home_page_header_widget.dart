import 'package:flutter/material.dart';
import 'package:domofit/Tools/Animations/fade_in_and_translate_y_animation.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class HomePageHeaderWidget extends StatelessWidget {
  const HomePageHeaderWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.scanQRCode,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;
  final bool scanQRCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight / 2.5,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40.0),
      child: Stack(
        children: [
          Positioned(
            top: screenHeight * 3/50,
            left: screenWidth * 8/50,
            child: const FadeInAndTranslateYAnimation(
              delay: 2.5,
              child: Opacity(
                opacity: 0.4,
                child: Image(
                  image: Svg('assets/logo.svg', size: Size.fromRadius(17)),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 6/50,
            left: screenWidth * 5/50,
            child: const FadeInAndTranslateYAnimation(
              delay: 2.25,
              child: Opacity(
                opacity: 0.5,
                child: Image(
                  image: Svg('assets/logo.svg', size: Size.fromRadius(20)),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 8/50,
            left: screenWidth * 13/50,
            child: const FadeInAndTranslateYAnimation(
              delay: 2.5,
              child: Opacity(
                opacity: 0.3,
                child: Image(
                  image: Svg('assets/logo.svg', size: Size.fromRadius(12)),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 4.5/50,
            left: screenWidth * 9/50,
            child: const FadeInAndTranslateYAnimation(
              delay: 2.75,
              child: Opacity(
                opacity: 0.6,
                child: Image(
                  image: Svg('assets/logo.svg', size: Size.fromRadius(30)),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 2.5/50,
            right: screenWidth * 13/50,
            child: const FadeInAndTranslateYAnimation(
              delay: 2.25,
              child: Opacity(
                opacity: 0.5,
                child: Image(
                  image: Svg('assets/logo.svg', size: Size.fromRadius(20)),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 4/50,
            right: screenWidth * 8/50,
            child: const FadeInAndTranslateYAnimation(
              delay: 2.75,
              child: Opacity(
                opacity: 0.3,
                child: Image(
                  image: Svg('assets/logo.svg', size: Size.fromRadius(12)),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 5.5/50,
            right: screenWidth * 9/50,
            child: const FadeInAndTranslateYAnimation(
              delay: 2.5,
              child: Opacity(
                opacity: 0.6,
                child: Image(
                  image: Svg('assets/logo.svg', size: Size.fromRadius(25)),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 8/50,
            right: screenWidth * 6/50,
            child: const FadeInAndTranslateYAnimation(
              delay: 3,
              child: Opacity(
                opacity: 0.4,
                child: Image(
                  image: Svg('assets/logo.svg', size: Size.fromRadius(15)),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FadeInAndTranslateYAnimation(
              delay: 2,
              child: Image(
                image: Svg('assets/logo.svg', size: Size.fromRadius(screenHeight / 5 - 35)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FadeInAndTranslateYAnimation(
                    delay: 3,
                    child: Text("Trouver ma DomoFit-Box :",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FadeInAndTranslateYAnimation(
                    delay: 3.5,
                    child: Text(scanQRCode ? "Scannez le QR Code présent sut votre apparail" : "Recherchez votre apparail dans la liste",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}