import 'dart:developer';
import 'dart:io';

import 'package:domofit/Tools/sd_colors.dart';
import 'package:domofit/Widgets/Buttons/shortcut_button.dart';
import 'package:domofit/Widgets/Popups/popup_header_widget.dart';
import 'package:domofit/Widgets/shortcuts_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddShortcutPopup extends StatefulWidget {
  final ShortcutsWidgetState shortcutsWidgetState;

  const AddShortcutPopup({Key? key, required this.shortcutsWidgetState}) : super(key: key);

  @override
  _AddShortcutPopupState createState() => _AddShortcutPopupState();
}

class _AddShortcutPopupState extends State<AddShortcutPopup> {
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _shortcutNameController = TextEditingController();
  bool _appAvailable = false;

  Future<List<Map<String, String?>>> getInstalledAppsByQuery(String query) async {
    if (!Platform.isAndroid) {
      return <Map<String, String>>[];
    }

    return await AppAvailability.getInstalledAppsByQuery(query, 10);
  }

  Future<void> checkAppAvailability(String packageName) async {
    Map<String, String?>? _appInfo;

    try {
      _appInfo = await AppAvailability.checkAvailability(packageName);
    } on PlatformException catch(e) {
      log(e.message ?? "PlatformException throw");
    }

    bool appAvailable = _appInfo?.isNotEmpty ?? false;

    if (Platform.isAndroid && appAvailable) {
      appAvailable = await AppAvailability.isAppEnabled(packageName) ?? false;
    }

    setState(() {
      _appAvailable = appAvailable;
    });
  }

  void insertShortcut() {
    widget.shortcutsWidgetState.insertShortcut(
      _packageNameController.text,
      _shortcutNameController.text
    );

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
              const PopupHeaderWidget(
                primaryIcon: Icons.apps_rounded,
                secondaryIcon: Icons.add_rounded,
                backgroundColor: SdColors.green,
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    color: SdColors.greenAccent,
                    child: const Center(
                      child: Text(
                        "Ajouter un \"Accès rapide\"",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        TypeAheadField(
                          suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                          ),
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _packageNameController,
                            onChanged: (packageName) {
                              checkAppAvailability(packageName);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              labelText: 'PackageName / BundleId :',
                              prefixIcon: const Icon(Icons.apps_rounded),
                              suffixIcon: _appAvailable
                                  ? const Icon(Icons.check_rounded, color: SdColors.green)
                                  : const Icon(Icons.close_rounded, color: SdColors.red),
                            ),
                            autofocus: false,
                          ),
                          hideOnLoading: true,
                          hideOnEmpty: true,
                          suggestionsCallback: (query) async {
                            return await getInstalledAppsByQuery(query);
                          },
                          itemBuilder: (context, Map<String, String?> app) {
                            return Column(
                              children: [
                                const Divider(),
                                ListTile(
                                  key: ValueKey(app["package_name"] as String),
                                  contentPadding: const EdgeInsets.only(left: 2.0, right: 10.0),
                                  leading: ShortcutButton(
                                    logoBase64: app["app_icon"] as String,
                                    small: true,
                                    backgroundColor: SdColors.blackAccent,
                                    pictoBackgroundColor: SdColors.black,
                                    pictoIcon: Icons.touch_app_outlined,
                                    pictoSize: 15,
                                  ),
                                  title: Text(app['app_name'] as String),
                                  subtitle: Text(
                                    app['package_name'] as String,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          onSuggestionSelected: (Map<String, String?> app) {
                            _packageNameController.text = app["package_name"] as String;

                            if (_shortcutNameController.text.isEmpty) {
                              _shortcutNameController.text = app["app_name"] as String;
                            }

                            checkAppAvailability(app["package_name"] as String);
                          },
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _shortcutNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: 'Nom de l\'accès rapide :',
                            prefixIcon: const Icon(Icons.text_fields_rounded),
                          ),
                          autofocus: false,
                        ),
                      ],
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
                              primary: _appAvailable ? SdColors.green : SdColors.greyBackAccent,
                              padding: const EdgeInsets.all(20.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: const BorderSide(color: Colors.transparent)
                              ),
                            ),
                            child: const Text("Valider"),
                            onPressed: _appAvailable ? insertShortcut : () {},
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