import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:domofit/Managers/configurations_manager.dart';
import 'package:domofit/Managers/connexions_manager.dart';
import 'package:domofit/Models/configuration.dart';
import 'package:domofit/Models/connexion.dart';
import 'package:domofit/Tools/Animations/fade_in_and_translate_y_animation.dart';
import 'package:domofit/Tools/Animations/height_animation.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/blinking_widget.dart';
import 'package:domofit/Widgets/control_widget.dart';
import 'package:domofit/Widgets/light_widget.dart';
import 'package:domofit/Widgets/shortcuts_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import 'package:domofit/main.dart';
import 'device_search_route.dart';

class MainRoute extends StatefulWidget {
  final MyAppState myApp;
  final String? ipAddress;

  const MainRoute({Key? key,
    required this.myApp,
    this.ipAddress}) : super(key: key);

  @override
  MainRouteState createState() => MainRouteState();
}

class MainRouteState extends State<MainRoute> {
  Configuration configuration = Configuration();

  bool isForceOn = false;
  late AnimateIconController iconAnimationControllerLight;
  late AnimationController animationLightController;

  TextEditingController? listeningEditButtonController;

  IOWebSocketChannel? _channel;
  bool isConnecting = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();

    _connectToServer();
    _getConfiguration();
  }

  @override
  void dispose() {
    _channel?.sink.close();

    super.dispose();
  }

  void _connectToServer() async {
    if (widget.ipAddress != null) {
      setState(() {
        isConnecting = true;
      });

      await ConnexionsManager.instance.updateConnexion(Connexion(ipAddress: widget.ipAddress as String, date: DateTime.now()));

      WebSocket.connect('ws://' + (widget.ipAddress as String) + "/ws").then((ws) {
        setState(() {
          isConnecting = false;
          isConnected = true;
        });

        _channel = IOWebSocketChannel(ws);

        _channel?.stream.listen(
          (dynamic message) {
            _onDataReceived(message);
          },
          onDone: _onDisconnected,
          onError: (dynamic error) => _onDisconnected(),
        );

        _channel?.sink.add("ALW STATE");
        _channel?.sink.add("LUM STATE");
      }).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            if (mounted) {
              setState(() {
                isConnecting = false;
                isConnected = false;
              });
            }
          }
      );
    }
  }

  void _onDisconnected() async {
    if (_channel?.stream != null) {
      _channel?.sink.close();
    }

    setState(() {
      isConnected = false;
    });

    _connectToServer();
  }

  void _getConfiguration() async {
    Configuration? configuration = await ConfigurationsManager.instance.getConfiguration();

    if (null != configuration) {
      setState(() {
        this.configuration = configuration;
      });
    }
  }

  void _onDataReceived(String message) {
    RegExp exp = RegExp(r"([A-Z.]{3}) (.*)");
    RegExpMatch? matche = exp.firstMatch(message);

    if (matche != null) {
      if (matche.group(1) == "ALW") {
        if (matche.group(2) == "1") {
          setState(() {
            isForceOn = true;
          });

          iconAnimationControllerLight.animateToEnd();
        } else {
          setState(() {
            isForceOn = false;
          });

          iconAnimationControllerLight.animateToStart();
        }
      } else if (matche.group(1) == "LUM") {
        if (matche.group(2) == "1") {
          animationLightController.forward();
        } else {
          animationLightController.reverse();
        }
      } else if (matche.group(1) != "UNK") {
        if (null != listeningEditButtonController) {
          setState(() {
            listeningEditButtonController?.text = matche.group(0) as String;
          });
        }
      }
    }
  }

  void sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty) {
      _channel?.sink.add(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth == 0 || screenHeight == 0) {
      return const SizedBox();
    }

    bool isButton = !isConnecting && !isConnected && widget.ipAddress != null;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => DiscoveryRoute(myApp: widget.myApp),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: SdColors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.lightBlue,
          title: const Text("My DomoFit"),
          actions: <Widget>[
            FloatingActionButton(
              heroTag: "connexionSetting",
              backgroundColor: isButton ? Colors.white : Colors.transparent,
              splashColor: isButton ? Colors.lightBlue : null,
              elevation: 0,
              mini: true,
              child: isConnecting
                  ? BlinkingWidget(
                      child: Icon(
                        Icons.wifi,
                        color: isButton ? Colors.lightBlue : Colors.white,
                      ),
                    )
                  : Icon(
                      isConnected ? Icons.wifi : Icons.wifi_off,
                      color: isButton ? Colors.lightBlue : Colors.white,
                    ),
              onPressed: isButton ? _connectToServer : null,
            ),
          ],
        ),
        body: Stack(
          children: [
            Material(
              elevation: 2.0,
              child: HeightAnimation(
                delay: 0,
                from: screenHeight / 2.5 - 90,
                to: 47,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.lightBlue, Colors.lightBlueAccent],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  FadeInAndTranslateYAnimation(
                    delay: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: LightWidget(mainRouteState: this),
                    ),
                  ),
                  FadeInAndTranslateYAnimation(
                    delay: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ControlWidget(mainRouteState: this),
                    ),
                  ),
                  const FadeInAndTranslateYAnimation(
                    delay: 2,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ShortcutsWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}