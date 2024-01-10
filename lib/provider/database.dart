import 'package:crypto_tracker/database/base.dart';
import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/database/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseDatabaseProvider = Provider<BaseDatabase>((ref) {
  return BaseDatabase();
});

final coinsStoreProvider = Provider<CoinsStore>((ref) {
  var baseDatabase = ref.read(baseDatabaseProvider);
  return CoinsStore(baseDatabase);
});

final transactionStoreProvider = Provider<TransactionStore>((ref) {
  var baseDatabase = ref.read(baseDatabaseProvider);
  return TransactionStore(baseDatabase);
});