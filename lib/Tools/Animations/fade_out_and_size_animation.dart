import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationProps { opacity, size }

class FadeOutAndSizeAnimation extends StatelessWidget {
  final double delay;
  final double size;
  final Widget child;

  const FadeOutAndSizeAnimation({
    Key? key,
    required this.delay,
    required this.size,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimationProps>()
      ..add(AnimationProps.opacity, Tween<double>(begin: 1.0, end: -1.0), const Duration(milliseconds: 500))
      ..add(AnimationProps.size, Tween<double>(begin: size * (11 / 7), end: 0.0), const Duration(milliseconds: 500), Curves.easeOut);

    return CustomAnimation<MultiTweenValues<AnimationProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) {
        return animation.get(AnimationProps.opacity) > 0
          ? Opacity(
            opacity: animation.get(AnimationProps.opacity),
            child: child,
          )
          : SizedBox(
            width: animation.get(AnimationProps.size),
            height: animation.get(AnimationProps.size),
        );
      }
    );
  }
}