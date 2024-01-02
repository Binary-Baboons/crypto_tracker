import 'package:crypto_tracker/database/coins.dart';
import 'package:mockito/mockito.dart';

import '../service/coins_test.mocks.dart';
import 'expected_data.dart';

MockCoinsDatabase mockCoinsDatabaseOk() {
  var db = MockCoinsDatabase();
  when(db.getFavoriteCoins()).thenAnswer((_) async { return [expectedCoins[0].uuid!];});
  when(db.addFavoriteCoin(any)).thenAnswer((_) async { return 1;});
  when(db.deleteFavoriteCoin(any)).thenAnswer((_) async { return 1;});
  return db;
}