import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarketScreen Widget Tests', () {
    testWidgets('renders buttons correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: CryptoTrackerApp()));

      final Finder currentReferenceCurrency = find.text(DefaultConfig.referenceCurrency.toString());
      final Finder category = find.text("Category");
      final Finder timePeriod = find.text("Time period");
      final Finder currentTimePeriod = find.text(DefaultApiRequestConfig.timePeriod.getTimePeriod);

      expect(currentReferenceCurrency, findsOneWidget);
      expect(category, findsOneWidget);
      expect(timePeriod, findsOneWidget);
      expect(currentTimePeriod, findsOneWidget);
    });

    testWidgets('renders double_arrow_down icon for default orderBy correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: CryptoTrackerApp()));

      var mapOrderByToText = {
        OrderBy.marketCap: "MARKET CAP",
        OrderBy.price: "PRICE",
        OrderBy.change: DefaultApiRequestConfig.timePeriod.getTimePeriod
      };
      var defaultOrderByText = mapOrderByToText[DefaultApiRequestConfig.orderBy];

      final Finder currentOrderBy = find.text(defaultOrderByText!);
      final Finder parentRow = find.ancestor(
        of: currentOrderBy,
        matching: find.byType(Row),
      );
      final Finder icon = find.descendant(of: parentRow.first, matching: find.byType(Icon));

      expect(icon, findsOneWidget);
    });
  });
}