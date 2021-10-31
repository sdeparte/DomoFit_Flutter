import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/circular_button.dart';
import 'package:domofit/Widgets/Buttons/rounded_button.dart';
import 'package:domofit/Widgets/remote_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../control_widget.dart';

class PowerRemoteWidget extends StatefulWidget {
  static const remotePartIdent = "power";

  static const buttonPowerIdent = "power";
  static const buttonFunctionIdent = "function";

  final RemoteWidgetState remoteWidgetState;
  final ControlWidgetState controlWidgetState;

  PowerRemoteWidget({Key? key, required this.remoteWidgetState
  }) : controlWidgetState = remoteWidgetState.widget.controlWidgetState, super(key: key);

  @override
  _PowerRemoteWidgetState createState() => _PowerRemoteWidgetState();
}

class _PowerRemoteWidgetState extends State<PowerRemoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: CircularButton(
                  backgroundColor: SdColors.red,
                  textColor: Colors.white,
                  splashColor: Colors.white,
                  child: const Icon(Icons.power_settings_new_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(PowerRemoteWidget.remotePartIdent, PowerRemoteWidget.buttonPowerIdent),
                ),
              ),
              const Expanded(
                  child: SizedBox()
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("Function"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(PowerRemoteWidget.remotePartIdent, PowerRemoteWidget.buttonFunctionIdent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}