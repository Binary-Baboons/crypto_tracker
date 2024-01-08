import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default.dart';
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

void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  group('MarketScreen Widget Tests', () {
    testWidgets('renders filter buttons correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsStoreProvider.overrideWithValue(mockCoinsStoreOk())
      ], child: const Main()));

      final Finder currentReferenceCurrency =
          find.text(DefaultConfig.referenceCurrency.toString());
      final Finder category = find.text("Category");
      final Finder timePeriod = find.text("Time period");
      final Finder currentTimePeriod =
          find.text(DefaultApiRequestConfig.timePeriod.getTimePeriod);

      expect(currentReferenceCurrency, findsOneWidget);
      expect(category, findsOneWidget);
      expect(timePeriod, findsOneWidget);
      expect(currentTimePeriod, findsOneWidget);
    });

    testWidgets('renders double_arrow_down icon for default orderBy correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsStoreProvider.overrideWithValue(mockCoinsStoreOk())
      ], child: const Main()));

      var mapOrderByToText = {
        OrderBy.marketCap: "MARKET CAP",
        OrderBy.price: "PRICE",
        OrderBy.change: DefaultApiRequestConfig.timePeriod.getTimePeriod
      };
      var defaultOrderByText =
          mapOrderByToText[DefaultApiRequestConfig.orderBy];

      final Finder currentOrderBy = find.text(defaultOrderByText!);
      final Finder parentRow = find.ancestor(
        of: currentOrderBy,
        matching: find.byType(Row),
      );
      final Finder icon =
          find.descendant(of: parentRow.first, matching: find.byType(Icon));

      expect(icon, findsOneWidget);
    });

    testWidgets(
        'renders double_arrow_down and double_arrow_down icon for price orderBy correctly',
        (WidgetTester tester) async {
      var coinsClient = mockCoinsClientOk();
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider.overrideWithValue(CoinsApiClient(coinsClient)),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsStoreProvider.overrideWithValue(mockCoinsStoreOk())
      ], child: const Main()));

      final Finder priceButton = find.text("PRICE");
      await tester.tap(priceButton);
      await tester.pump();

      Finder parentRow = find.ancestor(
        of: priceButton,
        matching: find.byType(Row),
      );

      Finder iconFinder =
          find.descendant(of: parentRow.first, matching: find.byType(Icon));
      Icon icon = tester.widget(iconFinder);

      expect(iconFinder, findsOneWidget);
      expect(icon.icon! == Icons.keyboard_double_arrow_down, true);

      await tester.tap(priceButton);
      await tester.pump();

      parentRow = find.ancestor(
        of: priceButton,
        matching: find.byType(Row),
      );
      iconFinder =
          find.descendant(of: parentRow.first, matching: find.byType(Icon));
      icon = tester.widget(iconFinder);

      expect(iconFinder, findsOneWidget);
      expect(icon.icon! == Icons.keyboard_double_arrow_up, true);

      verify(coinsClient.get(any, headers: anyNamed("headers"))).called(3);
    });
  });
}
