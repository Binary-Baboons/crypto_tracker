import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:crypto_tracker/view/screen/market/modal/reference_currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_data/api_client.dart';
import '../../../../test_data/database.dart';
import '../../../../test_data/expected_data.dart';

void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  Future<void> navigateToMarket(WidgetTester tester) async {
    var favoriteNavButton = find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.align_vertical_bottom));
    await tester.tap(favoriteNavButton);
    await tester.pumpAndSettle();
  }

  group('ReferenceCurrenciesModal Widget Tests', () {
    testWidgets('renders correctly on show reference currencies modal',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsStoreProvider.overrideWithValue(mockCoinsStoreOk())
      ], child: const Main()));

      await navigateToMarket(tester);

      final Finder currencyFilterButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      await tester.pumpAndSettle();
      await tester.tap(currencyFilterButton);
      await tester.pumpAndSettle();

      expect(find.byType(ReferenceCurrenciesModal), findsOneWidget);

      for (var currency in expectedCurrencies) {
        expect(find.text(currency.toString()).last, findsOneWidget);
      }
    });

    testWidgets('renders correctly on button click',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsStoreProvider.overrideWithValue(mockCoinsStoreOk())
      ], child: const Main()));

      await navigateToMarket(tester);

      final Finder currencyFilterButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      await tester.pumpAndSettle();
      await tester.tap(currencyFilterButton);
      await tester.pumpAndSettle();

      Finder referenceCurrencyFilterTextFinder =
          find.byKey(const Key("referenceCurrencyFilterText"));
      Text referenceCurrencyFilterText =
          tester.widget(referenceCurrencyFilterTextFinder) as Text;
      expect(
          referenceCurrencyFilterText.data
              ?.contains(DefaultConfig.referenceCurrency.toString()),
          true);

      final Finder euroReferenceCurrency = find.text("Euro (e)");
      await tester.pumpAndSettle();
      await tester.tap(euroReferenceCurrency);
      await tester.pumpAndSettle();

      referenceCurrencyFilterTextFinder =
          find.byKey(const Key("referenceCurrencyFilterText"));
      referenceCurrencyFilterText =
          tester.widget(referenceCurrencyFilterTextFinder) as Text;
      expect(referenceCurrencyFilterText.data?.contains("Euro (e)"), true);
    });

    testWidgets('renders correctly default currency on error',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientError())),
        coinsStoreProvider.overrideWithValue(mockCoinsStoreOk())
      ], child: const Main()));

      await navigateToMarket(tester);

      Finder currencyFilterButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      await tester.pumpAndSettle();
      await tester.tap(currencyFilterButton);
      await tester.pumpAndSettle();

      currencyFilterButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      expect(currencyFilterButton.last, findsOneWidget);
    });

    testWidgets('calls GET reference currency api only once',
        (WidgetTester tester) async {
      var currencyClient = mockReferenceCurrenciesClientOk();
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider
            .overrideWithValue(ReferenceCurrenciesApiClient(currencyClient)),
        coinsStoreProvider.overrideWithValue(mockCoinsStoreOk())
      ], child: const Main()));

      await navigateToMarket(tester);

      final Finder currencyFilterButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      await tester.pumpAndSettle();
      await tester.tap(currencyFilterButton);
      await tester.pumpAndSettle();

      currencyClient.close();
      currencyClient.close();

      Finder referenceCurrencyFilterTextFinder =
          find.byKey(const Key("referenceCurrencyFilterText"));
      Text referenceCurrencyFilterText =
          tester.widget(referenceCurrencyFilterTextFinder) as Text;
      expect(
          referenceCurrencyFilterText.data
              ?.contains(DefaultConfig.referenceCurrency.toString()),
          true);

      Finder euroReferenceCurrency = find.text("Euro (e)");
      await tester.pumpAndSettle();
      await tester.tap(euroReferenceCurrency);
      await tester.pumpAndSettle();

      euroReferenceCurrency = find.text("Euro (e)");
      await tester.pumpAndSettle();
      await tester.tap(euroReferenceCurrency);
      await tester.pumpAndSettle();

      verify(currencyClient.get(any, headers: anyNamed("headers"))).called(1);
    });
  });
}
