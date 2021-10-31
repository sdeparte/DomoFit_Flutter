import 'dart:math' as math;

import 'package:domofit/Managers/configurations_manager.dart';
import 'package:domofit/Models/configuration.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../control_widget.dart';
import '../remote_widget.dart';

class PlayerRemoteWidget extends StatefulWidget {
  static const remotePartIdent = "player";

  static const buttonNextIdent = "next";
  static const buttonPreviousIdent = "previous";

  static const buttonRecIdent = "rec";
  static const buttonStopIdent = "stop";

  static const buttonPauseIdent = "pause";
  static const buttonPlayIdent = "play";

  final RemoteWidgetState remoteWidgetState;
  final ControlWidgetState controlWidgetState;
  final MainRouteState mainRouteState;
  final Configuration configuration;

  PlayerRemoteWidget({Key? key, required this.remoteWidgetState}) :
    controlWidgetState = remoteWidgetState.widget.controlWidgetState,
    mainRouteState = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState,
    configuration = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState.configuration,
    super(key: key);

  @override
  _PlayerRemoteWidgetState createState() => _PlayerRemoteWidgetState();
}

class _PlayerRemoteWidgetState extends State<PlayerRemoteWidget> {
  Future<void> switchPlayerRemote(bool state) async {
    widget.mainRouteState.setState(() {
      widget.configuration.playerRemote = state ? 1 : 0;
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
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: const Icon(Icons.double_arrow_rounded),
                  ),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(PlayerRemoteWidget.remotePartIdent, PlayerRemoteWidget.buttonPreviousIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.pause_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(PlayerRemoteWidget.remotePartIdent, PlayerRemoteWidget.buttonPauseIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.double_arrow_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(PlayerRemoteWidget.remotePartIdent, PlayerRemoteWidget.buttonNextIdent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.red,
                  child: const Icon(Icons.fiber_manual_record_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(PlayerRemoteWidget.remotePartIdent, PlayerRemoteWidget.buttonRecIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.play_arrow_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(PlayerRemoteWidget.remotePartIdent, PlayerRemoteWidget.buttonPlayIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.stop_rounded),
                  onPressed:widget.remoteWidgetState.getButtonClickFunction(PlayerRemoteWidget.remotePartIdent, PlayerRemoteWidget.buttonStopIdent),
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
        opacity: widget.configuration.playerRemote == 1 ? 1 : 0.5,
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
              child: Text("Pavé multimédia :",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                activeColor: Colors.lightBlue,
                value: widget.configuration.playerRemote == 1,
                onChanged: (state) {
                  switchPlayerRemote(state);
                },
              ),
            ),
          ],
        ),
      );
    } else if (widget.configuration.playerRemote != 1) {
      remoteWidget = const SizedBox();
    }

    return Padding(
      padding: widget.configuration.playerRemote == 1 || widget.controlWidgetState.isEditModeInstant ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
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