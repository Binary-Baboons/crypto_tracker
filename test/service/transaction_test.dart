import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/database/transaction.dart';
import 'package:crypto_tracker/model/transaction.dart';
import 'package:crypto_tracker/model/transaction_grouping.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:crypto_tracker/service/transaction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_data/api_client.dart';
import '../test_data/database.dart';
import '../test_data/expected_data.dart';

@GenerateMocks([TransactionService, TransactionStore])
void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  var mockClient = CoinsApiClient(mockCoinsClientOk());
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

    test('addTransactions adds a withdrawal to database', () async {
      var copy = Transaction.copy(dbTransactions[0]);

      await service.addTransaction(dbTransactions[0]);

      verify(mockTransactionStore.addTransaction(argThat(predicate<Transaction>((transaction) => transaction == copy)))).called(1);
    });

    test('addTransactions adds a withdrawal to database', () async {
      var copy = Transaction.copy(dbTransactions[2]);
      copy.amount = copy.amount * (-1);
      copy.priceForAmount = copy.priceForAmount * (-1);

      await service.addTransaction(dbTransactions[2]);

      verify(mockTransactionStore.addTransaction(argThat(predicate<Transaction>((transaction) => transaction == copy)))).called(1);
    });

    test('deleteTransactions deletes to database', () async {
      when(mockTransactionStore.deleteTransaction(any))
          .thenAnswer((_) async {return 1;});

      int res = await service.deleteTransaction(dbTransactions[0].transactionId);

      expect(res, 1);
      verify(mockTransactionStore.deleteTransaction(any)).called(1);
    });

    test('getTransactionGrouping returns data from database', () async {
      List<TransactionGrouping> res = await service.getTransactionGroupings();

      TransactionGrouping btc = res[0];
      expect(btc.coin, isNotNull);
      btc.coin!.favorite = false;
      expect(btc.coin, serviceCoins[0]);
      expect(btc.change, dbTransactionGroupings[0].change);
      expect(btc.profitAndLoss, dbTransactionGroupings[0].profitAndLoss);

      TransactionGrouping eth = res[1];
      expect(eth.coin, isNotNull);
      eth.coin!.favorite = false;
      expect(eth.coin, serviceCoins[1]);
      expect(eth.change, dbTransactionGroupings[1].change);
      expect(eth.profitAndLoss, dbTransactionGroupings[1].profitAndLoss);
    });
  });
}
