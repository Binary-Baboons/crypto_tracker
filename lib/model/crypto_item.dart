class CryptoItem {
  CryptoItem(this.uuid, this.rank, this.name, this.symbol, this.iconUrl,
      this.price, this.change, this.marketCap);

  final String? uuid;
  final int? rank;
  final String? name;
  final String? symbol;
  final String? iconUrl;
  final String price;
  final double change;
  final String? marketCap;
}
