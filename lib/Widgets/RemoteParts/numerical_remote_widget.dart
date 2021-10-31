import 'package:domofit/Managers/configurations_manager.dart';
import 'package:domofit/Models/configuration.dart';
import 'package:domofit/Routes/main_route.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../control_widget.dart';
import '../remote_widget.dart';

class NumericalRemoteWidget extends StatefulWidget {
  static const remotePartIdent = "numerical";

  static const buttonZeroIdent = "zero";
  static const buttonOneIdent = "one";
  static const buttonTwoIdent = "two";
  static const buttonThreeIdent = "three";
  static const buttonFourIdent = "four";
  static const buttonFiveIdent = "five";
  static const buttonSixIdent = "six";
  static const buttonSevenIdent = "seven";
  static const buttonEightIdent = "eight";
  static const buttonNineIdent = "nine";

  static const buttonCustum1Ident = "custum1";
  static const buttonCustum2Ident = "custum2";

  final RemoteWidgetState remoteWidgetState;
  final ControlWidgetState controlWidgetState;
  final MainRouteState mainRouteState;
  final Configuration configuration;

  NumericalRemoteWidget({Key? key, required this.remoteWidgetState}) :
    controlWidgetState = remoteWidgetState.widget.controlWidgetState,
    mainRouteState = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState,
    configuration = remoteWidgetState.widget.controlWidgetState.widget.mainRouteState.configuration,
    super(key: key);

  @override
  _NumericalRemoteWidgetState createState() => _NumericalRemoteWidgetState();
}

class _NumericalRemoteWidgetState extends State<NumericalRemoteWidget> {
  Future<void> switchNumericalRemote(bool state) async {
    widget.mainRouteState.setState(() {
      widget.configuration.numericalRemote = state ? 1 : 0;
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
                  child: const Text("1"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonOneIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("2"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonTwoIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("3"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonThreeIdent),
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
                  textColor: SdColors.black,
                  child: const Text("4"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonFourIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("5"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonFiveIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("6"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonSixIdent),
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
                  textColor: SdColors.black,
                  child: const Text("7"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonSevenIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("8"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonEightIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("9"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonNineIdent),
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
                  textColor: SdColors.black,
                  child: const Text("P1"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonCustum1Ident),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("0"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonZeroIdent),
                ),
              ),
              Expanded(
                child: RoundedButton(
                  width: 80,
                  backgroundColor: Colors.white,
                  textColor: SdColors.black,
                  child: const Text("P2"),
                  onPressed: widget.remoteWidgetState.getButtonClickFunction(NumericalRemoteWidget.remotePartIdent, NumericalRemoteWidget.buttonCustum2Ident),
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
        opacity: widget.configuration.numericalRemote == 1 ? 1 : 0.5,
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
              child: Text("Pavé numérique :",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                activeColor: Colors.lightBlue,
                value: widget.configuration.numericalRemote == 1,
                onChanged: (state) {
                  switchNumericalRemote(state);
                },
              ),
            ),
          ],
        ),
      );
    } else if (widget.configuration.numericalRemote != 1) {
      remoteWidget = const SizedBox();
    }

    return Padding(
      padding: widget.configuration.numericalRemote == 1 || widget.controlWidgetState.isEditModeInstant ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0),
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