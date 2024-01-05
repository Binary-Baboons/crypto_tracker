import 'package:crypto_tracker/api/client/base_client_config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/provider/api_client.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:crypto_tracker/view/screen/market/modal/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_data/api_client.dart';
import '../../../../test_data/database.dart';

void main() {
  dotenv.testLoad(mergeWith: {BaseClientConfig.coinRankingApiKey: "api_key"});

  group('CategoriesModal Widget Tests', () {
    testWidgets('renders correctly on show categories modal',
            (WidgetTester tester) async {
              await tester.pumpWidget(ProviderScope(overrides: [
                coinsApiClientProvider.overrideWithValue(CoinsApiClient(mockCoinsClientError())),
                referenceCurrenciesApiClientProvider.overrideWithValue(ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientError())),
                coinsStoreProvider.overrideWithValue(mockCoinsDatabaseOk())
              ], child: const Main()));

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
