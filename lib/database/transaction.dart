import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/database/base.dart';
import 'package:crypto_tracker/model/transaction.dart';
import 'package:crypto_tracker/model/transaction_grouping.dart';

class TransactionStore {
  TransactionStore(this.baseDatabase);

  static const String tableName = "crypto_transaction";
  static const schema = "CREATE TABLE IF NOT EXISTS $tableName "
      "(id INTEGER PRIMARY KEY, "
      "transactionId TEXT UNIQUE, "
      "dateTime INTEGER, "
      "coinUuid TEXT, "
      "type TEXT, "
      "source TEXT, "
      "amount REAL,"
      "priceForAmount REAL)";

  BaseDatabase baseDatabase;

  Future<List<Transaction>> getTransactions(String coinUuid) async {
    List<Map> result = await (await baseDatabase.database)
        .rawQuery('SELECT * FROM $tableName WHERE coinUuid LIKE ?', [coinUuid]);
    return result
        .map((t) => Transaction(
            transactionId: t["transactionId"],
            DateTime.fromMillisecondsSinceEpoch(t["dateTime"]),
            t["coinUuid"],
            stringToType(t["type"]),
            stringToSource(t["source"]),
            t["amount"],
            t["priceForAmount"]))
        .toList();
  }

  Future<List<TransactionGrouping>> getTransactionGroupings() async {
    List<Map> result = await (await baseDatabase.database).rawQuery(
        'SELECT coinUuid, SUM(amount) AS sumAmount, SUM(priceForAmount) / SUM(amount) AS averagePrice FROM $tableName WHERE type NOT LIKE ? GROUP BY coinUuid',
        [TransactionType.fee.getValueOnly]);
    return result
        .map((tg) => TransactionGrouping(
            tg['coinUuid'], tg['averagePrice'], tg['sumAmount']))
        .toList();
  }

  Future<int> addTransaction(Transaction transaction) async {
    return await (await baseDatabase.database)
        .rawInsert('INSERT INTO $tableName VALUES(NULL, ?, ?, ?, ?, ?, ?, ?)', [
      transaction.transactionId,
      transaction.dateTime.millisecondsSinceEpoch,
      transaction.coinUuid,
      transaction.type.getValueOnly,
      transaction.source.getValueOnly,
      transaction.amount,
      transaction.priceForAmount
    ]);
  }

  Future<int> deleteTransaction(String transactionId) async {
    return await (await baseDatabase.database).rawDelete(
        'DELETE FROM $tableName WHERE transactionId=?', [transactionId]);
  }

  TransactionType stringToType(String str) => TransactionType.values
      .firstWhere((e) => e.toString().split('.').last == str);

  TransactionSource stringToSource(String str) => TransactionSource.values
      .firstWhere((e) => e.toString().split('.').last == str);
}
