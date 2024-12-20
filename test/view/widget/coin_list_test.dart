import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../api/client/coins_test.mocks.dart';
import '../../service/coins_test.mocks.dart';
import '../../test_data/api_client.dart';
import '../../test_data/database.dart';
import '../../test_data/expected_data.dart';

void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  Future<void> setupTestEnv(WidgetTester tester, MockIOClient client,
      MockIOClient referenceCurrenciesClient, MockCoinsStore coinsStore) async {
    await tester.pumpWidget(ProviderScope(overrides: [
      coinsApiClientProvider.overrideWithValue(CoinsApiClient(client)),
      referenceCurrenciesApiClientProvider.overrideWithValue(
          ReferenceCurrenciesApiClient(referenceCurrenciesClient)),
      coinsStoreProvider.overrideWithValue(coinsStore)
    ], child: const Main()));
    await tester.pumpAndSettle();
  }

  group('CoinListWidget Widget Tests', () {
    testWidgets('renders correctly coins list with coins',
        (WidgetTester tester) async {
      await setupTestEnv(tester, mockCoinsClientOk(),
          mockReferenceCurrenciesClientOk(), mockCoinsStoreOk());

      for (var coin in serviceCoins) {
        expect(find.text(coin.rank.toString()), findsOneWidget);
        expect(find.text(coin.symbol), findsOneWidget);
        expect(find.text("${coin.change} %"), findsOneWidget);
        expect(
            find.text(PriceFormatter.formatPrice(
                coin.price, DefaultConfig.referenceCurrency.getSignSymbol())),
            findsOneWidget);
        expect(
            find.text(PriceFormatter.formatPrice(coin.marketCap,
                DefaultConfig.referenceCurrency.getSignSymbol())),
            findsOneWidget);
      }
    });

    testWidgets('add to favorites swipe', (WidgetTester tester) async {
      var mockDatabase = mockCoinsStoreOk();
      await setupTestEnv(tester, mockCoinsClientOk(),
          mockReferenceCurrenciesClientOk(), mockDatabase);

      await tester.drag(find.text(apiCoins[1].symbol), const Offset(-300, 0));
      await tester.pumpAndSettle();

      verify(mockDatabase.addFavoriteCoin(any)).called(1);
      verifyNever(mockDatabase.deleteFavoriteCoin(any));
    });

    testWidgets('remove from favorites swipe', (WidgetTester tester) async {
      var mockDatabase = mockCoinsStoreOk();
      await setupTestEnv(tester, mockCoinsClientOk(),
          mockReferenceCurrenciesClientOk(), mockDatabase);

      await tester.drag(find.text(apiCoins[0].symbol), const Offset(-300, 0));
      await tester.pumpAndSettle();

      verifyNever(mockDatabase.addFavoriteCoin(any));
      verify(mockDatabase.deleteFavoriteCoin(any)).called(1);
    });

    testWidgets('renders correctly snackbar with error',
        (WidgetTester tester) async {
      await setupTestEnv(tester, mockCoinsClientError(),
          mockReferenceCurrenciesClientOk(), mockCoinsStoreOk());

      var snackBarFinder =
          find.text("ClientException: Reference currency not available");
      expect(snackBarFinder, findsOneWidget);
    });
  });
}
