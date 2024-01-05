import 'package:crypto_tracker/database/base.dart';

class CoinsStore extends BaseDatabase {
  static const String tableName = "coin";
  static const schema = "CREATE TABLE $tableName (id INTEGER PRIMARY KEY, uuid TEXT UNIQUE)";

  CoinsStore() : super.singleton();

  Future<List<String>> getFavoriteCoins() async {
    List<Map> result = await (await database).rawQuery('SELECT uuid FROM $tableName');
    return result.map((e) => e["uuid"] as String).toList();
  }

  Future<int> addFavoriteCoin(String uuid) async {
    return await (await database).rawInsert('INSERT INTO $tableName VALUES(NULL, ?)', [uuid]);
  }

  Future<int> deleteFavoriteCoin(String uuid) async {
    return await (await database).rawInsert('DELETE FROM $tableName WHERE uuid=?', [uuid]);
  }
}