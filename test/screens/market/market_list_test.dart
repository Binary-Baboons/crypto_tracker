import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data/api_client.dart';
import '../../test_data/expected_data.dart';

void main() {
  dotenv.testLoad(mergeWith: {CoinsApiClient.coinRankingApiKey: "api_key"});

  group('MarketListWidget Widget Tests', () {
    testWidgets('renders correctly market list with coins',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk()))
      ], child: const CryptoTrackerApp()));
      await tester.pumpAndSettle();

      for (var coin in expectedCoins) {
        expect(find.text(coin.rank.toString()), findsOneWidget);
        expect(find.text(coin.symbol!), findsOneWidget);
        expect(find.text(coin.change!), findsOneWidget);
        expect(find.text(coin.price!), findsOneWidget);
        expect(find.text(coin.marketCap!), findsOneWidget);
      }
    });

    testWidgets('renders correctly snackbar with error',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientError())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk()))
      ], child: const CryptoTrackerApp()));
      await tester.pumpAndSettle();

      var snackBarFinder =
          find.text("ClientException: Reference currency not available");
      expect(snackBarFinder, findsOneWidget);
    });
  });
}
