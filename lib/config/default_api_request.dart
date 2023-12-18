import '../api/data/coins/request_data.dart';

abstract class  DefaultApiRequestConfig {
  static const referenceCurrencyUuid = "yhjMzLPhuIDl";
  static const orderBy = OrderBy.marketCap;
  static const orderDirection = OrderDirection.desc;
  static const limit = 50;
  static const offset = 0;
  static const timePeriod = TimePeriod.t24h;
}