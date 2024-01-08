import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/database/transaction.dart';
import 'package:crypto_tracker/model/transaction.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:crypto_tracker/service/transaction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../api/client/coins_test.mocks.dart';
import '../test_data/database.dart';
import '../test_data/expected_data.dart';

@GenerateMocks([TransactionService, TransactionStore])
void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  var mockClient = MockCoinsApiClient();
  var mockCoinsStore = mockCoinsStoreOk();
  var mockTransactionStore = mockTransactionStoreOk();
  var mockCoinsService = CoinsService(mockClient, mockCoinsStore);
  var service = TransactionService(mockTransactionStore, mockCoinsService);

  group('TransactionService', () {
    test('getTransaction returns data from database', () async {
      List<Transaction> result =
          await service.getTransactions(serviceCoins[0].uuid);

      expect(result.length, 4,
          reason: "Not correct number of transactions returned");
      for (var i = 0; i < result.length; i++) {
        expect(result[i] == dbTransactions[i], true);
      }
    });

    test('getTransaction returns exception from database', () async {
      when(mockTransactionStore.getTransactions(any))
          .thenThrow(Exception("Database exception"));

      expect(() => service.getTransactions(serviceCoins[0].uuid),
          throwsA(isA<Exception>()));
    });
  });
}
