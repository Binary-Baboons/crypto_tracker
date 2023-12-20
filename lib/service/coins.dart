import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/config/default_api_request.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:intl/intl.dart';

import '../api/data/coins.dart';
import '../api/data/response_data.dart';

class CoinsService {
  CoinsService(this.coinsApiClient);

  CoinsApiClient<Coin> coinsApiClient;

  Future<(List<Coin>, String?)> getCoins(CoinsRequestData requestData,
      ReferenceCurrency? referenceCurrency) async {
    try {
      ResponseData<Coin> coinsData = await coinsApiClient.getCoins(requestData);

      String currencySymbol = referenceCurrency != null
          ? referenceCurrency.symbol!
          : DefaultConfig.currencySymbol;
      return (format(coinsData.data, currencySymbol), coinsData.message);
    } catch (e) {
      return (<Coin>[], "Internal application error");
    }
  }

  List<Coin> format(List<Coin> coinsData, String currencySymbol) {
    return coinsData.where((coin) => coin.price != null || coin.marketCap != null).map((coin) {
      coin.change = coin.change ?? "0.0";
      coin.marketCap = NumberFormat.currency(
          locale: 'eu', symbol: currencySymbol, decimalDigits: 2)
          .format(double.parse(coin.marketCap!));
      coin.price = NumberFormat.currency(
          locale: 'eu', symbol: currencySymbol, decimalDigits: 2)
          .format(double.parse(coin.price!));
      return coin;
    }).toList();
  }
}
