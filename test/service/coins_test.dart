import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/api/data/response_data.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../api/client/coins_test.mocks.dart';

@GenerateMocks([CoinsService])
void main() {
  dotenv.testLoad(mergeWith: {CoinsApiClient.coinRankingApiKey: "api_key"});

  MockCoinsApiClient<Coin> mockClient = MockCoinsApiClient();
  CoinsService service = CoinsService(mockClient);

  group('CoinsService', () {
    test('getCoins returns data from client', () async {
      when(mockClient.getCoins(any)).thenAnswer((_) async {
        return ResponseData(
            200,
            [
              Coin(
                  "asdf",
                  1,
                  "Bitcoin",
                  "BTC",
                  "http",
                  "69000.00",
                  "50",
                  "1B")
            ],
            null);
      });

      (List<Coin>, String?) result = await service.getCoins(CoinsRequestData(),
          DefaultConfig.referenceCurrency);

      expect(
          result.$1.first.equals(Coin(
              "asdf",
              1,
              "Bitcoin",
              "BTC",
              "http",
              "69.000,00 \$",
              "50",
              "1B")),
          true,
          reason: "Coin is not equal");
      expect(result.$2, null, reason: "Message is not null");
    });

    test('getCoins returns data from client', () async {
      when(mockClient.getCoins(any)).thenAnswer((_) async {
        return ResponseData(422, [], "Reference currency not available");
      });

      (List<Coin>, String?) result = await service.getCoins(CoinsRequestData(),
          ReferenceCurrency("qwerty", "fiat", "http", "Dollar", "\$", "USD"));

      expect(result.$1.length, 0, reason: "Coins are not empty");
      expect(result.$2, "Reference currency not available",
          reason: "Message is not equal");
    });
  });
}