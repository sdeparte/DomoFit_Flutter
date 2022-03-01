import 'dart:convert';
import 'dart:io';

import 'package:domofit/Models/shortcut.dart';
import 'package:domofit/Tools/Clippers/rounded_clipper.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class ShortcutButton extends StatefulWidget {
  final Shortcut? shortcut;
  final String? logoBase64;
  final bool small;
  final Color backgroundColor;
  final Color noLogoBackgroundColor;
  final Color splashColor;
  final GestureTapCallback? onTap;
  final Color pictoBackgroundColor;
  final IconData pictoIcon;
  final double pictoSize;

  const ShortcutButton({
    Key? key,
    this.shortcut,
    this.logoBase64,
    this.small = false,
    this.backgroundColor = Colors.lightBlue,
    this.noLogoBackgroundColor = SdColors.blackAccent,
    this.splashColor = Colors.white,
    this.onTap,
    this.pictoBackgroundColor = Colors.lightBlue,
    this.pictoIcon = Icons.exit_to_app_rounded,
    this.pictoSize = 18,
  }) : super(key: key);

  @override
  _ShortcutButtonState createState() => _ShortcutButtonState();
}

class _ShortcutButtonState extends State<ShortcutButton> {
  @override
  Widget build(BuildContext context) {
    Widget pictoWidget = ClipRRect(
      borderRadius: BorderRadius.circular(widget.small ? 15.0 : 17.0),
      child: ClipPath(
        clipper: RoundedClipper(),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            alignment: Alignment.bottomRight,
            color: widget.pictoBackgroundColor,
            padding: const EdgeInsets.all(6.0),
            width: 40,
            height: 40,
            child: Icon(
              widget.pictoIcon,
              color: Colors.white,
              size: widget.pictoSize,
            ),
          ),
        ),
      ),
    );

    Widget logoWidget;

    if (null != widget.shortcut?.logoImage ||
        !["", null].contains(widget.logoBase64)
    ) {
      logoWidget = RoundedButton(
        height: widget.small ? 57 : 70,
        width: widget.small ? 57 : 70,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(70.0),
            bottomRight: Radius.circular(34.0),
            topLeft: Radius.circular(70.0),
            topRight: Radius.circular(70.0),
        ),
        backgroundColor: Colors.white,
        textColor: Colors.white,
        splashColor: widget.splashColor,
        onPressed: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(70.0),
          child: Material(
            child: Ink.image(
              height: widget.small ? 57 : 70,
              width: widget.small ? 57 : 70,
              fit: BoxFit.cover,
              image: null != widget.shortcut && null != widget.shortcut!.logoImage
                  ? widget.shortcut!.logoImage!.image
                  : Image.memory(base64.decode(widget.logoBase64 as String)).image,
              child: InkWell(
                splashColor: widget.splashColor,
                borderRadius: BorderRadius.circular(70.0),
                onTap: widget.onTap,
              ),
            ),
          ),
        ),
      );
    } else {
      logoWidget = RoundedButton(
        height: widget.small ? 57 : 70,
        width: widget.small ? 57 : 70,
        borderRadius: BorderRadius.circular(70.0),
        backgroundColor: widget.noLogoBackgroundColor,
        textColor: Colors.white,
        splashColor: widget.splashColor,
        onPressed: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image(
                  image: Platform.isIOS ? const Svg('assets/apple.svg') : const Svg('assets/android.svg'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: SizedBox(
        width: widget.small ? 56 : 70,
        child: Column(
          children: [
            SizedBox(
              height: widget.small ? 56 : 70,
              child: Stack(
                children: <Widget>[
                  logoWidget,
                  pictoWidget,
                ],
              ),
            ),
            if (null != widget.shortcut) Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.shortcut!.shortcutName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ) else const SizedBox(),
          ],
        ),
      ),
    );
  }
}