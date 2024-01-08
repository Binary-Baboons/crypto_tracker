import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/database/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BaseDatabase {
  final String _databaseName = "cryptotracker";
  final bool cleanStart = true;
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$_databaseName.database');
    if (cleanStart && await databaseExists(databasesPath)) {
      await deleteDatabase(path);
    }
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(CoinsStore.schema);
      await db.execute(TransactionStore.schema);
    });
  }

  void _closeDatabase() async {
    (await database).close();
  }
}