import 'package:domofit/Models/configuration.dart';
import 'package:domofit/Providers/data_base_provider.dart';
import 'package:sqflite/sqflite.dart';

class ConfigurationsManager {
  static final ConfigurationsManager instance = ConfigurationsManager._();

  ConfigurationsManager._();

  initDB(Database db) async {
    await db.execute("CREATE TABLE Configuration ("
        "id INTEGER PRIMARY KEY,"
        "bluetoothName TEXT,"
        "volumeRemote INTEGER,"
        "numericalRemote INTEGER,"
        "directionalRemote INTEGER,"
        "colorRemote INTEGER,"
        "playerRemote INTEGER"
        ")");
  }

  Future<Configuration?> getConfiguration() async {
    final db = await DBProvider.instance.database;
    var res = await db.query("Configuration");
    List<Configuration> list = res.isNotEmpty ? res.map((c) => Configuration.fromMap(c)).toList() : [];

    return list.isNotEmpty ? list.first : null;
  }

  Future<Configuration> updateConfiguration(Configuration configuration) async {
    if (await getConfiguration() == null) {
      return _newConfiguration(configuration);
    } else {
      return _updateConfiguration(configuration);
    }
  }

  Future<Configuration> _newConfiguration(Configuration configuration) async {
    final db = await DBProvider.instance.database;
    configuration.id = await db.insert("Configuration", configuration.toMap());

    return configuration;
  }

  Future<Configuration> _updateConfiguration(Configuration configuration) async {
    final db = await DBProvider.instance.database;
    await db.update(
        "Configuration", configuration.toMap(),
        where: "id = ?", whereArgs: [configuration.id]
    );

    return configuration;
  }
}