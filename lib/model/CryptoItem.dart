import 'dart:core';

class CryptoItem {
  CryptoItem(this.uuid, this.name, this.symbol, this.iconUrl, this.price, this.marketCap);

  final String uuid;
  final String name;
  final String symbol;
  final String iconUrl;
  final double price;
  final String marketCap;
}