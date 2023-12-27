import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/service/reference_currency.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../api/client/reference_currencies_test.mocks.dart';

@GenerateMocks([ReferenceCurrenciesService])
void main() {
  dotenv.testLoad(
      mergeWith: {ReferenceCurrenciesApiClient.coinRankingApiKey: "api_key"});

  MockReferenceCurrenciesApiClient<ReferenceCurrency> mockClient =
      MockReferenceCurrenciesApiClient();
  ReferenceCurrenciesService service = ReferenceCurrenciesService(mockClient);

  group('ReferenceCurrenciesService', () {
    test('getReferenceCurrencies returns data from client', () async {
      when(mockClient.getReferenceCurrencies()).thenAnswer((_) async {
        return [
          ReferenceCurrency("qwerty", "fiat", "http", "Dollar", "\$", "USD")
        ];
      });

      List<ReferenceCurrency> result = await service.getReferenceCurrencies();

      expect(
          result.first ==
              ReferenceCurrency(
                  "qwerty", "fiat", "http", "Dollar", "\$", "USD"),
          true,
          reason: "Reference currencies are not equal");
    });

    test('getReferenceCurrencies returns error message from client', () async {
      when(mockClient.getReferenceCurrencies())
          .thenThrow(ClientException("Reference currency not available"));

      expect(() => service.getReferenceCurrencies(),
          throwsA(isA<ClientException>()));
    });
  });
}
