import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationProps { height }

class HeightAnimation extends StatelessWidget {
  final double from;
  final double to;
  final double delay;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Widget? child;

  const HeightAnimation({
    Key? key,
    required this.from,
    required this.to,
    required this.delay,
    this.padding,
    this.decoration,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimationProps>()
      ..add(AnimationProps.height, Tween<double>(begin: from, end: to), const Duration(milliseconds: 1000), Curves.easeOut);

    return CustomAnimation<MultiTweenValues<AnimationProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child ?? const SizedBox(),
      builder: (context, child, animation) => Container(
        width: double.infinity,
        height: animation.get(AnimationProps.height),
        padding: padding,
        decoration: decoration,
        child: child,
      ),
    );
  }
}