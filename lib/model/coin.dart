class Coin {
  Coin(this.uuid, this.rank, this.name, this.symbol, this.iconUrl, this.price,
      this.change, this.marketCap,
      {this.sparkline, this.favorite = false});

  String? uuid;
  int? rank;
  String? name;
  String? symbol;
  String? iconUrl;
  String? price;
  List<String?>? sparkline;
  String? change;
  String? marketCap;
  bool favorite;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Coin) {
      return false;
    }
    Coin coin = other;

    if ((sparkline == null && coin.sparkline != null) || (sparkline != null && coin.sparkline == null)) {
      return false;
    }

    for (int i = 0; i < sparkline!.length; i++) {
      if (sparkline == null && coin.sparkline == null) {
        break;
      }

      if (sparkline![i] != coin.sparkline![i]) {
        return false;
      }
    }

    return uuid == coin.uuid &&
        rank == coin.rank &&
        name == coin.name &&
        symbol == coin.symbol &&
        iconUrl == coin.iconUrl &&
        price == coin.price &&
        change == coin.change &&
        marketCap == coin.marketCap &&
        favorite == coin.favorite;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, uuid);
}
