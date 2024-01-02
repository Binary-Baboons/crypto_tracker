import 'dart:convert';

import 'package:crypto_tracker/api/data/coins.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'base_client_config.dart';

class CoinsApiClient {
  static const String coinsApi = "v2/coins";
  BaseClient client;

  CoinsApiClient(this.client);

  Future<List<Coin>> getCoins(
      CoinsRequestData requestData, String referenceCurrencyUuid) async {
    final uri = Uri.https(BaseClientConfig.baseUrl, coinsApi,
        requestData.prepareParams(referenceCurrencyUuid));
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json",
      "x-access-token": dotenv.env[BaseClientConfig.coinRankingApiKey]!,
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
            coin['price'],
            coin['change'],
            coin['marketCap'],
            sparkline: List<String>.from(coin['sparkline'])))
        .toList();

    return coins;
  }

  // List<String> _decodeSparkline(List<Map> sparkline) {
  //   return sparkline.map((e) => e.values)
  // }
}

