import 'package:crypto_tracker/api/client/base_client_config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
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
  dotenv.testLoad(mergeWith: {BaseClientConfig.coinRankingApiKey: "api_key"});

  group('CoinScreen Widget Tests', () {
    testWidgets('adds to favorites when clicked on button', (WidgetTester tester) async {
      var mockDatabase = mockCoinsDatabaseOk();
      await tester.pumpWidget(ProviderScope(overrides: [
        coinsApiClientProvider
            .overrideWithValue(CoinsApiClient(mockCoinsClientOk())),
        referenceCurrenciesApiClientProvider.overrideWithValue(
            ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk())),
        coinsStoreProvider.overrideWithValue(mockDatabase)
      ], child: const Main()));
      await tester.pumpAndSettle();

      var eth = find.text("ETH");
      await tester.tap(eth);
      await tester.pumpAndSettle();

      var favoriteButton =  find.byIcon(Icons.favorite_border);
      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      verify(mockDatabase.addFavoriteCoin(any)).called(1);
      verifyNever(mockDatabase.deleteFavoriteCoin(any));
    });
  });
}
