import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/screens/market/modal/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../provider/api_client.dart';

void main() {
  dotenv.testLoad(mergeWith: {CoinsApiClient.coinRankingApiKey: "api_key"});

  group('CategoriesModal Widget Tests', () {
    testWidgets('renders correctly on show categories modal',
            (WidgetTester tester) async {
              await tester.pumpWidget(ProviderScope(overrides: [
                coinsApiClientProvider.overrideWithValue(CoinsApiClient(mockCoinsClientError())),
                referenceCurrenciesApiClientProvider.overrideWithValue(ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientError()))
              ], child: const CryptoTrackerApp()));

          final Finder timePeriodSortButton = find.text("Category");
          await tester.tap(timePeriodSortButton);
          await tester.pump();

          expect(find.byType(CategoriesModal), findsOneWidget);

          for (var category in CategoryTag.values) {
            await tester.scrollUntilVisible(
              find.text(category.getValueWithDash).last,
              100.0,
              scrollable: find.byType(Scrollable),
            );
            await tester.pump();
            expect(find.text(category.getValueWithDash).last, findsOneWidget);
          }
        });
  });
}
