import 'package:animate_icons/animate_icons.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/Clippers/circular_clipper.dart';
import 'package:domofit/Tools/Painters/rounded_animation_painter.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LightWidget extends StatefulWidget implements PreferredSizeWidget {
  final MainRouteState mainRouteState;

  const LightWidget({Key? key, required this.mainRouteState}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  _LightWidgetState createState() => _LightWidgetState();
}

class _LightWidgetState extends State<LightWidget> with SingleTickerProviderStateMixin {
  late AnimateIconController _iconAnimationControllerLight;
  late AnimationController _controllerLight;
  late Animation _animationLight;

  bool _isLightOnInstant = false;

  @override
  void initState() {
    super.initState();

    _iconAnimationControllerLight = AnimateIconController();
    _controllerLight = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animationLight = Tween(begin: 0.0, end: 1.0).animate(_controllerLight);
    _controllerLight.addStatusListener(animationLightStatusListener);

    widget.mainRouteState.iconAnimationControllerLight = _iconAnimationControllerLight;
    widget.mainRouteState.animationLightController = _controllerLight;
  }

  void animationLightStatusListener(AnimationStatus animationStatus) {
    switch (animationStatus) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        break;

      case AnimationStatus.forward:
        setState(() {
          _isLightOnInstant = true;
        });
        break;

      case AnimationStatus.reverse:
        setState(() {
          _isLightOnInstant = false;
        });
        break;
    }
  }

  void startForceOn() {
    widget.mainRouteState.sendMessage("ALW ON");
  }

  void cancelForceOn() {
    widget.mainRouteState.sendMessage("ALW OFF");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5.0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: SdColors.blackAccent,
              ),
              AnimatedBuilder(
                animation: _animationLight,
                builder: (context, child) {
                  return CustomPaint(
                    painter: RoundedAnimationPainter(
                      containerHeight: widget.preferredSize.height,
                      center: Offset(screenWidth - 62, 27.5),
                      radius: _animationLight.value * screenWidth,
                      context: context,
                      color: Theme.of(context).primaryColor,
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
                      Icons.brightness_medium_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Eclairage :',
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
                      heroTag: "light",
                      child: widget.mainRouteState.isConnected
                        ? AnimateIcons(
                          startIcon: Icons.brightness_auto_outlined,
                          endIcon: Icons.brightness_high,
                          size: 25.0,
                          onEndIconPress: () {
                            cancelForceOn();

                            return true;
                          },
                          onStartIconPress: () {
                            startForceOn();

                            return true;
                          },
                          duration: const Duration(milliseconds: 500),
                          startIconColor: widget.mainRouteState.isForceOn ? Theme.of(context).primaryColor : SdColors.greyBackAccent,
                          controller: _iconAnimationControllerLight,
                        )
                        : const Icon(
                          Icons.brightness_7_outlined,
                          color: Colors.white,
                        ),
                      splashColor: Colors.lightBlue,
                      mini: true,
                      elevation: 2.0,
                      backgroundColor: !widget.mainRouteState.isConnected ? SdColors.greyBackAccent : Colors.white,
                      onPressed: !widget.mainRouteState.isConnected ? null : !_isLightOnInstant ? startForceOn : cancelForceOn,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            color: widget.mainRouteState.isConnected
                ? Colors.white
                : SdColors.greyBackAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 35,
                      color: SdColors.greyBack,
                    ),
                    AnimatedBuilder(
                      animation: _animationLight,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: RoundedAnimationPainter(
                            containerHeight: 35,
                            center: Offset(screenWidth - 48, -30),
                            radius: _animationLight.value * screenWidth,
                            context: context,
                            color: Colors.lightBlueAccent,
                          ),
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        !widget.mainRouteState.isConnected
                          ? 'Mode d\'éclairage : "Inconnu".'
                          : widget.mainRouteState.isForceOn
                            ? 'Mode d\'éclairage : "Toujours allumé".'
                            : 'Mode d\'éclairage : "Détection de présence".',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
