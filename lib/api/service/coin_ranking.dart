import 'dart:convert';

import 'package:crypto_tracker/api/data/coins/request_data.dart';
import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/api/service/api_service.dart';
import 'package:crypto_tracker/model/crypto_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class CoinRankingApiService extends ApiService {
  static const String baseUrl = "api.coinranking.com";
  static const String coinsApi = "v2/coins";
  static const String coinRankingApiKey = "COIN_RANKING_API_KEY";

  CoinRankingApiService(this.client);

  BaseClient client;

  @override
  Future<CoinsResponseData> getCoins(CoinsRequestData requestData) async {
    try {
      final uri = Uri.https(baseUrl, coinsApi, requestData.toJsonMap());
      final response = await client.get(uri, headers: {
        "Content-Type": "application/json",
        "x-access-token": dotenv.env[coinRankingApiKey]!,
      });

      var body = json.decode(response.body);

      if (response.statusCode != 200) {
        String message = body['message'];
        return CoinsResponseData(response.statusCode, [], message: message);
      }

      List<CryptoItem> coins = (body['data']['coins'] as List)
          .map((coin) => CryptoItem(
              coin['uuid'],
              coin['rank'],
              coin['name'],
              coin['symbol'],
              coin['iconUrl'],
              coin['price'],
              coin['change'],
              coin['marketCap']))
          .toList();

      return CoinsResponseData(response.statusCode, coins);
    } catch (e) {
      return CoinsResponseData(500, [], message: "Internal application error");
    }
  }
}
