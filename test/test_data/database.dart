import 'package:mockito/mockito.dart';

import '../service/coins_test.mocks.dart';
import '../service/transaction_test.mocks.dart';
import 'expected_data.dart';

MockCoinsStore mockCoinsStoreOk() {
  var db = MockCoinsStore();
  when(db.getFavoriteCoins()).thenAnswer((_) async { return [apiCoins[0].uuid];});
  when(db.addFavoriteCoin(any)).thenAnswer((_) async { return 1;});
  when(db.deleteFavoriteCoin(any)).thenAnswer((_) async { return 1;});
  return db;
}

MockTransactionStore mockTransactionStoreOk() {
  var db = MockTransactionStore();
  when(db.getTransactionGroupings()).thenAnswer((_) async { return dbTransactionGroupings;});
  when(db.getTransactions(any)).thenAnswer((_) async { return dbTransactions;});
  when(db.addTransaction(any)).thenAnswer((_) async { return 1;});
  when(db.deleteTransaction(any)).thenAnswer((_) async { return 1;});
  return db;
}