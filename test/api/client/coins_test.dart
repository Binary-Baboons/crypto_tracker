import 'dart:io';

import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import '../../provider/api_client_test.dart';

@GenerateMocks([CoinsApiClient])
void main() {
  dotenv.testLoad(mergeWith: {CoinsApiClient.coinRankingApiKey: "api_key"});

  group('CoinsApiClient', () {
    test('getCoins returns data on successful http call', () async {
      final client = CoinsApiClient<Coin>(mockCoinsClientOk());

      List<Coin> result = await client.getCoins(CoinsRequestData(), DefaultConfig.referenceCurrency.uuid);

      expect(result.length, 3,
          reason: "Response is not of expected length");
    });

    test('getCoins returns a http client error', () async {
      final client = CoinsApiClient(mockCoinsClientError());
      final requestData = CoinsRequestData(search: "testcoin");

      expect(() => client.getCoins(requestData, DefaultConfig.referenceCurrency.uuid), throwsA(isA<http.ClientException>()));
    });
  });
}