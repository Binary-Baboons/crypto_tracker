import 'dart:convert';

import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/api/data/response_data.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class CoinsApiClient<T> {
  static const String baseUrl = "api.coinranking.com";
  static const String coinsApi = "v2/coins";
  static const String coinRankingApiKey = "COIN_RANKING_API_KEY";

  CoinsApiClient(this.client);

  BaseClient client;

  Future<ResponseData<T>> getCoins(CoinsRequestData requestData) async {
    final uri = Uri.https(baseUrl, coinsApi, requestData.toJsonMap());
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json",
      "x-access-token": dotenv.env[coinRankingApiKey]!,
    });

    var body = json.decode(response.body);

    String? message = body['message'];
    List<Coin> coins = (body['data']['coins'] as List)
        .map((coin) =>
        Coin(
            coin['uuid'],
            coin['rank'],
            coin['name'],
            coin['symbol'],
            coin['iconUrl'],
            coin['price'],
            coin['change'],
            coin['marketCap']))
        .toList();

    return ResponseData<T>(response.statusCode, coins.cast<T>(), message);
  }
}