class Coin {
  Coin(this.uuid, this.rank, this.name, this.symbol, this.iconUrl, this.price,
      this.change, this.marketCap, sparkline,
      {this.favorite = false}) {
    for (double? sp in sparkline) {
      if (sp == null) {
        this.sparkline.add(0);
      } else {
        this.sparkline.add(sp);
      }
    }
    this.sparkline.add(price);
  }

  String uuid;
  int rank;
  String name;
  String symbol;
  String? iconUrl;
  double price;
  List<double> sparkline = [];
  double change;
  double marketCap;
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

    for (int i = 0; i < sparkline.length; i++) {
      if (sparkline[i] != coin.sparkline[i]) {
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

  bool isValidForDisplay() {
    if (price != 0 && marketCap != 0) {
      return true;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, uuid);
}
