import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/error/empty_result_exception.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:intl/intl.dart';

import '../api/data/coins.dart';

class CoinsService {
  CoinsService(this.coinsApiClient, this.coinsDatabase);

  CoinsApiClient coinsApiClient;
  CoinsDatabase coinsDatabase;

  Future<List<Coin>> getCoins(
      CoinsRequestData requestData, ReferenceCurrency referenceCurrency) async {
    List<Coin> coins =
        await coinsApiClient.getCoins(requestData, referenceCurrency.uuid);

    if (coins.isEmpty) {
      throw EmptyResultException();
    }

    // TODO: Cache this
    List<String> coinUuids = await coinsDatabase.getFavoriteCoins();
    coins
        .where((c) => coinUuids.contains(c.uuid))
        .forEach((c) => c.addToFavorites());

    return (_format(coins, referenceCurrency));
  }

  Future<List<Coin>> getFavoriteCoins() async {
    List<String> coinUuids = await coinsDatabase.getFavoriteCoins();

    if (coinUuids.isEmpty) {
      return [];
    }

    // TODO: Replace with currently selected
    List<Coin> coins = await coinsApiClient.getCoins(
        CoinsRequestData(uuids: coinUuids),
        DefaultConfig.referenceCurrency.uuid);

    coins.forEach((c) => c.addToFavorites());

    return (_format(coins, DefaultConfig.referenceCurrency));
  }

  void addFavoriteCoin(String uuid) async {
    await coinsDatabase.addFavoriteCoin(uuid);
  }

  void deleteFavoriteCoin(String uuid) async {
    await coinsDatabase.deleteFavoriteCoin(uuid);
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

      double price = double.parse(coin.price!);
      coin.price = NumberFormat.currency(
              symbol: referenceCurrency.getSignSymbol(),
              decimalDigits: getDecimal(price))
          .format(price);
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

    String priceStr = price.toString();
    int firstNonZeroIndex = priceStr.indexOf(RegExp(r'[1-9]'));
    return 5 + firstNonZeroIndex - priceStr.indexOf('.') - 1;
  }
}
