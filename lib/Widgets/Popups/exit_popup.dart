import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Popups/popup_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitPopup extends StatefulWidget {
  const ExitPopup({Key? key}) : super(key: key);

  @override
  _ExitPopupState createState() => _ExitPopupState();
}

class _ExitPopupState extends State<ExitPopup> {
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
                primaryIcon: Icons.directions_run_rounded,
                secondaryIcon: Icons.close_rounded,
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
                        "Quitter l'application",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Êtes-vous certain de vouloir quitter l'application \"My DomoFit\" ?",
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
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
                            child: const Text("Rester"),
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
                            child: const Text("Quitter"),
                            onPressed: () {
                              SystemNavigator.pop();
                            },
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