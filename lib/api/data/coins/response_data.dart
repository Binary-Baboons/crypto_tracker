import 'package:crypto_tracker/model/crypto_item.dart';

class CoinResponseData {
  CoinResponseData(this.statusCode, this.data, {this.message});

  List<CryptoItem> data;
  int statusCode;
  String? message;
}