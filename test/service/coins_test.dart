import 'package:crypto_tracker/api/client/base_client_config.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../api/client/coins_test.mocks.dart';
import 'coins_test.mocks.dart';

@GenerateMocks([CoinsService, CoinsDatabase])
void main() {
  dotenv.testLoad(mergeWith: {BaseClientConfig.coinRankingApiKey: "api_key"});

  MockCoinsApiClient mockClient = MockCoinsApiClient();
  CoinsDatabase mockDatabase = MockCoinsDatabase();
  CoinsService service = CoinsService(mockClient, mockDatabase);

  group('CoinsService', () {
    test('getCoins returns data from client', () async {
      when(mockClient.getCoins(any, any)).thenAnswer((_) async {
        return [
          Coin("asdf", 1, "Bitcoin", "BTC", "http", "69000.00000", "50",
              "8000.00000", sparkline: ["8000.12345", null]),
          Coin("qwerty", 2, "Etherium", "ETH", "http", "0.00000123456789", null,
              "0.123456789", sparkline: ["0.0000023456789", null] ),
          Coin("erty", 3, "Randomcoin", "RND", "http", null, null, null)
        ];
      });
      when(mockDatabase.getFavoriteCoins()).thenAnswer((_) async {return ["asdf"];});

      List<Coin> result = await service.getCoins(
          CoinsRequestData(), DefaultConfig.referenceCurrency);

      expect(result.length, 2, reason: "Not correct nmber of coins returned");
      expect(
          result[0] ==
              Coin("asdf", 1, "Bitcoin", "BTC", "http", "\$69,000.00", "50",
                  "\$8,000.00", favorite: true, sparkline: ["8000.12", null]),
          true,
          reason: "Coin is not equal");
      expect(
          result[1] ==
              Coin("qwerty", 2, "Etherium", "ETH", "http", "\$0.0000012346",
                  "0.00", "\$0.12", favorite: false, sparkline: ["0.0000023457", null]),
          true,
          reason: "Coin is not equal");
    });

    test('getCoins returns error message from client', () async {
      when(mockClient.getCoins(any, any))
          .thenThrow(ClientException("Reference currency not available"));

      expect(
          () => service.getCoins(
              CoinsRequestData(), DefaultConfig.referenceCurrency),
          throwsA(isA<ClientException>()));
    });

    test('getFavoriteCoins returns data from client', () async {
      when(mockDatabase.getFavoriteCoins()).thenAnswer((_) async {return ["asdf"];});
      when(mockClient.getCoins(any, any)).thenAnswer((_) async {
        return [
          Coin("asdf", 1, "Bitcoin", "BTC", "http", "69000.00000", "50",
              "8000.00000", sparkline: ["8000.12345", null]),
        ];
      });

      List<Coin> result = await service.getFavoriteCoins(DefaultConfig.referenceCurrency);

      expect(result.length, 1, reason: "Not correct number of coins returned");
      expect(
          result[0] ==
              Coin("asdf", 1, "Bitcoin", "BTC", "http", "\$69,000.00", "50",
                  "\$8,000.00", favorite: true, sparkline: ["8000.12", null]),
          true,
          reason: "Coin is not equal");
    });
  });
}
