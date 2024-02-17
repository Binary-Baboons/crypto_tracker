import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../../../api/client/coins_test.mocks.dart';
import '../../../service/coins_test.mocks.dart';
import '../../../service/transaction_test.mocks.dart';
import '../../../test_data/api_client.dart';
import '../../../test_data/database.dart';
import '../../../test_data/expected_data.dart';

void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  Future<void> navigateToTransactions(WidgetTester tester) async {
    var btcGroup = find.text("BTC");
    await tester.tap(btcGroup);
    await tester.pumpAndSettle();
  }

  Future<void> setupTestEnv(WidgetTester tester, MockIOClient client,
      MockIOClient referenceCurrenciesClient, MockCoinsStore coinsStore, MockTransactionStore transactionStore) async {
    await tester.pumpWidget(ProviderScope(overrides: [
      coinsApiClientProvider.overrideWithValue(CoinsApiClient(client)),
      referenceCurrenciesApiClientProvider.overrideWithValue(
          ReferenceCurrenciesApiClient(referenceCurrenciesClient)),
      coinsStoreProvider.overrideWithValue(coinsStore),
      transactionStoreProvider.overrideWithValue(transactionStore)
    ], child: const Main()));
    await tester.pumpAndSettle();
  }

  group('TransactionScreen Widget Tests', () {
    testWidgets('renders correctly list with transactions',
            (WidgetTester tester) async {
          await setupTestEnv(tester, mockCoinsClientOk(),
              mockReferenceCurrenciesClientOk(), mockCoinsStoreOk(), mockTransactionStoreOk());

          await navigateToTransactions(tester);

          var expectedChangePL = "${PriceFormatter.formatPrice(dbTransactionGroupings.first.profitAndLoss!, DefaultConfig.referenceCurrency.getSignSymbol(), true)} (%${PriceFormatter.formatPrice(dbTransactionGroupings.first.change!, "", true)})";
          expect(find.text(expectedChangePL), findsOneWidget);
          for (var transaction in dbTransactions) {
            expect(find.text(DateFormat("dd-MM-yyyy").format(transaction.dateTime)), findsAny);
            expect(find.text(DateFormat("HH:mm").format(transaction.dateTime)), findsAny);
            expect(find.text(transaction.type.getValueOnly), findsAny);
            expect(find.text(transaction.source.getValueOnly), findsAny);
            expect(find.text(transaction.amount.toString()), findsOneWidget);
            expect(find.text(PriceFormatter.formatPrice(transaction.priceForAmount, DefaultConfig.referenceCurrency.getSignSymbol(), true)), findsOneWidget);
          }
        });
  });
}
