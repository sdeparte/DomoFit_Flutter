import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationProps { opacity, translateY }

class FadeInAndTranslateYAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeInAndTranslateYAnimation({
    Key? key,
    required this.delay,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimationProps>()
      ..add(AnimationProps.opacity, Tween<double>(begin: 0.0, end: 1.0), const Duration(milliseconds: 500))
      ..add(AnimationProps.translateY, Tween<double>(begin: -30.0, end: 0.0), const Duration(milliseconds: 500), Curves.easeOut);

    return CustomAnimation<MultiTweenValues<AnimationProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AnimationProps.opacity),
        child: Transform.translate(
            offset: Offset(0, animation.get(AnimationProps.translateY)),
            child: child,
        ),
      ),
    );
  }
}