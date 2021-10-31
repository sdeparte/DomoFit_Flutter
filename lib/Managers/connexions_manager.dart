import 'package:domofit/Models/connexion.dart';
import 'package:domofit/Providers/data_base_provider.dart';
import 'package:sqflite/sqflite.dart';

class ConnexionsManager {
  static final ConnexionsManager instance = ConnexionsManager._();

  ConnexionsManager._();

  initDB(Database db) async {
    await db.execute("CREATE TABLE Connexion ("
        "ipAddress TEXT,"
        "date TEXT"
        ")");
  }

  Future<List<Connexion>> getAllConnexions() async {
    final db = await DBProvider.instance.database;
    var res = await db.query("Connexion");
    List<Connexion> list = res.isNotEmpty ? res.map((c) => Connexion.fromMap(c)).toList() : [];

    return list;
  }

  Future<Connexion?> getConnexion(Connexion connexion) async {
    final db = await DBProvider.instance.database;
    var res = await db.query(
        "Connexion",
        where: "ipAddress = ?",
        whereArgs: [connexion.ipAddress],
    );
    List<Connexion> list = res.isNotEmpty ? res.map((c) => Connexion.fromMap(c)).toList() : [];

    return list.isNotEmpty ? list.first : null;
  }

  Future<Connexion> updateConnexion(Connexion connexion) async {
    if (await getConnexion(connexion) == null) {
      return _newConnexion(connexion);
    } else {
      return _updateConnexion(connexion);
    }
  }

  Future<Connexion> _newConnexion(Connexion connexion) async {
    final db = await DBProvider.instance.database;
    await db.insert("Connexion", connexion.toMap());

    return connexion;
  }

  Future<Connexion> _updateConnexion(Connexion connexion) async {
    final db = await DBProvider.instance.database;
    await db.update(
        "Connexion",
        connexion.toMap(),
        where: "ipAddress = ?",
        whereArgs: [connexion.ipAddress]
    );

    return connexion;
  }
}