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

class RequestData {
  RequestData({this.orderBy,
    this.orderDirection,
    this.limit,
    this.offset,
    this.symbols,
    this.uuids}) {
    orderBy = orderBy ?? OrderBy.marketCap;
    orderDirection = orderDirection ?? OrderDirection.desc;
    limit = limit ?? 50;
    offset = offset ?? 0;
    symbols = symbols;
    uuids = uuids;
  }

  OrderBy? orderBy;
  OrderDirection? orderDirection;
  int? limit;
  int? offset;
  List<String>? symbols;
  List<String>? uuids;

  Map<String, String> toMap() {
    return {
      'orderBy': orderBy!.toShortString,
      'orderDirection': orderDirection!.toShortString,
      'limit': limit.toString(),
      'offset': offset.toString(),
      if (symbols != null)
      'symbols': symbols!.join(','),
      if (uuids != null)
      'uuids': uuids!.join(',')
    };
  }
}
