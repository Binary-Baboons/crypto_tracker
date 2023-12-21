import 'package:crypto_tracker/model/reference_currency.dart';

import '../api/data/coins.dart';

abstract class DefaultApiRequestConfig {
  static const referenceCurrencyUuid = "yhjMzLPhuIDl";
  static const orderBy = OrderBy.marketCap;
  static const orderDirection = OrderDirection.desc;
  static const limit = 50;
  static const offset = 0;
  static const timePeriod = TimePeriod.t24h;
}

abstract class DefaultConfig {
  static final ReferenceCurrency referenceCurrency = ReferenceCurrency(
      "yhjMzLPhuIDl",
      "fiat",
      "https://cdn.coinranking.com/kz6a7w6vF/usd.svg",
      "US Dollar",
      "USD",
      "\$");
}
