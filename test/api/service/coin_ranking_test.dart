import 'dart:io';

import 'package:crypto_tracker/api/data/coins/request_data.dart';
import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/api/service/coin_ranking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const coinsDataPath = "test/resources/coins.json";

void main() {
  dotenv.testLoad(mergeWith: {CoinRankingApiService.coinRankingApiKey: "api_key"});

  group('CoinRankingApiService', () {
    test('getCoins returns data on successful http call', () async {
      var data = await File(coinsDataPath).readAsString();
      final mockClient = MockClient((request) async {
        return http.Response(data, 200);
      });

      final service = CoinRankingApiService(mockClient);
      final requestData = CoinsRequestData();

      final result = await service.getCoins(requestData);

      expect(result, isA<CoinsResponseData>(),
          reason: "Response is not of expected type");
      expect(result.statusCode, 200, reason: "Status code is not 200");
      expect(result.message, null, reason: "Message is not empty");
    });

    test('getCoins returns a http client error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"message":"Reference currency not available"}', 422);
      });

      final service = CoinRankingApiService(mockClient);
      final requestData = CoinsRequestData(search: "testcoin");

      final result = await service.getCoins(requestData);

      expect(result, isA<CoinsResponseData>(),
          reason: "Response is not of expected type");
      expect(result.statusCode, 422, reason: "Status code is not 422");
      expect(result.message, "Reference currency not available", reason: "Message is not equal");
    });

    test('getCoins returned an internal error', () async {
      final mockClient = MockClient((request) async {
        throw Exception();
      });

      final service = CoinRankingApiService(mockClient);
      final requestData = CoinsRequestData();

      final result = await service.getCoins(requestData);

      expect(result.statusCode, 500, reason: "Status code is not 500");
      expect(result.message, "Internal application error", reason: "Message is not equal");
    });
  });
}
