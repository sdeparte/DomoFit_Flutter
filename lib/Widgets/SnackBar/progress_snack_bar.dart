import 'package:domofit/Tools/sd_colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationProps { value }

const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);
const EdgeInsetsGeometry _snackBarMargin = EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0);

class ProgressSnackBar extends StatefulWidget implements SnackBar {
  @override
  final Widget content;

  @override
  final Color? backgroundColor;

  @override
  final SnackBarAction? action;

  @override
  final Animation<double>? animation;

  @override
  final SnackBarBehavior behavior = SnackBarBehavior.floating;

  @override
  final DismissDirection dismissDirection = DismissDirection.down;

  @override
  final double? elevation;

  @override
  final Duration duration;

  @override
  final EdgeInsetsGeometry? margin;

  @override
  final VoidCallback? onVisible;

  @override
  final EdgeInsetsGeometry? padding;

  @override
  final double? width;

  @override
  final ShapeBorder? shape;

  final Color? progressValueColor;
  final Color? progressBackgroundColor;
  final Color? buttonColor;

  const ProgressSnackBar({
    Key? key,
    required this.content,
    this.backgroundColor,
    this.progressValueColor,
    this.progressBackgroundColor,
    this.buttonColor,
    this.action,
    this.animation,
    this.duration = _snackBarDisplayDuration,
    this.elevation = 6.0,
    this.margin = _snackBarMargin,
    this.onVisible,
    this.padding,
    this.width,
    this.shape,
  }) : super(key: key);

  @override
  _ProgressSnackBarState createState() => _ProgressSnackBarState();

  @override
  SnackBar withAnimation(Animation<double> newAnimation, {Key? fallbackKey}) {
    return ProgressSnackBar(
      key: key ?? fallbackKey,
      content: content,
      backgroundColor: backgroundColor,
      progressValueColor: progressValueColor,
      progressBackgroundColor: progressBackgroundColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      width: width,
      shape: shape,
      action: action,
      duration: duration,
      animation: newAnimation,
      onVisible: onVisible,
    );
  }
}

class _ProgressSnackBarState extends State<ProgressSnackBar> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry padding = widget.padding
        ?? EdgeInsetsDirectional.only(start: 16.0, end: widget.action != null ? 0 : 16.0);

    final double actionHorizontalMargin = (widget.padding?.resolve(TextDirection.ltr).right ?? 16.0) / 2;

    final double elevation = widget.elevation ?? 6.0;
    final Color backgroundColor = widget.backgroundColor ?? SdColors.greyBack;
    final Color progressValueColor = widget.progressValueColor ?? SdColors.green;
    final Color progressBackgroundColor = widget.progressBackgroundColor ?? SdColors.greyBackAccent;
    final Color buttonColor = widget.buttonColor ?? Colors.white;
    final ShapeBorder? shape = widget.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));

    final tween = MultiTween<AnimationProps>()
      ..add(AnimationProps.value, Tween<double>(begin: 0.0, end: 1.0), widget.duration);

    return Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () {
        Scaffold.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
      },
      child: Dismissible(
        key: const Key('dismissible'),
        direction: widget.dismissDirection,
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          Scaffold.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.swipe);
        },
        child: Padding(
          padding: widget.margin ?? const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
          child: Material(
            shape: shape,
            elevation: elevation,
            color: backgroundColor,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              child: Stack(
                  children: [
                    CustomAnimation<MultiTweenValues<AnimationProps>>(
                        duration: tween.duration,
                        tween: tween,
                        builder: (context, child, animation) {
                          return LinearProgressIndicator(
                            color: progressValueColor,
                            backgroundColor: progressBackgroundColor,
                            value: animation.get(AnimationProps.value),
                          );
                        }
                    ),
                    Padding(
                      padding: padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: widget.padding == null ? const EdgeInsets.symmetric(vertical: 14.0) : null,
                              child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: buttonColor,
                                  ),
                                  child: widget.content
                              ),
                            ),
                          ),
                          if (widget.action != null)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: actionHorizontalMargin),
                              child: TextButtonTheme(
                                data: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  ),
                                ),
                                child: widget.action!,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
