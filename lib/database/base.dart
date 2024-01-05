import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/database/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BaseDatabase {
  static final BaseDatabase _instance = BaseDatabase._internal();

  final String _databaseName = "cryptotracker";
  Database? _database;

  factory BaseDatabase() {
    return _instance;
  }
  BaseDatabase.singleton();

  BaseDatabase._internal() {
    _initDatabase();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$_databaseName.database');
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
