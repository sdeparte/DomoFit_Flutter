import 'dart:ui';
import 'package:animate_icons/animate_icons.dart';
import 'package:domofit/Managers/shortcuts_manager.dart';
import 'package:domofit/Models/shortcut.dart';
import 'package:domofit/Tools/Animations/fade_in_and_size_animation.dart';
import 'package:domofit/Tools/Animations/fade_out_and_size_animation.dart';
import 'package:domofit/Tools/Clippers/circular_clipper.dart';
import 'package:domofit/Tools/Painters/rounded_animation_painter.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';

import 'Buttons/add_shortcut_button.dart';
import 'Buttons/shortcut_button.dart';
import 'Popups/add_shortcut_popup.dart';
import 'Popups/remove_shortcut_popup.dart';

class ShortcutsWidget extends StatefulWidget implements PreferredSizeWidget {
  const ShortcutsWidget({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  ShortcutsWidgetState createState() => ShortcutsWidgetState();
}

class ShortcutsWidgetState extends State<ShortcutsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controllerShortcuts;
  late Animation _animationShortcuts;
  late AnimateIconController _iconAnimationControllerShortcuts;

  bool _isEditMode = false;
  bool isEditModeInstant = false;

  late List<Shortcut> _shortcuts;

  @override
  void initState() {
    super.initState();

    _controllerShortcuts = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animationShortcuts = Tween(begin: 0.0, end: 1.0).animate(_controllerShortcuts);
    _controllerShortcuts.addStatusListener(animationShortcutsStatusListener);

    _iconAnimationControllerShortcuts = AnimateIconController();

    _shortcuts = <Shortcut>[];

    getAllShortcuts();
  }

  animationShortcutsStatusListener(AnimationStatus animationStatus) {
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
          _iconAnimationControllerShortcuts.animateToEnd();
          isEditModeInstant = true;
        });
        break;

      case AnimationStatus.reverse:
        setState(() {
          _iconAnimationControllerShortcuts.animateToStart();
          isEditModeInstant = false;
        });
        break;
    }
  }

  void startEditRemote() {
    _controllerShortcuts.forward();
  }

  void cancelEditRemote() {
    _controllerShortcuts.reverse();
  }

  void getAllShortcuts() async {
    List<Shortcut> shortcuts = await ShortcutsManager.instance.getAllShortcuts();

    for (var shortcut in shortcuts) {
      Map<String, String?>? appInformations = await AppAvailability.checkAvailability(shortcut.packageName);

      if (appInformations != null) {
        setState(() {
          shortcut.setAppInformations(appInformations);
        });
      }
    }

    setState(() {
      _shortcuts = shortcuts;
    });
  }

  Future<void> insertShortcut(String packageName, String shortcutName) async {
    Shortcut shortcut = await ShortcutsManager.instance.insertShortcut(
      Shortcut(packageName: packageName, shortcutName: shortcutName)
    );
    Map<String, String?>? appInformations = await AppAvailability.checkAvailability(shortcut.packageName);

    if (appInformations != null) {
      shortcut.setAppInformations(appInformations);
    }

    setState(() {
      _shortcuts.add(shortcut);
    });
  }

  void deleteShortcut(Shortcut shortcut) async {
    await ShortcutsManager.instance.deleteShortcut(shortcut);

    setState(() {
      _shortcuts.remove(shortcut);
    });
  }

  void showAddShortcutDialog() {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
              opacity: a1.value,
              child: AddShortcutPopup(
                shortcutsWidgetState: this,
              ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const AlertDialog(title: Text('Alert!'));
      }
    );
  }

  void showRemoveShortcutDialog(Shortcut shortcut) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
              opacity: a1.value,
              child: RemoveShortcutPopup(
                  shortcutsWidgetState: this,
                  shortcut: shortcut,
              ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const AlertDialog(title: Text('Alert!'));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<Widget> shortcuts = <Widget>[];

    if (isEditModeInstant) {
      shortcuts.add(
        FadeInAndSizeAnimation(
          delay: 0,
          size: 70,
          child: AddShortcutButton(
            splashColor: Colors.white,
            onPressed: () { showAddShortcutDialog(); },
          ),
        )
      );
    } else {
      shortcuts.add(
        FadeOutAndSizeAnimation(
          delay: 0,
          size: 70,
          child: AddShortcutButton(
            splashColor: Colors.white,
            onPressed: () { showAddShortcutDialog(); },
          ),
        )
      );
    }

    for (var shortcut in _shortcuts) {
      shortcuts.add(
        ShortcutButton(
          shortcut: shortcut,
          backgroundColor: isEditModeInstant ? SdColors.red : Colors.lightBlue,
          noLogoBackgroundColor: isEditModeInstant ? SdColors.redAccent : SdColors.blackAccent,
          pictoBackgroundColor: isEditModeInstant ? SdColors.red : Colors.lightBlue,
          pictoIcon: isEditModeInstant ? Icons.delete_outline : Icons.exit_to_app,
          splashColor: Colors.white,
          onTap: isEditModeInstant
              ? () { showRemoveShortcutDialog(shortcut); }
              : () { AppAvailability.launchApp(shortcut.appInformations!["package_name"] as String); },
        )
      );
    }

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
                backgroundColor: Theme.of(context).primaryColor,
              ),
              AnimatedBuilder(
                animation: _animationShortcuts,
                builder: (context, child) {
                  return CustomPaint(
                    painter: RoundedAnimationPainter(
                      containerHeight: widget.preferredSize.height,
                      center: Offset(screenWidth - 62, 27.5),
                      radius: _animationShortcuts.value * screenWidth,
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
                      Icons.apps_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Accès rapides :',
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
                      heroTag: "shortcuts",
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
                        controller: _iconAnimationControllerShortcuts,
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
              Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      const SizedBox(width: double.infinity),
                      AnimatedBuilder(
                        animation: _animationShortcuts,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: RoundedAnimationPainter(
                              containerHeight: 500,
                              center: Offset(screenWidth - 48, -30),
                              radius: _animationShortcuts.value * screenWidth,
                              context: context,
                              color: SdColors.orangeWhite,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 126,
                child: ListView(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 10.0, right: 10.0),
                  scrollDirection: Axis.horizontal,
                  children: shortcuts,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}