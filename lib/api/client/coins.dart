import 'dart:convert';

import 'package:crypto_tracker/api/data/coin_price.dart';
import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'config.dart';

class CoinsApiClient {
  static const String coinsApi = "v2/coins";
  static const String coinPriceApi = "v2/coin/{uuid}/price";
  BaseClient client;

  CoinsApiClient(this.client);

  Future<List<Coin>> getCoins(
      CoinsRequestData requestData, String referenceCurrencyUuid) async {
    final uri = Uri.https(ClientConfig.baseUrl, coinsApi,
        requestData.prepareParams(referenceCurrencyUuid));
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json",
      "x-access-token": dotenv.env[ClientConfig.coinRankingApiKey]!,
    });

    var body = json.decode(response.body);

    String? message = body['message'];
    if (response.statusCode != 200) {
      throw ClientException(message!);
    }

    List<Coin> coins = (body['data']['coins'] as List)
        .map((coin) => Coin(
            coin['uuid'],
            coin['rank'],
            coin['name'],
            coin['symbol'],
            coin['iconUrl'],
            double.parse(coin['price']?.toString() ?? "0"),
            double.parse(coin['change']?.toString() ?? "0"),
            double.parse(coin['marketCap']?.toString() ?? "0"),
            (coin['sparkline'] as List)
                .where((item) => item != null)
                .map((item) =>
                    item != null ? double.tryParse(item.toString()) : null)
                .toList()))
        .toList();

    return coins;
  }

  Future<String> getCoinPrice(
      CoinPriceRequestData requestData, String referenceCurrencyUuid) async {
    final route = coinPriceApi.replaceFirst("{uuid}", requestData.coinUuid);
    final uri = Uri.https(ClientConfig.baseUrl, route,
        requestData.prepareParams(referenceCurrencyUuid));
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json",
      "x-access-token": dotenv.env[ClientConfig.coinRankingApiKey]!,
    });

    var body = json.decode(response.body);

    String? message = body['message'];
    if (response.statusCode != 200) {
      throw ClientException(message!);
    }

    return body['data']['price'];
  }
}
