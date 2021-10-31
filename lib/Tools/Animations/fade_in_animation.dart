import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationProps { opacity }

class FadeInAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeInAnimation({
    Key? key,
    required this.delay,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimationProps>()
      ..add(AnimationProps.opacity, Tween<double>(begin: 0.0, end: 1.0), const Duration(milliseconds: 500));

    return CustomAnimation<MultiTweenValues<AnimationProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(AnimationProps.opacity),
        child: child,
      ),
    );
  }
}