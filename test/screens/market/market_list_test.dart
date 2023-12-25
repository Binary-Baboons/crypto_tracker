import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/main.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../service/coins_test.mocks.dart';
import '../../service/reference_currencies_test.mocks.dart';

List<Coin> mockCoins = [
  Coin("asdf", 1, "Bitcoin", "BTC", null, "\$69,000.00", "50", "\$8,000.00"),
  Coin("qwerty", 2, "Etherium", "ETH", null, "\$0.0000012346", "0.0", "\$0.12")
];

void main() {
  group('MarketListWidget Widget Tests', () {
    testWidgets('renders correctly market list with coins',
        (WidgetTester tester) async {
      var coinsService = MockCoinsService();
      when(coinsService.getCoins(any, any))
          .thenAnswer((_) => Future.value((mockCoins, null)));

      var currenciesService = MockReferenceCurrenciesService();
      when(currenciesService.getReferenceCurrencies()).thenAnswer((_) => Future.value(([DefaultConfig.referenceCurrency],null)));

      await tester.pumpWidget(ProviderScope(overrides: [
        coinsServiceProvider.overrideWithValue(coinsService),
        referenceCurrenciesServiceProvider.overrideWithValue(currenciesService),
      ], child: const CryptoTrackerApp()));
      await tester.pumpAndSettle();

      for (var coin in mockCoins) {
        //expect(find.text(coin.rank.toString()), findsOneWidget);
        expect(find.text(coin.symbol!), findsOneWidget);
        expect(find.text(coin.price!), findsOneWidget);
        expect(find.text(coin.marketCap!), findsOneWidget);
      }
    });
  });
}
