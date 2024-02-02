import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/error/handler.dart';
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
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  Future<void> navigateToFavorites(WidgetTester tester) async {
    var favoriteNavButton = find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.favorite));
    await tester.tap(favoriteNavButton);
    await tester.pumpAndSettle();
  }

  group('FavoriteScreen Widget Tests', () {
    testWidgets('renders correctly coins list with coins',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsStoreProvider.overrideWithValue(mockCoinsStoreOk())
      ], child: const Main()));

      await navigateToFavorites(tester);

      var coin = apiCoins[0];
      expect(find.text(coin.symbol), findsOneWidget);
    });

    testWidgets('removes from list when swiped', (WidgetTester tester) async {
      var mockDatabase = mockCoinsStoreOk();
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsStoreProvider.overrideWithValue(mockDatabase)
      ], child: const Main()));

      await navigateToFavorites(tester);

      await tester.drag(
          find.text(apiCoins[0].symbol), const Offset(-300, 0));
      await tester.pumpAndSettle();

      var coin = apiCoins[0];
      expect(find.text(coin.symbol), findsNothing);

      verify(mockDatabase.deleteFavoriteCoin(any)).called(1);
      verifyNever(mockDatabase.addFavoriteCoin(any));
    });

    testWidgets('renders correctly snackbar with error',
            (WidgetTester tester) async {
          await tester.pumpWidget(ProviderScope(overrides: [
            coinsApiClientProvider
                .overrideWithValue(CoinsApiClient(mockCoinsClientError())),
            referenceCurrenciesApiClientProvider.overrideWithValue(
                ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
            coinsStoreProvider.overrideWithValue(mockCoinsStoreOk()),
            coinsStoreProvider.overrideWithValue(mockCoinsStoreError())
          ], child: const Main()));

          await navigateToFavorites(tester);

          var snackBarFinder =
          find.text(ErrorHandler.internalAppError);
          expect(snackBarFinder, findsOneWidget);
        });
  });
}
