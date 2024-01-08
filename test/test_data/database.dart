import 'package:mockito/mockito.dart';

import '../service/coins_test.mocks.dart';
import 'expected_data.dart';

MockCoinsStore mockCoinsDatabaseOk() {
  var db = MockCoinsStore();
  when(db.getFavoriteCoins()).thenAnswer((_) async { return [apiCoins[0].uuid];});
  when(db.addFavoriteCoin(any)).thenAnswer((_) async { return 1;});
  when(db.deleteFavoriteCoin(any)).thenAnswer((_) async { return 1;});
  return db;
}