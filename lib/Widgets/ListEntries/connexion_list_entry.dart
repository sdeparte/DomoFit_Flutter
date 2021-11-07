
import 'dart:async';
import 'dart:io';

import 'package:dart_ping/dart_ping.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:domofit/Models/connexion.dart';
import 'package:domofit/Routes/device_search_route.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/Animations/fade_in_animation.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/SnackBar/progress_snack_bar.dart';
import 'package:domofit/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConnexionListEntry extends StatefulWidget {
  const ConnexionListEntry({
    Key? key,
    required this.animate,
    required this.delay,
    required this.connexion,
    required this.discoveryRouteState,
    required this.myApp,
  }) : super(key: key);

  final bool animate;
  final double delay;
  final Connexion connexion;
  final DiscoveryRouteState discoveryRouteState;
  final MyApp myApp;

  @override
  State<ConnexionListEntry> createState() => _ConnexionListEntryState();
}

class _ConnexionListEntryState extends State<ConnexionListEntry> {
  Ping? _ping;
  bool _reachable = false;

  @override
  void initState() {
    super.initState();

    _isReachable();
  }

  @override
  void dispose() {
    _ping?.stop();

    super.dispose();
  }

  Future<void> _isReachable() async {
    if (Platform.isIOS) {
      DartPingIOS.register();
    }

    _ping = Ping(widget.connexion.ipAddress);

    _ping?.stream.listen((event) {
      if (event.summary == null) {
        setState(() {
          _reachable = event.error == null;
        });
      }
    });
  }

  Card _buildCard(BuildContext context) {
    return Card(
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
                children: [
                  Material(
                    shape: const CircleBorder(),
                    color: _reachable ? Colors.lightBlue : SdColors.greyBackAccent,
                    elevation: 2.0,
                    child: const Padding(
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
                      shape: const CircleBorder(),
                      color: _reachable ? Colors.white : SdColors.greyBack,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          _reachable ? Icons.wifi : Icons.wifi_off,
                          color: _reachable ? Colors.lightBlue : Colors.white,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(widget.connexion),
      onDismissed: (direction) {
        widget.discoveryRouteState.removeConnexionFromList(widget.connexion);

        Timer timer = Timer(const Duration(seconds: 4), () {
          widget.discoveryRouteState.removeConnexionFromDatabase(widget.connexion);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          ProgressSnackBar(
            content: const Text("Suppression de la connexion récente."),
            action: SnackBarAction(
              label: "Annuler",
              textColor: Colors.white,
              onPressed: () {
                timer.cancel();
                widget.discoveryRouteState.reloadConnexions(
                    animation: false
                );
              },
            ),
          ),
        );
      },
      child: widget.animate
          ? FadeInAnimation(
            delay: widget.delay,
            child: _buildCard(context),
          )
          : _buildCard(context),
    );
  }
}
