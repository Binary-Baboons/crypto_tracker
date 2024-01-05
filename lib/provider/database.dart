import 'package:crypto_tracker/database/base.dart';
import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/database/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinsStoreProvider = Provider<CoinsStore>((ref) {
  return CoinsStore();
});

final transactionStoreProvider = Provider<TransactionStore>((ref) {
  return TransactionStore();
});