import 'package:crypto_tracker/api/client/base_client_config.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/error/exception/empty_result.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../api/client/coins_test.mocks.dart';
import '../test_data/expected_data.dart';
import 'coins_test.mocks.dart';

@GenerateMocks([CoinsService, CoinsStore])
void main() {
  dotenv.testLoad(mergeWith: {BaseClientConfig.coinRankingApiKey: "api_key"});

  MockCoinsApiClient mockClient = MockCoinsApiClient();
  CoinsStore mockDatabase = MockCoinsStore();
  CoinsService service = CoinsService(mockClient, mockDatabase);

  group('CoinsService', () {
    test('getCoins returns data from client', () async {
      when(mockClient.getCoins(any, any)).thenAnswer((_) async {
        return apiCoins;
      });
      when(mockDatabase.getFavoriteCoins()).thenAnswer((_) async {
        return [apiCoins[0].uuid];
      });

      List<Coin> result = await service.getCoins(
          CoinsRequestData(), DefaultConfig.referenceCurrency);

      expect(result.length, 3, reason: "Not correct number of coins returned");
      for (var i = 0; i < result.length; i++) {
        expect(result[i] == apiCoins[i], true);
      }
    });

    test('getCoins returns error message from client', () async {
      when(mockClient.getCoins(any, any))
          .thenThrow(ClientException("Reference currency not available"));

      expect(
          () => service.getCoins(
              CoinsRequestData(), DefaultConfig.referenceCurrency),
          throwsA(isA<ClientException>()));
    });

    test('getCoins returns no result', () async {
      when(mockClient.getCoins(any, any)).thenAnswer((_) async {
        return [];
      });

      expect(
          () => service.getCoins(
              CoinsRequestData(), DefaultConfig.referenceCurrency),
          throwsA(isA<EmptyResultException>()));
    });

    test('getFavoriteCoins returns data from client', () async {
      when(mockDatabase.getFavoriteCoins()).thenAnswer((_) async {
        return apiCoins.map((c) => c.uuid).toList();
      });
      when(mockClient.getCoins(any, any)).thenAnswer((_) async {
        return apiCoins;
      });

      List<Coin> result =
          await service.getFavoriteCoins(DefaultConfig.referenceCurrency);

      expect(result.length, 3, reason: "Not correct number of coins returned");
      for (var i = 0; i < result.length; i++) {
        expect(result[i] == apiCoins[i], true);
      }
    });
  });
}
