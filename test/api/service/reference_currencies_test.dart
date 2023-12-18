import 'dart:io';

import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/api/data/response_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const referenceCurrenciesDataPath = "test/resources/reference_currencies.json";

void main() {
  dotenv.testLoad(mergeWith: {
    CoinRankingReferenceCurrenciesApiClient.coinRankingApiKey: "api_key"
  });

  group('CoinRankingReferenceCurrenciesApiClient', () {
    test('getReferenceCurrencies returns data on successful http call',
            () async {
          var data = await File(referenceCurrenciesDataPath).readAsString();
          final mockClient = MockClient((request) async {
            return http.Response(data, 200);
          });

          final service = CoinRankingReferenceCurrenciesApiClient(mockClient);

          final result = await service.getReferenceCurrencies();

          expect(result, isA<ResponseData>(),
              reason: "Response is not of expected type");
          expect(result.statusCode, 200, reason: "Status code is not 200");
          expect(result.message, null, reason: "Message is not empty");
        });

    test('getReferenceCurrencies returns a http client error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"message":"Internal server error"}', 500);
      });

      final service = CoinRankingReferenceCurrenciesApiClient(mockClient);

      final result = await service.getReferenceCurrencies();

      expect(result, isA<ResponseData>(),
          reason: "Response is not of expected type");
      expect(result.statusCode, 500, reason: "Status code is not 422");
      expect(result.message, "Internal server error",
          reason: "Message is not equal");
    });

    test('getReferenceCurrencies returned an internal error', () async {
      final mockClient = MockClient((request) async {
        throw Exception();
      });

      final service = CoinRankingReferenceCurrenciesApiClient(mockClient);

      final result = await service.getReferenceCurrencies();

      expect(result.statusCode, 500, reason: "Status code is not 500");
      expect(result.message, "Internal application error",
          reason: "Message is not equal");
    });
  });
}
