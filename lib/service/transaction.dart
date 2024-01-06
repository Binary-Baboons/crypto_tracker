import 'package:crypto_tracker/database/transaction.dart';

import '../model/transaction.dart';
import '../model/transaction_grouping.dart';

class TransactionService {
  TransactionService(this.transactionStore);

  TransactionStore transactionStore;

  Future<List<Transaction>> getTransactions() async {
    return await transactionStore.getTransactions();
  }

  Future<List<TransactionGrouping>> getTransactionGroupings() async {
    return await transactionStore.getTransactionGroupings();
  }

  Future<int> addTransaction(Transaction transaction) async {
    return await transactionStore.addTransaction(transaction);
  }

  Future<int> deleteTransaction(String transactionId) async {
    return await transactionStore.deleteTransaction(transactionId);
  }
}