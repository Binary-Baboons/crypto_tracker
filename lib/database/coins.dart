import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CoinsDatabase {
  CoinsDatabase() {
    initDatabase();
  }

  final String databaseName = "crypto_tracker";
  final String tableName = "coin";
  late Database database;

  Future<void> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$databaseName.database');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE $tableName (id INTEGER PRIMARY KEY, uuid TEXT UNIQUE)');
    });
  }

  void closeDatabase() async {
    await database.close();
  }

  Future<List<String>> getFavoriteCoins() async {
    List<Map> result = await database.rawQuery('SELECT uuid FROM $tableName');
    return result.map((e) => e["uuid"] as String).toList();
  }

  Future<int> addFavoriteCoin(String uuid) async {
    return await database.rawInsert('INSERT INTO $tableName VALUES(NULL, ?)', [uuid]);
  }

  Future<int> deleteFavoriteCoin(String uuid) async {
    return await database.rawInsert('DELETE FROM $tableName WHERE uuid=?', [uuid]);
  }
}
