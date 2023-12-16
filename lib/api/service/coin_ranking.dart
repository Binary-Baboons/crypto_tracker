import 'dart:convert';

import 'package:crypto_tracker/api/data/coins/request_data.dart';
import 'package:crypto_tracker/api/data/coins/response_data.dart';
import 'package:crypto_tracker/api/service/api_service.dart';
import 'package:crypto_tracker/model/crypto_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CoinRankingApiService extends ApiService {
  static const String baseUrl = "api.coinranking.com";
  static const String coinsApi = "v2/coins";

  @override
  Future<CoinResponseData> getCoins(CoinRequestData requestData) async {
    try {
      final uri = Uri.https(baseUrl, coinsApi, requestData.toJsonMap());
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "x-access-token": dotenv.env['COIN_RANKING_API_KEY']!,
      });

      var body = json.decode(response.body);

      if (200 >= response.statusCode && response.statusCode >= 299) {
        String message = body['message'];
        return CoinResponseData(response.statusCode, [], message: message);
      }

      List<CryptoItem> coins = body['data']['coins']
          .map((coin) =>
          CryptoItem(coin['uuid'], coin['name'], coin['symbol'],
              coin['iconUrl'], coin['price'], coin['marketCap']))
          .toList();

      return CoinResponseData(response.statusCode, coins);
    } catch (e) {
      return CoinResponseData(500, [], message: "Internal application error");
    }
  }
}
