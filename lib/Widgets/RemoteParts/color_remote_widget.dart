import 'package:domofit/Managers/configurations_manager.dart';
import 'package:domofit/Models/configuration.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../control_widget.dart';
import '../remote_widget.dart';

class ColorRemoteWidget extends StatefulWidget {
  static const remotePartIdent = "color";

  static const buttonRedIdent = "red";
  static const buttonGreenIdent = "green";
  static const buttonYellowIdent = "yellow";
  static const buttonBlueIdent = "blue";

  final RemoteWidgetState remoteWidgetState;
  final ControlWidgetState controlWidgetState;
  final MainRouteState mainRouteState;
  final Configuration configuration;

  ColorRemoteWidget({Key? key, required this.remoteWidgetState}) :
    controlWidgetState = remoteWidgetState.widget.controlWidgetState,
    mainRouteState = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState,
    configuration = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState.configuration,
    super(key: key);

  @override
  _ColorRemoteWidgetState createState() => _ColorRemoteWidgetState();
}

class _ColorRemoteWidgetState extends State<ColorRemoteWidget> {
  Future<void> switchColorRemote(bool state) async {
    widget.mainRouteState.setState(() {
      widget.configuration.colorRemote = state ? 1 : 0;
    });

    await ConfigurationsManager.instance.updateConfiguration(widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    Widget remoteWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: RoundedButton(
                  backgroundColor: SdColors.red,
                  textColor: SdColors.black,
                  splashColor: Colors.white,
                  child: const Text(""),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(ColorRemoteWidget.remotePartIdent, ColorRemoteWidget.buttonRedIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  backgroundColor: SdColors.green,
                  textColor: SdColors.black,
                  splashColor: Colors.white,
                  child: const Text(""),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(ColorRemoteWidget.remotePartIdent, ColorRemoteWidget.buttonGreenIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  backgroundColor: Colors.yellow,
                  textColor: SdColors.black,
                  splashColor: Colors.white,
                  child: const Text(""),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(ColorRemoteWidget.remotePartIdent, ColorRemoteWidget.buttonYellowIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(ColorRemoteWidget.remotePartIdent, ColorRemoteWidget.buttonBlueIdent),
                  backgroundColor: Colors.lightBlue,
                  textColor: SdColors.black,
                  splashColor: Colors.white,
                  child: const Text(""),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    Widget configurationWidget = const SizedBox();

    if (widget.controlWidgetState.isEditModeInstant) {
      remoteWidget = Opacity(
        opacity: widget.configuration.colorRemote == 1 ? 1 : 0.5,
        child: remoteWidget,
      );

      configurationWidget = Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
          color: widget.controlWidgetState.isEditModeInstant ? SdColors.orange : Colors.transparent,
        ),
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Touches de couleurs :",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                activeColor: Colors.lightBlue,
                value: widget.configuration.colorRemote == 1,
                onChanged: (state) {
                  switchColorRemote(state);
                },
              ),
            ),
          ],
        ),
      );
    } else if (widget.configuration.colorRemote != 1) {
      remoteWidget = const SizedBox();
    }

    return Padding(
      padding: widget.configuration.colorRemote == 1 || widget.controlWidgetState.isEditModeInstant ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: widget.controlWidgetState.isEditModeInstant ? Colors.white.withOpacity(0.25) : Colors.transparent,
        ),
        child: Column(
          children: [
            configurationWidget,
            remoteWidget,
          ],
        ),
      ),
    );
  }
}