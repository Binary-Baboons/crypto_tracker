import 'package:crypto_tracker/config/default_api_request.dart';

enum OrderBy { marketCap, price, change }

enum OrderDirection { asc, desc }

extension ParseToString on Enum {
  String get getValueOnly {
    return toString().split('.').last;
  }
}

enum TimePeriod { t1h, t3h, t12h, t24h, t7d, t30d, t3m, t1y, t3y, t5y }

extension GetOnlyNumberAndTime on TimePeriod {
  String get getTimePeriod {
    return toString().split('.').last.substring(1);
  }
}

class CoinsRequestData {
  CoinsRequestData(
      {this.orderBy,
      this.orderDirection,
      this.limit,
      this.offset,
      this.timePeriod,
      this.search,
      this.referenceCurrencyUuid}) {
    orderBy = orderBy ?? DefaultApiRequestConfig.orderBy;
    orderDirection = orderDirection ?? DefaultApiRequestConfig.orderDirection;
    limit = limit ?? DefaultApiRequestConfig.limit;
    offset = offset ?? DefaultApiRequestConfig.offset;
    timePeriod = timePeriod ?? DefaultApiRequestConfig.timePeriod;
    referenceCurrencyUuid =
        referenceCurrencyUuid ?? DefaultApiRequestConfig.referenceCurrencyUuid;
    search = search;
  }

  OrderBy? orderBy;
  OrderDirection? orderDirection;
  int? limit;
  int? offset;
  TimePeriod? timePeriod;
  String? search;
  String? referenceCurrencyUuid;

  Map<String, String> toJsonMap() {
    return {
      'orderBy': orderBy!.getValueOnly,
      'orderDirection': orderDirection!.getValueOnly,
      'limit': limit.toString(),
      'offset': offset.toString(),
      'timePeriod': timePeriod!.getTimePeriod,
      'referenceCurrencyUuid': DefaultApiRequestConfig.referenceCurrencyUuid,
      if (search != null) 'search': search!,
    };
  }
}
