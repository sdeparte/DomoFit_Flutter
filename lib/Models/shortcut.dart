import 'dart:convert';

import 'package:flutter/material.dart';

class Shortcut {
  int? id;

  String packageName;
  String shortcutName;
  Image? logoImage;

  Map<String, String?>? appInformations;

  Shortcut({
    this.id,
    required this.packageName,
    required this.shortcutName
  });

  void setAppInformations(Map<String, String?> appInformations) {
    this.appInformations = appInformations;

    if (!["", null].contains(appInformations["app_icon"])) {
      logoImage = Image.memory(base64.decode(appInformations["app_icon"] as String));
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'packageName': packageName,
      'shortcutName': shortcutName,
    };
  }

  static Shortcut fromMap(Map<String, dynamic> map) {
    return Shortcut(
      id: map['id'],
      packageName: map['packageName'],
      shortcutName: map['shortcutName'],
    );
  }
}