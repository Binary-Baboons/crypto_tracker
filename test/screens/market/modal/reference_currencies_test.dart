import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:crypto_tracker/screens/market/modal/reference_currencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../../provider/api_client.dart';
import '../../../service/reference_currencies_test.mocks.dart';

void main() {
  dotenv.testLoad(mergeWith: {CoinsApiClient.coinRankingApiKey: "api_key"});

  group('ReferenceCurrenciesModal Widget Tests', () {
    testWidgets('renders correctly on show reference currencies modal',
        (WidgetTester tester) async {
          await tester.pumpWidget(ProviderScope(overrides: [
            coinsApiClientProvider.overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
            referenceCurrenciesApiClientProvider.overrideWithValue(ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk()))
          ], child: const CryptoTrackerApp()));

      final Finder currencyFilterButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      await tester.pumpAndSettle();
      await tester.tap(currencyFilterButton);
      await tester.pumpAndSettle();

      expect(find.byType(ReferenceCurrenciesModal), findsOneWidget);
    });

    testWidgets('renders correctly on button click',
        (WidgetTester tester) async {
          await tester.pumpWidget(ProviderScope(overrides: [
            coinsApiClientProvider.overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
            referenceCurrenciesApiClientProvider.overrideWithValue(ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk()))
          ], child: const CryptoTrackerApp()));

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

      final Finder euroReferenceCurrency =
          find.text("Euro (e)");
      await tester.pumpAndSettle();
      await tester.tap(euroReferenceCurrency);
      await tester.pumpAndSettle();

      referenceCurrencyFilterTextFinder =
          find.byKey(const Key("referenceCurrencyFilterText"));
      referenceCurrencyFilterText =
          tester.widget(referenceCurrencyFilterTextFinder) as Text;
      expect(
          referenceCurrencyFilterText.data
              ?.contains("Euro (e)"),
          true);
    });

    testWidgets('renders correctly default currency on error',
        (WidgetTester tester) async {
          await tester.pumpWidget(ProviderScope(overrides: [
            coinsApiClientProvider.overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
            referenceCurrenciesApiClientProvider.overrideWithValue(ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientError()))
          ], child: const CryptoTrackerApp()));

      Finder currencyFilterButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      await tester.pumpAndSettle();
      await tester.tap(currencyFilterButton);
      await tester.pumpAndSettle();

      currencyFilterButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      expect(currencyFilterButton.last, findsOneWidget);
    });
  });
}
