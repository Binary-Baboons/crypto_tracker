import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../api/client/coins_test.mocks.dart';
import '../../../../service/coins_test.mocks.dart';
import '../../../../service/transaction_test.mocks.dart';
import '../../../../test_data/api_client.dart';
import '../../../../test_data/database.dart';

void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  Future<void> setupTestEnv(
      WidgetTester tester,
      MockIOClient client,
      MockIOClient referenceCurrenciesClient,
      MockCoinsStore coinsStore,
      MockTransactionStore transactionStore) async {
    await tester.pumpWidget(ProviderScope(overrides: [
      coinsApiClientProvider.overrideWithValue(CoinsApiClient(client)),
      referenceCurrenciesApiClientProvider.overrideWithValue(
          ReferenceCurrenciesApiClient(referenceCurrenciesClient)),
      coinsStoreProvider.overrideWithValue(coinsStore),
      transactionStoreProvider.overrideWithValue(transactionStore)
    ], child: const Main()));

    var favoriteNavButton = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.account_balance_wallet));
    await tester.tap(favoriteNavButton);
    await tester.pumpAndSettle();

    var fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();
  }

  group('NewTransactionModal Widget Tests', () {
    testWidgets('add a valid transaction', (WidgetTester tester) async {
      var transactionStore = mockTransactionStoreOk();
      await setupTestEnv(
          tester,
          mockCoinsClientOk(),
          mockReferenceCurrenciesClientOk(),
          mockCoinsStoreOk(),
          transactionStore);

      Finder dateTimeFinder = find.byKey(Key("dateTimeFormField"));
      TextFormField dateTime = tester.widget(dateTimeFinder);
      dateTime.controller!.text =
          DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String();

      Finder amountFinder = find.byKey(Key("amountFormField"));
      TextFormField amount = tester.widget(amountFinder);
      amount.controller!.text = "1.50";

      Finder priceFinder = find.byKey(Key("priceFormField"));
      TextFormField price = tester.widget(priceFinder);
      price.controller!.text = "45000";

      Finder submit = find.text("Submit");
      await tester.tap(submit);
      await tester.pumpAndSettle();

      verify(transactionStore.addTransaction(any)).called(1);
    });

    testWidgets('add a invalid transaction with empty fields',
            (WidgetTester tester) async {
          var transactionStore = mockTransactionStoreOk();
          await setupTestEnv(tester, mockCoinsClientOk(),
              mockReferenceCurrenciesClientOk(), mockCoinsStoreOk(), transactionStore);

          Finder submit = find.text("Submit");
          await tester.tap(submit);
          await tester.pumpAndSettle();

          expect(find.text("Please enter the amount"), findsOneWidget);
          expect(find.text("Please enter the total spent price"), findsOneWidget);

          verifyNever(transactionStore.addTransaction(any));
        });
  });
}