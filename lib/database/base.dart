import 'dart:io';

import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/database/transaction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BaseDatabase {
  final String _databaseName = "cryptotracker";
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      databaseFactory = databaseFactoryFfi;
    }

    var databasesPath = await getDatabasesPath();
    bool cleanDb = bool.parse(dotenv.env["CLEAN_DB"]!);

    String path = join(databasesPath, '$_databaseName.database');
    if (cleanDb && await databaseExists(databasesPath)) {
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