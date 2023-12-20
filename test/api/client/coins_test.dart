import 'dart:io';

import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/api/data/response_data.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';

const coinsDataPath = "test/resources/coins.json";

@GenerateMocks([CoinsApiClient])
void main() {
  dotenv.testLoad(mergeWith: {CoinsApiClient.coinRankingApiKey: "api_key"});

  group('CoinsApiClient', () {
    test('getCoins returns data on successful http call', () async {
      var data = await File(coinsDataPath).readAsString();
      final mockClient = MockClient((request) async {
        return http.Response(data, 200);
      });

      final client = CoinsApiClient<Coin>(mockClient);
      final requestData = CoinsRequestData();

      ResponseData<Coin> result = await client.getCoins(requestData);

      expect(result.data.length, 3,
          reason: "Response is not of expected length");
      expect(result.statusCode, 200, reason: "Status code is not 200");
      expect(result.message, null, reason: "Message is not null");
    });

    test('getCoins returns a http client error', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            '{"data":{"coins":[]},"message":"Reference currency not available"}',
            422);
      });

      final client = CoinsApiClient(mockClient);
      final requestData = CoinsRequestData(search: "testcoin");

      final result = await client.getCoins(requestData);

      expect(result.data, [], reason: "Response is not empty");
      expect(result.statusCode, 422, reason: "Status code is not 422");
      expect(result.message, "Reference currency not available",
          reason: "Message is not equal");
    });
  });
}
