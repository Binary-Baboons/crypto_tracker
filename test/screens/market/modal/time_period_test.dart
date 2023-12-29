import 'package:crypto_tracker/api/client/base_client_config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/screens/market/modal/time_period.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_data/api_client.dart';

void main() {
  dotenv.testLoad(mergeWith: {BaseClientConfig.coinRankingApiKey: "api_key"});

  group('TimePeriodModal Widget Tests', () {
    testWidgets('renders correctly on show time period modal',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk()))
      ], child: const CryptoTrackerApp()));

      final Finder timePeriodSortButton = find.text("Time period");
      await tester.tap(timePeriodSortButton);
      await tester.pump();

      expect(find.byType(TimePeriodModal), findsOneWidget);

      for (var period in TimePeriod.values) {
        await tester.scrollUntilVisible(
          find.text(period.getTimePeriod).last,
          100.0,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pump();
        expect(find.text(period.getTimePeriod).last, findsOneWidget);
      }
    });

    testWidgets('renders correctly on button click',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk()))
      ], child: const CryptoTrackerApp()));

      final Finder timePeriodSortButton = find.text("Time period");
      await tester.tap(timePeriodSortButton);
      await tester.pump();

      Finder orderBySortTextFinder = find.byKey(const Key("changeSortText"));
      Text orderBySortText = tester.widget(orderBySortTextFinder) as Text;
      expect(
          orderBySortText.data
              ?.contains(DefaultApiRequestConfig.timePeriod.getTimePeriod),
          true);

      final Finder timePeriod1hButton = find.text(TimePeriod.t1h.getTimePeriod);
      await tester.pumpAndSettle();
      await tester.tap(timePeriod1hButton);
      await tester.pumpAndSettle();

      orderBySortTextFinder = find.byKey(const Key("changeSortText"));
      orderBySortText = tester.widget(orderBySortTextFinder) as Text;
      expect(
          orderBySortText.data?.contains(TimePeriod.t1h.getTimePeriod), true);
    });
  });
}
