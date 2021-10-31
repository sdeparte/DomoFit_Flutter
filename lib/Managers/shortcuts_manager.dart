import 'package:domofit/Models/shortcut.dart';
import 'package:domofit/Providers/data_base_provider.dart';
import 'package:sqflite/sqflite.dart';

class ShortcutsManager {
  static final ShortcutsManager instance = ShortcutsManager._();

  ShortcutsManager._();

  initDB(Database db) async {
    await db.execute("CREATE TABLE Shortcut ("
        "id INTEGER PRIMARY KEY,"
        "packageName TEXT,"
        "shortcutName TEXT"
        ")");
  }

  Future<List<Shortcut>> getAllShortcuts() async {
    final db = await DBProvider.instance.database;
    var res = await db.query("Shortcut");
    List<Shortcut> list = res.isNotEmpty ? res.map((c) => Shortcut.fromMap(c)).toList() : [];

    return list;
  }

  Future<Shortcut> insertShortcut(Shortcut shortcut) async {
    final db = await DBProvider.instance.database;
    shortcut.id = await db.insert("Shortcut", shortcut.toMap());

    return shortcut;
  }

  Future<Shortcut> updateShortcut(Shortcut shortcut) async {
    final db = await DBProvider.instance.database;
    await db.update(
        "Shortcut", shortcut.toMap(),
        where: "id = ?", whereArgs: [shortcut.id]
    );

    return shortcut;
  }

  Future<void> deleteShortcut(Shortcut shortcut) async {
    final db = await DBProvider.instance.database;
    db.delete("Shortcut", where: "id = ?", whereArgs: [shortcut.id]);
  }
}