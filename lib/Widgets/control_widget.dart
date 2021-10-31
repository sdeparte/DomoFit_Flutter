import 'dart:math' as math;

import 'package:animate_icons/animate_icons.dart';
import 'package:domofit/Models/configuration.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/Clippers/circular_clipper.dart';
import 'package:domofit/Tools/Painters/rounded_animation_painter.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/remote_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlWidget extends StatefulWidget implements PreferredSizeWidget {
  final MainRouteState mainRouteState;
  final Configuration configuration;

  ControlWidget({Key? key, required this.mainRouteState
  }) : configuration = mainRouteState.configuration, super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  ControlWidgetState createState() => ControlWidgetState();
}

class ControlWidgetState extends State<ControlWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controllerRemote;
  late Animation _animationRemote;
  late AnimateIconController _iconAnimationControllerRemote;

  bool _isEditMode = false;
  bool isEditModeInstant = false;

  @override
  void initState() {
    super.initState();

    _controllerRemote = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animationRemote = Tween(begin: 0.0, end: 1.0).animate(_controllerRemote);
    _controllerRemote.addStatusListener(animationRemoteStatusListener);

    _iconAnimationControllerRemote = AnimateIconController();
  }

  animationRemoteStatusListener(AnimationStatus animationStatus) {
    switch (animationStatus) {
      case AnimationStatus.completed:
        setState(() {
          _isEditMode = true;
        });
        break;

      case AnimationStatus.dismissed:
        setState(() {
          _isEditMode = false;
        });
        break;

      case AnimationStatus.forward:
        setState(() {
          _iconAnimationControllerRemote.animateToEnd();
          isEditModeInstant = true;
        });
        break;

      case AnimationStatus.reverse:
        setState(() {
          _iconAnimationControllerRemote.animateToStart();
          isEditModeInstant = false;
        });
        break;
    }
  }

  void startEditRemote() {
    _controllerRemote.forward();
  }

  void cancelEditRemote() {
    _controllerRemote.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: SdColors.blackAccent,
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                AnimatedBuilder(
                  animation: _animationRemote,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RoundedAnimationPainter(
                        containerHeight: widget.preferredSize.height,
                        center: Offset(screenWidth - 62, 27.5),
                        radius: _animationRemote.value * math.max(screenWidth, 1500),
                        context: context,
                        color: SdColors.orange,
                      ),
                    );
                  },
                ),
                AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.settings_remote_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Contrôle :',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ClipOval(
                      clipper: CircularClipper(),
                      child: FloatingActionButton(
                        heroTag: "control",
                        child: AnimateIcons(
                          startIcon: Icons.edit_rounded,
                          endIcon: Icons.check_rounded,
                          size: 25.0,
                          onEndIconPress: () {
                            cancelEditRemote();

                            return true;
                          },
                          onStartIconPress: () {
                            startEditRemote();

                            return true;
                          },
                          duration: const Duration(milliseconds: 500),
                          startIconColor: isEditModeInstant || _isEditMode ? SdColors.orange : Theme.of(context).primaryColor,
                          controller: _iconAnimationControllerRemote,
                        ),
                        splashColor: SdColors.orange,
                        mini: true,
                        elevation: 2.0,
                        backgroundColor: Colors.white,
                        onPressed: !isEditModeInstant ? startEditRemote : cancelEditRemote,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    const SizedBox(width: double.infinity),
                    AnimatedBuilder(
                      animation: _animationRemote,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: RoundedAnimationPainter(
                            containerHeight: math.max(screenWidth, 1500),
                            center: Offset(screenWidth - 48, -30),
                            radius: _animationRemote.value * math.max(screenWidth, 1500),
                            context: context,
                            color: SdColors.orangeBlack,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            RemoteWidget(controlWidgetState: this),
          ],
        ),
      ),
    );
  }
}