import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../api/client/coins_test.mocks.dart';
import '../../../service/coins_test.mocks.dart';
import '../../../service/transaction_test.mocks.dart';
import '../../../test_data/api_client.dart';
import '../../../test_data/database.dart';
import '../../../test_data/expected_data.dart';

void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

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

    var favoriteNavButton = find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.account_balance_wallet));
    await tester.tap(favoriteNavButton);
    await tester.pumpAndSettle();
  }

  group('TransactionGroupingListItemWidget Widget Tests', () {
    testWidgets('renders correctly list with groups',
            (WidgetTester tester) async {
      await setupTestEnv(tester, mockCoinsClientOk(),
          mockReferenceCurrenciesClientOk(), mockCoinsStoreOk(), mockTransactionStoreOk());

          for (var group in dbTransactionGroupings) {
            expect(find.text(group.coin!.symbol), findsOneWidget);
            expect(find.text(PriceFormatter.formatPrice(group.coin!.price, DefaultConfig.referenceCurrency.getSignSymbol())), findsOneWidget);
            expect(find.text(PriceFormatter.formatPrice(group.sumAmount, "")), findsOneWidget);
            expect(find.text(PriceFormatter.formatPrice(group.getGroupingValue(), DefaultConfig.referenceCurrency.getSignSymbol())), findsOneWidget);

            var expectedChange = "${PriceFormatter.formatPrice(dbTransactionGroupings.where((g) => g.coinUuid == group.coinUuid).first.change!, "")} %";
            var expectedPL = PriceFormatter.formatPrice(dbTransactionGroupings.where((g) => g.coinUuid == group.coinUuid).first.profitAndLoss!, DefaultConfig.referenceCurrency.getSignSymbol());
            expect(find.text(expectedChange), findsOneWidget);
            expect(find.text(expectedPL), findsOneWidget);
          }
        });
  });
}
