enum OrderBy {
  marketCap,
  price,
}

enum OrderDirection { asc, desc }

extension ParseToString on Enum {
  String get toShortString {
    return toString()
        .split('.')
        .last;
  }
}

class CoinRequestData {
  CoinRequestData({this.orderBy,
    this.orderDirection,
    this.limit,
    this.offset,
    this.search}) {
    orderBy = orderBy ?? OrderBy.marketCap;
    orderDirection = orderDirection ?? OrderDirection.desc;
    limit = limit ?? 50;
    offset = offset ?? 0;
    search = search;
  }

  OrderBy? orderBy;
  OrderDirection? orderDirection;
  int? limit;
  int? offset;
  String? search;

  Map<String, String> toJsonMap() {
    return {
      'orderBy': orderBy!.toShortString,
      'orderDirection': orderDirection!.toShortString,
      'limit': limit.toString(),
      'offset': offset.toString(),
      if (search != null)
      'search': search!,
    };
  }
}