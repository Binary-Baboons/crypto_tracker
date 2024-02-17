import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/database/transaction.dart';
import 'package:crypto_tracker/service/coins.dart';

import '../model/coin.dart';
import '../model/transaction.dart';
import '../model/transaction_grouping.dart';

class TransactionService {
  TransactionService(this.transactionStore, this.coinsService);

  TransactionStore transactionStore;
  CoinsService coinsService;

  Future<List<Transaction>> getTransactions(String coinUuid) async {
    var transactions = await transactionStore.getTransactions(coinUuid);
    transactions.forEach((t) { t.priceForAmount = t.priceForAmount.abs(); t.amount = t.amount.abs();});
    return transactions;
  }

  Future<List<TransactionGrouping>> getTransactionGroupings() async {
    List<TransactionGrouping> groupings =
        await transactionStore.getTransactionGroupings();
    List<Coin> coins = await coinsService.getCoins(
        CoinsRequestData(uuids: groupings.map((g) => g.coinUuid).toList()), DefaultConfig.referenceCurrency);

    for (var group in groupings) {
      Coin coin = coins.where((c) => c.uuid == group.coinUuid).first;

      group.setAndCalculateForCoin = coin;
    }

    groupings.sort((a, b) => b.groupingValue!.compareTo(a.groupingValue!));
    return groupings;
  }

  Future<int> addTransaction(Transaction transaction) async {
    if (transaction.type == TransactionType.withdraw) {
      transaction.amount = transaction.amount * (-1);
      transaction.priceForAmount = transaction.priceForAmount * (-1);
    }

    return await transactionStore.addTransaction(transaction);
  }

  Future<int> deleteTransaction(String transactionId) async {
    return await transactionStore.deleteTransaction(transactionId);
  }
}
