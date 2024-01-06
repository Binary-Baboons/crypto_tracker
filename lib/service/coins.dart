import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/data/coin_price.dart';
import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/error/exception/empty_result.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:intl/intl.dart';

import '../api/data/coins.dart';

class CoinsService {
  CoinsService(this.coinsApiClient, this.coinsStore);

  CoinsApiClient coinsApiClient;
  CoinsStore coinsStore;

  Future<List<Coin>> getCoins(
      CoinsRequestData requestData, ReferenceCurrency referenceCurrency) async {
    List<Coin> coins =
        await coinsApiClient.getCoins(requestData, referenceCurrency.uuid);

    if (coins.isEmpty) {
      throw EmptyResultException();
    }

    List<String> coinUuids = await coinsStore.getFavoriteCoins();
    coins
        .where((c) => coinUuids.contains(c.uuid))
        .forEach((c) => c.favorite = true);

    return (_format(coins, referenceCurrency));
  }

  Future<List<Coin>> getFavoriteCoins(
      ReferenceCurrency referenceCurrency) async {
    List<String> coinUuids = await coinsStore.getFavoriteCoins();

    if (coinUuids.isEmpty) {
      return [];
    }

    List<Coin> coins = await coinsApiClient.getCoins(
        CoinsRequestData(uuids: coinUuids),
        referenceCurrency.uuid);

    coins.forEach((c) => c.favorite = true);

    return (_format(coins, referenceCurrency));
  }

  void addFavoriteCoin(String uuid) async {
    await coinsStore.addFavoriteCoin(uuid);
  }

  void deleteFavoriteCoin(String uuid) async {
    await coinsStore.deleteFavoriteCoin(uuid);
  }

  Future<String> getCoinPrice(CoinPriceRequestData requestData, ReferenceCurrency referenceCurrency) async {
    return await coinsApiClient.getCoinPrice(requestData, referenceCurrency.uuid);
  }

  List<Coin> _format(
      List<Coin> coinsData, ReferenceCurrency referenceCurrency) {
    return coinsData
        .where((coin) => coin.price != null && coin.marketCap != null)
        .map((coin) {
      coin.change = coin.change ?? "0.00";

      coin.marketCap = NumberFormat.currency(
              symbol: referenceCurrency.getSignSymbol(), decimalDigits: 2)
          .format(double.parse(coin.marketCap!));

      var doublePrice = double.parse(coin.price!);
      coin.price = NumberFormat.currency(
              symbol: referenceCurrency.getSignSymbol(),
              decimalDigits: getDecimal(doublePrice))
          .format(doublePrice);

      coin.sparkline = coin.sparkline.map((sl) {
        if (sl == null) {
          return null;
        }

        var doubleSl = double.parse(sl);
        var formattedSl = double.parse((doubleSl).toStringAsFixed(getDecimal(doubleSl)));
        return formattedSl.toString();
      }).toList();

      return coin;
    }).toList();
  }

  int getDecimal(double price) {
    if (price >= 10) {
      return 2;
    }

    if (price >= 1) {
      return 3;
    }

    var stringPrice = price.toString();
    int firstNonZeroIndex = stringPrice.indexOf(RegExp(r'[1-9]'));
    return 5 + firstNonZeroIndex - stringPrice.indexOf('.') - 1;
  }
}
