import 'dart:async';

import 'package:domofit/Models/button.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/circular_button.dart';
import 'package:domofit/Widgets/Popups/popup_header_widget.dart';
import 'package:domofit/Widgets/remote_widget.dart';
import 'package:flutter/material.dart';

import '../blinking_widget.dart';

class EditRemoteButtonPopup extends StatefulWidget {
  final Button button;
  final RemoteWidgetState remoteWidgetState;
  final MainRouteState mainRouteState;

  EditRemoteButtonPopup({Key? key,
    required this.button,
    required this.remoteWidgetState,
  }) : mainRouteState = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState, super(key: key);

  @override
  _EditRemoteButtonPopupState createState() => _EditRemoteButtonPopupState();
}

class _EditRemoteButtonPopupState extends State<EditRemoteButtonPopup> {
  late TextEditingController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.button.commande);
  }

  @override
  void dispose() {
    if (null != _timer && _timer!.isActive) {
      _timer!.cancel();
    }

    widget.mainRouteState.listeningEditButtonController = null;

    super.dispose();
  }

  void startBluetoothListening() {
    if (null != _timer && _timer!.isActive) {
      _timer!.cancel();
    }

    setState(() {
      widget.mainRouteState.listeningEditButtonController = _controller;
    });

    _timer = Timer(const Duration(milliseconds: 15000), () {
      setState(() {
        widget.mainRouteState.listeningEditButtonController = null;
      });
    });
  }

  void updateButton() {
    widget.button.commande = _controller.text;

    widget.remoteWidgetState.updateButton(widget.button);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5.0,
      contentPadding: const EdgeInsets.all(.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      content: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PopupHeaderWidget(
                primaryIcon: Icons.settings_remote_rounded,
                secondaryIcon: Icons.wifi_rounded,
                backgroundColor: Colors.lightBlue,
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    color: Colors.lightBlueAccent,
                    child: const Center(
                      child: Text(
                        "Modification du bouton",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                labelText: 'Commande infrarouge :',
                                prefixIcon: const Icon(Icons.settings_remote_rounded),
                              ),
                              autofocus: false,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Appuyez sur le bouton ci-contre pour lancer une écoute infrarouge de 15 secondes.",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CircularButton(
                                    elevation: 2.0,
                                    diameter: 40,
                                    backgroundColor: null != widget.mainRouteState.listeningEditButtonController ? Colors.lightBlue : Colors.white,
                                    splashColor: null != widget.mainRouteState.listeningEditButtonController ? Colors.white : Colors.lightBlue,
                                    child: null != widget.mainRouteState.listeningEditButtonController
                                      ? const BlinkingWidget(child: Icon(Icons.hearing_rounded, color: Colors.white))
                                      : const Icon( Icons.hearing_rounded, color: Colors.lightBlue),
                                    onPressed: startBluetoothListening,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: const [
                                Icon(Icons.info_outline_rounded),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    "Lors de l'écoute, vous pouvez appuyer sur le bouton de votre télécomande pour réaliser une configuration automatiquement.",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 12,
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              textStyle: const TextStyle(
                                  color: Colors.white
                              ),
                              primary: SdColors.orange,
                              padding: const EdgeInsets.all(20.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: const BorderSide(color: Colors.transparent)
                              ),
                            ),
                            child: const Text("Annuler"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              textStyle: const TextStyle(
                                  color: Colors.white
                              ),
                              primary: Colors.lightBlue,
                              padding: const EdgeInsets.all(20.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: const BorderSide(color: Colors.transparent)
                              ),
                            ),
                            child: const Text("Valider"),
                            onPressed: updateButton,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}