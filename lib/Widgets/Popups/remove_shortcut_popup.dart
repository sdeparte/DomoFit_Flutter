import 'package:domofit/Models/shortcut.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Popups/popup_header_widget.dart';
import 'package:domofit/Widgets/shortcuts_widget.dart';
import 'package:flutter/material.dart';

class RemoveShortcutPopup extends StatefulWidget {
  final ShortcutsWidgetState shortcutsWidgetState;
  final Shortcut shortcut;

  const RemoveShortcutPopup({
    Key? key,
    required this.shortcutsWidgetState,
    required this.shortcut,
  }) : super(key: key);

  @override
  _RemoveShortcutPopupState createState() => _RemoveShortcutPopupState();
}

class _RemoveShortcutPopupState extends State<RemoveShortcutPopup> {
  void deleteShortcut() {
    widget.shortcutsWidgetState.deleteShortcut(widget.shortcut);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String message = "Êtes-vous certain de vouloir supprimer cet accès rapide ?";

    if (!["", null].contains(widget.shortcut.appInformations!['app_name'])) {
      message = "Êtes-vous certain de vouloir supprimer l'accès rapide vers \"" + (widget.shortcut.appInformations!['app_name'] as String) + "\" ?";
    }

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
              const PopupHeaderWidget(
                primaryIcon: Icons.apps_rounded,
                secondaryIcon: Icons.delete_rounded,
                backgroundColor: SdColors.red,
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    color: SdColors.redAccent,
                    child: const Center(
                      child: Text(
                        "Supprimer un \"Accès rapide\"",
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
                      message,
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
                              primary: SdColors.red,
                              padding: const EdgeInsets.all(20.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: const BorderSide(color: Colors.transparent)
                              ),
                            ),
                            child: const Text("Supprimer"),
                            onPressed: () {
                              deleteShortcut();
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