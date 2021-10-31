import 'package:domofit/Managers/configurations_manager.dart';
import 'package:domofit/Models/configuration.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../control_widget.dart';
import '../remote_widget.dart';

class VolumeRemoteWidget extends StatefulWidget {
  static const remotePartIdent = "volume";

  static const buttonVolumeUpIdent = "volumeUp";
  static const buttonVolumeDownIdent = "volumeDown";

  static const buttonMuteIdent = "mute";
  static const buttonHomeIdent = "home";

  static const buttonProgramUpIdent = "programUp";
  static const buttonProgramDownIdent = "programDown";

  final ControlWidgetState controlWidgetState;
  final RemoteWidgetState remoteWidgetState;
  final MainRouteState mainRouteState;
  final Configuration configuration;

  VolumeRemoteWidget({Key? key, required this.remoteWidgetState}) :
    controlWidgetState = remoteWidgetState.widget.controlWidgetState,
    mainRouteState = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState,
    configuration = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState.configuration,
    super(key: key);

  @override
  _VolumeRemoteWidgetState createState() => _VolumeRemoteWidgetState();
}

class _VolumeRemoteWidgetState extends State<VolumeRemoteWidget> {
  Future<void> switchVolumeRemote(bool state) async {
    widget.mainRouteState.setState(() {
      widget.configuration.volumeRemote = state ? 1 : 0;
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
                  width: 50,
                  height: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.add_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(VolumeRemoteWidget.remotePartIdent, VolumeRemoteWidget.buttonVolumeUpIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.volume_off_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(VolumeRemoteWidget.remotePartIdent, VolumeRemoteWidget.buttonMuteIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 50,
                  height: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.arrow_upward_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(VolumeRemoteWidget.remotePartIdent, VolumeRemoteWidget.buttonProgramUpIdent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: RoundedButton(
                  width: 50,
                  height: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.remove_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(VolumeRemoteWidget.remotePartIdent, VolumeRemoteWidget.buttonVolumeDownIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.home_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(VolumeRemoteWidget.remotePartIdent, VolumeRemoteWidget.buttonHomeIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 50,
                  height: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.arrow_downward_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(VolumeRemoteWidget.remotePartIdent, VolumeRemoteWidget.buttonProgramDownIdent),
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
        opacity: widget.configuration.volumeRemote == 1 ? 1 : 0.5,
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
              child: Text("Programme et volume :",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                activeColor: Colors.lightBlue,
                value: widget.configuration.volumeRemote == 1,
                onChanged: (state) {
                  switchVolumeRemote(state);
                },
              ),
            ),
          ],
        ),
      );
    } else if (widget.configuration.volumeRemote != 1) {
      remoteWidget = const SizedBox();
    }

    return Padding(
      padding: widget.configuration.volumeRemote == 1 || widget.controlWidgetState.isEditModeInstant ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
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