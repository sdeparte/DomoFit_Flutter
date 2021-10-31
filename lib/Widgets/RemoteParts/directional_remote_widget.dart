import 'package:domofit/Managers/configurations_manager.dart';
import 'package:domofit/Models/configuration.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/circular_button.dart';
import 'package:domofit/Widgets/Buttons/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../control_widget.dart';
import '../remote_widget.dart';

class DirectionalRemoteWidget extends StatefulWidget {
  static const remotePartIdent = "directional";

  static const buttonUpIdent = "up";
  static const buttonDowntIdent = "down";
  static const buttonLeftIdent = "left";
  static const buttonRightIdent = "right";

  static const buttonOkIdent = "ok";

  static const buttonMenuIdent = "menu";
  static const buttonGuideIdent = "guide";
  static const buttonBackIdent = "back";
  static const buttonExitIdent = "exit";

  final RemoteWidgetState remoteWidgetState;
  final ControlWidgetState controlWidgetState;
  final MainRouteState mainRouteState;
  final Configuration configuration;

  DirectionalRemoteWidget({Key? key, required this.remoteWidgetState}) :
    controlWidgetState = remoteWidgetState.widget.controlWidgetState,
    mainRouteState = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState,
    configuration = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState.configuration,
    super(key: key);

  @override
  _DirectionalRemoteWidgetState createState() => _DirectionalRemoteWidgetState();
}

class _DirectionalRemoteWidgetState extends State<DirectionalRemoteWidget> {
  Future<void> switchDirectionalRemote(bool state) async {
    widget.mainRouteState.setState(() {
      widget.configuration.directionalRemote = state ? 1 : 0;
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
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.menu_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonMenuIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 50,
                  height: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.arrow_upward_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonUpIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.menu_book_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonGuideIdent),
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
                  height: 50,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.arrow_back_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonLeftIdent),
                ),
              ),
              Expanded(
                child: CircularButton(
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("OK"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonOkIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  height: 50,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.arrow_forward_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonRightIdent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: RoundedButton(
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.subdirectory_arrow_left_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonBackIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 50,
                  height: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.arrow_downward_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonDowntIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Icon(Icons.exit_to_app_rounded),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(DirectionalRemoteWidget.remotePartIdent, DirectionalRemoteWidget.buttonExitIdent),
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
        opacity: widget.configuration.directionalRemote == 1 ? 1 : 0.5,
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
              child: Text("Croix directionnelle :",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                activeColor: Colors.lightBlue,
                value: widget.configuration.directionalRemote == 1,
                onChanged: (state) {
                  switchDirectionalRemote(state);
                },
              ),
            ),
          ],
        ),
      );
    } else if (widget.configuration.directionalRemote != 1) {
      remoteWidget = const SizedBox();
    }

    return Padding(
      padding: widget.configuration.directionalRemote == 1 || widget.controlWidgetState.isEditModeInstant ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
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