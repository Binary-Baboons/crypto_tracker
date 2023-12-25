import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/provider/service/service_provider.dart';
import 'package:crypto_tracker/screens/market/modal/reference_currencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../service/reference_currencies_test.mocks.dart';

List<ReferenceCurrency> mockCurrencies = [
  ReferenceCurrency(
    "yhjMzLPhuIDl",
    "fiat",
    "https://cdn.coinranking.com/kz6a7w6vF/usd.svg",
    "US Dollar",
    "USD",
    "\$",
  ),
  ReferenceCurrency(
    "5k-_VTxqtCEI",
    "fiat",
    "https://cdn.coinranking.com/fz3P5lsJY/eur.svg",
    "Euro",
    "EUR",
    "€",
  ),
  ReferenceCurrency(
    "K4iOZMuz76cc",
    "fiat",
    "https://cdn.coinranking.com/tDtpsWiy9/malaysian-ringgit.svg",
    "Malaysian Ringgit",
    "MYR",
    "RM",
  ),
];

void main() {
  group('ReferenceCurrenciesModal Widget Tests', () {
    testWidgets('renders correctly on show reference currencies modal',
        (WidgetTester tester) async {
      var service = MockReferenceCurrenciesService();
      when(service.getReferenceCurrencies()).thenAnswer((_) => Future.value((mockCurrencies,null)));

      await tester.pumpWidget(ProviderScope(overrides: [
        referenceCurrenciesServiceProvider
            .overrideWithValue(service),
      ], child: const CryptoTrackerApp()));

      final Finder timePeriodSortButton =
          find.text(DefaultConfig.referenceCurrency.toString());
      await tester.pumpAndSettle();
      await tester.tap(timePeriodSortButton);
      await tester.pumpAndSettle();

      expect(find.byType(ReferenceCurrenciesModal), findsOneWidget);

      for (var currency in mockCurrencies) {
        expect(find.text(currency.toString()).last, findsOneWidget);
      }
    });

    testWidgets('renders correctly on button click',
        (WidgetTester tester) async {
          var service = MockReferenceCurrenciesService();
          when(service.getReferenceCurrencies()).thenAnswer((_) => Future.value((mockCurrencies,null)));

          await tester.pumpWidget(ProviderScope(overrides: [
            referenceCurrenciesServiceProvider
                .overrideWithValue(service),
          ], child: const CryptoTrackerApp()));

          final Finder timePeriodSortButton =
          find.text(DefaultConfig.referenceCurrency.toString());
          await tester.pumpAndSettle();
          await tester.tap(timePeriodSortButton);
          await tester.pumpAndSettle();

      Finder referenceCurrencyFilterTextFinder =
          find.byKey(const Key("referenceCurrencyFilterText"));
      Text referenceCurrencyFilterText =
          tester.widget(referenceCurrencyFilterTextFinder) as Text;
      expect(
          referenceCurrencyFilterText.data
              ?.contains(DefaultConfig.referenceCurrency.toString()),
          true);

      final Finder euroReferenceCurrency = find.text(mockCurrencies[1].toString());
      await tester.pumpAndSettle();
      await tester.tap(euroReferenceCurrency);
      await tester.pumpAndSettle();

          referenceCurrencyFilterTextFinder =
          find.byKey(const Key("referenceCurrencyFilterText"));
          referenceCurrencyFilterText =
          tester.widget(referenceCurrencyFilterTextFinder) as Text;
      expect(referenceCurrencyFilterText.data?.contains(mockCurrencies[1].toString()),
          true);
    });
  });
}
