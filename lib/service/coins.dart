import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/data/coin_price.dart';
import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/error/exception/empty_result.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';

import '../api/data/coins.dart';

class CoinsService {
  CoinsService(this.coinsApiClient, this.coinsStore);

  CoinsApiClient coinsApiClient;
  CoinsStore coinsStore;

  Future<List<Coin>> getCoins(
      CoinsRequestData requestData, ReferenceCurrency referenceCurrency) async {
    List<Coin> coins =
        await coinsApiClient.getCoins(requestData, referenceCurrency.uuid);

    coins = coins.where((c) => c.isValidForDisplay()).toList();
    if (coins.isEmpty) {
      throw EmptyResultException();
    }

    List<String> coinUuids = await coinsStore.getFavoriteCoins();
    coins
        .where((c) => coinUuids.contains(c.uuid))
        .forEach((c) => c.favorite = true);

    return coins;
  }

  Future<List<Coin>> getFavoriteCoins(
      ReferenceCurrency referenceCurrency) async {
    List<String> coinUuids = await coinsStore.getFavoriteCoins();

    if (coinUuids.isEmpty) {
      return [];
    }

    return await getCoins(
        CoinsRequestData(uuids: coinUuids), referenceCurrency);
  }

  void addFavoriteCoin(String uuid) async {
    await coinsStore.addFavoriteCoin(uuid);
  }

  void deleteFavoriteCoin(String uuid) async {
    await coinsStore.deleteFavoriteCoin(uuid);
  }

  Future<String> getCoinPrice(CoinPriceRequestData requestData,
      ReferenceCurrency referenceCurrency) async {
    return await coinsApiClient.getCoinPrice(
        requestData, referenceCurrency.uuid);
  }
}
