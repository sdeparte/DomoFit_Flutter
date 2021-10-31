import 'dart:io';

import 'package:domofit/Managers/buttons_manager.dart';
import 'package:domofit/Managers/configurations_manager.dart';
import 'package:domofit/Managers/connexions_manager.dart';
import 'package:domofit/Managers/shortcuts_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final DBProvider instance = DBProvider._();
  static Database? _database;

  DBProvider._();

  Future <Database> get database async{
    return _database ??= await initDB();
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        ConfigurationsManager.instance.initDB(db);
        ConnexionsManager.instance.initDB(db);
        ShortcutsManager.instance.initDB(db);
        ButtonsManager.instance.initDB(db);
      }
    );
  }
}