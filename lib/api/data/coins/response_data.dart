import 'package:crypto_tracker/model/crypto_item.dart';

class CoinsResponseData {
  CoinsResponseData(this.statusCode, this.data, {this.message});

  List<CryptoItem> data;
  int statusCode;
  String? message;
}