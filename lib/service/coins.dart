import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:intl/intl.dart';

import '../api/data/coins.dart';
import '../api/data/response_data.dart';

class CoinsService {
  CoinsService(this.coinsApiClient);

  CoinsApiClient<Coin> coinsApiClient;

  Future<(List<Coin>, String?)> getCoins(CoinsRequestData requestData, ReferenceCurrency referenceCurrency) async {
    try {
      ResponseData<Coin> coinsData =
      await coinsApiClient.getCoins(requestData);

      return (formatPrice(coinsData.data, referenceCurrency), coinsData.message);
    }
    catch (e) {
      return (<Coin>[], "Internal application error");
    }
  }

  List<Coin> formatPrice(List<Coin> coinsData, ReferenceCurrency referenceCurrency) {
    return coinsData.where((coin) => coin.price != null).map((coin) {
      coin.price = NumberFormat.currency(
          locale: 'eu',
          symbol: referenceCurrency.symbol,
          decimalDigits: 2)
          .format(double.parse(coin.price!));
      return coin;
    }).toList();
  }
}