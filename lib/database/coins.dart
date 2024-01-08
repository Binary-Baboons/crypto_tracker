import 'package:crypto_tracker/database/base.dart';

class CoinsStore {
  CoinsStore(this.baseDatabase);

  static const String tableName = "coin";
  static const schema = "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, uuid TEXT UNIQUE)";

  BaseDatabase baseDatabase;

  Future<List<String>> getFavoriteCoins() async {
    List<Map> result = await (await baseDatabase.database).rawQuery('SELECT uuid FROM $tableName');
    return result.map((e) => e["uuid"] as String).toList();
  }

  Future<int> addFavoriteCoin(String uuid) async {
    return await (await baseDatabase.database).rawInsert('INSERT INTO $tableName VALUES(NULL, ?)', [uuid]);
  }

  Future<int> deleteFavoriteCoin(String uuid) async {
    return await (await baseDatabase.database).rawInsert('DELETE FROM $tableName WHERE uuid=?', [uuid]);
  }
}