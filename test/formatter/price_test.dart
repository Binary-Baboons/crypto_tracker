import 'package:crypto_tracker/api/client/config.dart';
import 'package:crypto_tracker/config/default.dart';
import 'package:crypto_tracker/formatter/price.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  dotenv.testLoad(mergeWith: {ClientConfig.coinRankingApiKey: "api_key"});

  group('PriceFormatter', () {
    test('formatPrice works correctly', () async {
      var prices = [1234.1234, 1.123456, 0.0000012345678];

      var result = prices.map((p) => PriceFormatter.formatPrice(p, DefaultConfig.referenceCurrency.getSignSymbol(),true)).toList();

      expect(result[0] == "\$1,234.12", true);
      expect(result[1] == "\$1.123", true);
      expect(result[2] == "\$0.0000012346", true);
    });
  });
}