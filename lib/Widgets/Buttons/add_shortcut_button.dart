import 'package:domofit/Tools/Clippers/rounded_clipper.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:flutter/material.dart';

class AddShortcutButton extends StatelessWidget {
  final Color splashColor;
  final GestureTapCallback? onPressed;

  const AddShortcutButton({
    Key? key,
    this.splashColor = Colors.white,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [SdColors.greenAccent, SdColors.green],
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: splashColor,
                        onTap: onPressed,
                        child: const Icon(
                          Icons.exit_to_app_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: ClipPath(
                    clipper: RoundedClipper(),
                    child: Container(
                      color: Colors.lightBlue,
                      padding: const EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 3/5,
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Ajouter",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}