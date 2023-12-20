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
}

extension Equals on Coin {
  bool equals(Coin coin) {
    if (identical(this, coin)) {
      return true;
    }

    return uuid == coin.uuid &&
        rank == coin.rank &&
        name == coin.name &&
        symbol == coin.symbol &&
        iconUrl == coin.iconUrl &&
        price == coin.price &&
        change == coin.change &&
        marketCap == coin.marketCap;
  }
}
