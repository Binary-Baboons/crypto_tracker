import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/api/data/response_data.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/service/reference_currency.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reference_currencies_test.mocks.dart';

@GenerateMocks([ReferenceCurrenciesApiClient])
void main() {
  dotenv.testLoad(
      mergeWith: {ReferenceCurrenciesApiClient.coinRankingApiKey: "api_key"});

  MockReferenceCurrenciesApiClient<ReferenceCurrency> mockClient =
  MockReferenceCurrenciesApiClient();
  ReferenceCurrenciesService service = ReferenceCurrenciesService(mockClient);

  group('ReferenceCurrenciesService', () {
    test('getReferenceCurrencies returns data from client', () async {
      when(mockClient.getReferenceCurrencies()).thenAnswer((_) async {
        return ResponseData(
            200,
            [
              ReferenceCurrency("qwerty", "fiat", "http", "Dollar", "\$", "USD")
            ],
            null);
      });

      (List<ReferenceCurrency>, String?) result =
      await service.getReferenceCurrencies();

      expect(
          result.$1.first.equals(ReferenceCurrency(
              "qwerty", "fiat", "http", "Dollar", "\$", "USD")),
          true,
          reason: "Reference currencies are not equal");
      expect(result.$2, null, reason: "Message is not null");
    });

    test('getReferenceCurrencies returns data from client', () async {
      when(mockClient.getReferenceCurrencies()).thenAnswer((_) async {
        return ResponseData(422, [], "Reference currency not available");
      });

      (List<ReferenceCurrency>, String?) result =
      await service.getReferenceCurrencies();

      expect(result.$1.length, 0, reason: "Reference currencies are not empty");
      expect(result.$2, "Reference currency not available",
          reason: "Message is not equal");
    });
  });
}
