import 'package:crypto_tracker/api/client/base_client_config.dart';
import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';

import '../../test_data/api_client.dart';
import '../../test_data/expected_data.dart';

@GenerateMocks([CoinsApiClient, IOClient])
void main() {
  dotenv.testLoad(mergeWith: {BaseClientConfig.coinRankingApiKey: "api_key"});

  group('CoinsApiClient', () {
    test('getCoins returns data on successful http call', () async {
      final client = CoinsApiClient(mockCoinsClientOk());

      List<Coin> result = await client.getCoins(CoinsRequestData(), DefaultConfig.referenceCurrency.uuid);

      expect(result.length, 4,
          reason: "Response is not of expected length");
      for (var i=0; i<result.length; i++) {
        expect(result[i] == apiCoins[i], true);
      }
    });

    test('getCoins returns a http client error', () async {
      final client = CoinsApiClient(mockCoinsClientError());
      final requestData = CoinsRequestData(search: "testcoin");

      expect(() => client.getCoins(requestData, DefaultConfig.referenceCurrency.uuid), throwsA(isA<http.ClientException>()));
    });
  });
}