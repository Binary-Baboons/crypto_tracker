import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/database/base.dart';
import 'package:crypto_tracker/model/transaction.dart';
import 'package:crypto_tracker/model/transaction_grouping.dart';

class TransactionStore extends BaseDatabase {
  static const String tableName = "crypto_transaction";
  static const schema = "CREATE TABLE IF NOT EXISTS $tableName "
      "(id INTEGER PRIMARY KEY, "
      "transactionId TEXT UNIQUE, "
      "dateTime INTEGER, "
      "coinUuid TEXT, "
      "type TEXT, "
      "amount REAL,"
      "priceForAmount REAL)";

  TransactionStore() : super.singleton();

  Future<List<Transaction>> getTransactions() async {
    List<Map> result =
        await (await database).rawQuery('SELECT * FROM $tableName;');
    return result
        .map((t) => Transaction(
            transactionId: t["transactionId"],
            DateTime.fromMillisecondsSinceEpoch(t["dateTime"]),
            t["coinUuid"],
            stringToEnum(t["type"]),
            t["amount"],
            t["priceForAmount"]))
        .toList();
  }

  Future<List<TransactionGrouping>> getTransactionGroupings() async {
    List<Map> result = await (await database).rawQuery(
        'SELECT coinUuid, SUM(amount) AS sumAmount, SUM(priceForAmount) / SUM(amount) AS averagePrice FROM $tableName GROUP BY coinUuid');
    return result
        .map((tg) => TransactionGrouping(
            tg['coinUuid'], tg['averagePrice'], tg['sumAmount']))
        .toList();
  }

  Future<int> addTransaction(Transaction transaction) async {
    return await (await database)
        .rawInsert('INSERT INTO $tableName VALUES(NULL, ?, ?, ?, ?, ?, ?)', [
      transaction.transactionId,
      transaction.dateTime.millisecondsSinceEpoch,
      transaction.coinUuid,
      transaction.type.getValueOnly,
      transaction.amount,
      transaction.priceForAmount
    ]);
  }

  Future<int> deleteTransaction(String transactionId) async {
    return await (await database).rawDelete(
        'DELETE FROM $tableName WHERE transactionId=?', [transactionId]);
  }

  TransactionType stringToEnum(String str) => TransactionType.values
      .firstWhere((e) => e.toString().split('.').last == str);
}
