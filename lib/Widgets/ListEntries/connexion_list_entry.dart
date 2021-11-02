
import 'package:domofit/Models/connexion.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/Animations/fade_in_animation.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConnexionListEntry extends StatefulWidget {
  const ConnexionListEntry({
    Key? key,
    required this.delay,
    required this.connexion,
    required this.myApp,
  }) : super(key: key);

  final double delay;
  final Connexion connexion;
  final MyApp myApp;

  @override
  State<ConnexionListEntry> createState() => _ConnexionListEntryState();
}

class _ConnexionListEntryState extends State<ConnexionListEntry> {
  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      delay: widget.delay,
      child: Card(
        elevation: 5.0,
        child: InkWell(
          splashColor: Colors.lightBlue,
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => MainRoute(myApp: widget.myApp, ipAddress: widget.connexion.ipAddress),
                transitionDuration: const Duration(seconds: 0),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Stack(
                  children: const [
                    Material(
                      shape: CircleBorder(),
                      color: Colors.lightBlue,
                      elevation: 2.0,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.devices_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        elevation: 5.0,
                        shape: CircleBorder(),
                        color: SdColors.white,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.wifi,
                            color: Colors.lightBlue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "IP : " + widget.connexion.ipAddress,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Dernière connexion : " + DateFormat('dd/MM/yyyy hh:mm').format(widget.connexion.date),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
