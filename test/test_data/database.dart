import 'package:crypto_tracker/database/coins.dart';
import 'package:mockito/mockito.dart';

import '../service/coins_test.mocks.dart';
import 'expected_data.dart';

CoinsDatabase mockCoinsDatabaseOk() {
  var db = MockCoinsDatabase();
  when(db.getFavoriteCoins()).thenAnswer((_) async { return expectedCoins.map((c) => c.uuid!).toList();});
  return db;
}