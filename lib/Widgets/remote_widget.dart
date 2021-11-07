import 'package:domofit/Managers/buttons_manager.dart';
import 'package:domofit/Models/button.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Widgets/RemoteParts/color_remote_widget.dart';
import 'package:domofit/Widgets/RemoteParts/directional_remote_widget.dart';
import 'package:domofit/Widgets/RemoteParts/numerical_remote_widget.dart';
import 'package:domofit/Widgets/RemoteParts/power_remote_widget.dart';
import 'package:domofit/Widgets/RemoteParts/volume_remote_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Popups/edit_remote_button_popup.dart';
import 'RemoteParts/player_remote_widget.dart';
import 'control_widget.dart';

class RemoteWidget extends StatefulWidget {
  final ControlWidgetState controlWidgetState;
  final MainRouteState mainRouteState;

  RemoteWidget({Key? key, required this.controlWidgetState
  }) : mainRouteState = controlWidgetState.widget.mainRouteState, super(key: key);

  @override
  RemoteWidgetState createState() => RemoteWidgetState();
}

class RemoteWidgetState extends State<RemoteWidget> {
  Map<String, dynamic> _buttonsMap = <String, dynamic>{};

  @override
  void initState() {
    super.initState();

    getAllButtons();
  }

  void getAllButtons() async {
    Map<String, dynamic> buttonsMap = <String, dynamic>{};
    List<Button> buttons = await ButtonsManager.instance.getAllButtons();

    for (var button in buttons) {
      if (buttonsMap.containsKey(button.remotePartIdent)) {
        buttonsMap[button.remotePartIdent][button.buttonIdent] = button;
      } else {
        Map<String, Button> buttonSubMap = {button.buttonIdent: button};
        buttonsMap[button.remotePartIdent] = buttonSubMap;
      }
    }

    setState(() {
      this._buttonsMap = buttonsMap;
    });
  }

  GestureTapCallback? getButtonClickFunction(String remotePartIdent, String buttonIdent) {
    if (widget.controlWidgetState.isEditModeInstant) {
      return () { showEditRemoteButtonDialog(remotePartIdent, buttonIdent); };
    } else {
      if (widget.mainRouteState.isConnected &&
          _buttonsMap.containsKey(remotePartIdent) &&
          _buttonsMap[remotePartIdent].containsKey(buttonIdent)
      ) {
        Button button = _buttonsMap[remotePartIdent][buttonIdent];

        if (!["", null].contains(button.commande)) {
          return () { widget.mainRouteState.sendMessage(button.commande); };
        }
      }
    }

    return null;
  }

  Future<void> updateButton(Button button) async {
    await ButtonsManager.instance.updateButton(button);

    if (_buttonsMap.containsKey(button.remotePartIdent)) {
      _buttonsMap[button.remotePartIdent][button.buttonIdent] = button;
    } else {
      Map<String, Button> buttonSubMap = {button.buttonIdent: button};
      _buttonsMap[button.remotePartIdent] = buttonSubMap;
    }
  }

  void showEditRemoteButtonDialog(String remotePartIdent, String buttonIdent) {
    Button button = Button(remotePartIdent: remotePartIdent, buttonIdent: buttonIdent, commande: '');

    if (_buttonsMap.containsKey(remotePartIdent) &&
        _buttonsMap[remotePartIdent].containsKey(buttonIdent)
    ) {
      button = _buttonsMap[remotePartIdent][buttonIdent];
    }

    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
              opacity: a1.value,
              child: EditRemoteButtonPopup(
                remoteWidgetState: this,
                button: button,
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
    return Column(
      children: <Widget>[
        PowerRemoteWidget(remoteWidgetState: this),
        VolumeRemoteWidget(remoteWidgetState: this),
        NumericalRemoteWidget(remoteWidgetState: this),
        DirectionalRemoteWidget(remoteWidgetState: this),
        ColorRemoteWidget(remoteWidgetState: this),
        PlayerRemoteWidget(remoteWidgetState: this),
      ],
    );
  }
}