import 'package:crypto_tracker/config/default_config.dart';

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

enum CategoryTag {
  defi,
  stablecoin,
  nft,
  dex,
  exchange,
  staking,
  dao,
  meme,
  privacy,
  metaverse,
  gaming,
  wrapped,
  layer_1,
  layer_2,
  fan_token,
  football_club,
  web3,
  social
}

extension FromUnderscoreToDash on CategoryTag {
  String get getValueWithDash {
    return getValueOnly.replaceFirst("_", "-");
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
      this.tier,
      this.tags,
      this.uuids}) {
    orderBy = orderBy ?? DefaultApiRequestConfig.orderBy;
    orderDirection = orderDirection ?? DefaultApiRequestConfig.orderDirection;
    limit = limit ?? DefaultApiRequestConfig.limit;
    offset = offset ?? DefaultApiRequestConfig.offset;
    timePeriod = timePeriod ?? DefaultApiRequestConfig.timePeriod;
    tier = tier ?? DefaultApiRequestConfig.tier;
    search = search;
    tags = tags;
    uuids = uuids;
  }

  OrderBy? orderBy;
  OrderDirection? orderDirection;
  int? limit;
  int? offset;
  TimePeriod? timePeriod;
  String? search;
  int? tier;
  Set<CategoryTag>? tags;
  List<String>? uuids;

  Map<String, String> prepareParams(String referenceCurrencyUuid) {
    return {
      'orderBy': orderBy!.getValueOnly,
      'orderDirection': orderDirection!.getValueOnly,
      'limit': limit.toString(),
      'offset': offset.toString(),
      'timePeriod': timePeriod!.getTimePeriod,
      'tiers[0]': tier!.toString(),
      'referenceCurrencyUuid': referenceCurrencyUuid,
      if (search != null) 'search': search!,
      if (tags != null && tags!.isNotEmpty)
        'tags': tags!.map((t) => t.getValueWithDash).join(","),
      if (uuids != null && uuids!.isNotEmpty)
        for (var i = 0; i < uuids!.length; i++)
        'uuids[$i]': uuids![i]
    };
  }
}
