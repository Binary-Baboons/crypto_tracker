class Coin {
  Coin(this.uuid, this.rank, this.name, this.symbol, this.iconUrl, this.price,
      this.change, this.marketCap): favorite = false;

  String? uuid;
  int? rank;
  String? name;
  String? symbol;
  String? iconUrl;
  String? price;
  String? change;
  String? marketCap;
  bool favorite;

  void addToFavorites() {
    favorite = true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Coin) {
      return false;
    }
    Coin coin = other;

    return uuid == coin.uuid &&
        rank == coin.rank &&
        name == coin.name &&
        symbol == coin.symbol &&
        iconUrl == coin.iconUrl &&
        price == coin.price &&
        change == coin.change &&
        marketCap == coin.marketCap;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, uuid);
}
