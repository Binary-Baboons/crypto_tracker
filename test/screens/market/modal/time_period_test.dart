import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/screens/market/modal/time_period.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimePeriodModal Widget Tests', () {
    testWidgets('renders correctly on show time period modal',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: CryptoTrackerApp()));

      final Finder timePeriodSortButton = find.text("Time period");
      await tester.tap(timePeriodSortButton);
      await tester.pump();

      expect(find.byType(TimePeriodModal), findsOneWidget);

      for (var period in TimePeriod.values) {
        await tester.scrollUntilVisible(
          find.text(period.getTimePeriod).last,
          100.0,
          scrollable: find.byType(Scrollable),
        );
        await tester.pump();
        expect(find.text(period.getTimePeriod).last, findsOneWidget);
      }
    });

    testWidgets('renders correctly on button click',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: CryptoTrackerApp()));

      final Finder timePeriodSortButton = find.text("Time period");
      await tester.tap(timePeriodSortButton);
      await tester.pump();

      Finder orderBySortButtonTextFinder =
          find.byKey(const Key("changeSortButtonText"));
      Text orderBySortButtonText =
          tester.widget(orderBySortButtonTextFinder) as Text;
      expect(
          orderBySortButtonText.data
              ?.contains(DefaultApiRequestConfig.timePeriod.getTimePeriod),
          true);

      final Finder timePeriod1hButton = find.text(TimePeriod.t1h.getTimePeriod);
      await tester.pumpAndSettle();
      await tester.tap(timePeriod1hButton);
      await tester.pumpAndSettle();

      orderBySortButtonTextFinder =
          find.byKey(const Key("changeSortButtonText"));
      orderBySortButtonText =
          tester.widget(orderBySortButtonTextFinder) as Text;
      expect(orderBySortButtonText.data?.contains(TimePeriod.t1h.getTimePeriod),
          true);
    });
  });
}
