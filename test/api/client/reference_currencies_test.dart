import 'package:crypto_tracker/api/client/base_client_config.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';

import '../../test_data/api_client.dart';

@GenerateMocks([ReferenceCurrenciesApiClient])
void main() {
  dotenv.testLoad(mergeWith: {BaseClientConfig.coinRankingApiKey: "api_key"});

  group('ReferenceCurrenciesApiClient', () {
    test('getReferenceCurrencies returns data on successful http call',
        () async {
      final client =
          ReferenceCurrenciesApiClient(mockReferenceCurrenciesClientOk());
      final result = await client.getReferenceCurrencies();
      expect(result.length, 3, reason: "Response is not of expected length");
    });

    test('getReferenceCurrencies returns a http client error', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            '{"data":{"currencies":[]},"message":"Reference currency not available"}',
            422);
      });

      final client = ReferenceCurrenciesApiClient(mockClient);

      expect(() => client.getReferenceCurrencies(),
          throwsA(isA<http.ClientException>()));
    });
  });
}
