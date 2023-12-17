enum OrderBy {
  marketCap,
  price,
}

enum OrderDirection { asc, desc }

extension ParseToString on Enum {
  String get getValueOnly {
    return toString()
        .split('.')
        .last;
  }
}

enum TimePeriod { t1h, t3h, t12h, t24h, t7d, t30d, t3m, t1y, t3y, t5y }

extension GetOnlyNumberAndTime on TimePeriod {
  String get getTimePeriod {
    return toString()
        .split('.')
        .last
        .substring(1);
  }
}

class CoinsRequestData {
  CoinsRequestData({this.orderBy,
    this.orderDirection,
    this.limit,
    this.offset,
    this.timePeriod,
    this.search}) {
    orderBy = orderBy ?? OrderBy.marketCap;
    orderDirection = orderDirection ?? OrderDirection.desc;
    limit = limit ?? 50;
    offset = offset ?? 0;
    timePeriod = timePeriod ?? TimePeriod.t24h;
    search = search;
  }

  OrderBy? orderBy;
  OrderDirection? orderDirection;
  int? limit;
  int? offset;
  TimePeriod? timePeriod;
  String? search;

  Map<String, String> toJsonMap() {
    return {
      'orderBy': orderBy!.getValueOnly,
      'orderDirection': orderDirection!.getValueOnly,
      'limit': limit.toString(),
      'offset': offset.toString(),
      'timePeriod': timePeriod!.getTimePeriod,
      if (search != null) 'search': search!,
    };
  }
}
