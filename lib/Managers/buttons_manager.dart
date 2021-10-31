import 'package:domofit/Models/button.dart';
import 'package:domofit/Providers/data_base_provider.dart';
import 'package:sqflite/sqflite.dart';

class ButtonsManager {
  static final ButtonsManager instance = ButtonsManager._();

  ButtonsManager._();

  initDB(Database db) async {
    await db.execute("CREATE TABLE Button ("
        "remotePartIdent TEXT,"
        "buttonIdent TEXT,"
        "custumText TEXT,"
        "commande TEXT,"
        "UNIQUE(remotePartIdent, buttonIdent)"
        ")");
  }

  Future<List<Button>> getAllButtons() async {
    final db = await DBProvider.instance.database;
    var res = await db.query("Button");
    List<Button> list = res.isNotEmpty ? res.map((c) => Button.fromMap(c)).toList() : [];

    return list;
  }

  Future<Button?> getButton(Button button) async {
    final db = await DBProvider.instance.database;
    var res = await db.query(
        "Button",
        where: "remotePartIdent = ? AND buttonIdent = ?",
        whereArgs: [button.remotePartIdent, button.buttonIdent],
    );
    List<Button> list = res.isNotEmpty ? res.map((c) => Button.fromMap(c)).toList() : [];

    return list.isNotEmpty ? list.first : null;
  }

  Future<Button> updateButton(Button button) async {
    if (await getButton(button) == null) {
      return _newButton(button);
    } else {
      return _updateButton(button);
    }
  }

  Future<Button> _newButton(Button button) async {
    final db = await DBProvider.instance.database;
    await db.insert("Button", button.toMap());

    return button;
  }

  Future<Button> _updateButton(Button button) async {
    final db = await DBProvider.instance.database;
    await db.update(
        "Button",
        button.toMap(),
        where: "remotePartIdent = ? AND buttonIdent = ?",
        whereArgs: [button.remotePartIdent, button.buttonIdent]
    );

    return button;
  }
}