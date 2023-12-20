class Coin {
  Coin(this.uuid, this.rank, this.name, this.symbol, this.iconUrl, this.price,
      this.change, this.marketCap);

  String? uuid;
  int? rank;
  String? name;
  String? symbol;
  String? iconUrl;
  String? price;
  String? change;
  String? marketCap;

  @override
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! Coin) {
      return false;
    }

    return uuid == other.uuid &&
        rank == other.rank &&
        name == other.name &&
        symbol == other.symbol &&
        iconUrl == other.iconUrl &&
        price == other.price &&
        change == other.change &&
        marketCap == other.marketCap;
  }

  @override
  int get hashCode => Object.hash(uuid.hashCode, rank.hashCode, name.hashCode, symbol.hashCode, iconUrl.hashCode, price.hashCode, change.hashCode, marketCap.hashCode);
}
