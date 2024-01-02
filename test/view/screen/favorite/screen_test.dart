import 'package:crypto_tracker/api/client/base_client_config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_data/api_client.dart';
import '../../../test_data/database.dart';
import '../../../test_data/expected_data.dart';

void main() {
  dotenv.testLoad(mergeWith: {BaseClientConfig.coinRankingApiKey: "api_key"});

  group('FavoriteScreen Widget Tests', () {
    testWidgets('renders correctly coins list with coins',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsDatabaseProvider.overrideWithValue(mockCoinsDatabaseOk())
      ], child: const Main()));
      await tester.pumpAndSettle();

      var favoriteNavButton = find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.favorite));
      await tester.tap(favoriteNavButton);
      await tester.pumpAndSettle();

      var coin = expectedCoins[0];
      expect(find.text(coin.rank.toString()), findsOneWidget);
      expect(find.text(coin.symbol!), findsOneWidget);
      expect(find.text(coin.change!), findsOneWidget);
      expect(find.text(coin.price!), findsOneWidget);
      expect(find.text(coin.marketCap!), findsOneWidget);
    });
  });

  group('FavoriteScreen Widget Tests', () {
    testWidgets('removes from list when swiped', (WidgetTester tester) async {
      var mockDatabase = mockCoinsDatabaseOk();
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsDatabaseProvider.overrideWithValue(mockDatabase)
      ], child: const Main()));
      await tester.pumpAndSettle();

      var favoriteNavButton = find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.favorite));
      await tester.tap(favoriteNavButton);
      await tester.pumpAndSettle();

      await tester.drag(
          find.text(expectedCoins[0].symbol!), const Offset(-300, 0));
      await tester.pumpAndSettle();

      var coin = expectedCoins[0];
      expect(find.text(coin.rank.toString()), findsNothing);
      expect(find.text(coin.symbol!), findsNothing);
      expect(find.text(coin.change!), findsNothing);
      expect(find.text(coin.price!), findsNothing);
      expect(find.text(coin.marketCap!), findsNothing);

      verify(mockDatabase.deleteFavoriteCoin(any)).called(1);
      verifyNever(mockDatabase.addFavoriteCoin(any));
    });
  });
}
