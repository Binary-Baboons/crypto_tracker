import 'dart:convert';

import 'package:crypto_tracker/api/service/api_service.dart';
import 'package:crypto_tracker/api/data/request_data.dart';
import 'package:crypto_tracker/model/crypto_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CoinRankingApiService extends ApiService {
  static const String baseUrl = "api.coinranking.com";
  static const String coinsApi = "v2/coins";

  @override
  Future<List<CryptoItem>> getCoins(RequestData requestData) async {
    try {
      final uri = Uri.https(baseUrl, coinsApi, requestData.toMap());
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "x-access-token": dotenv.env['COIN_RANKING_API_KEY']!,
      });

      if (response.statusCode == 200) {
        List<dynamic> coins = json.decode(response.body)['data']['coins'];
        return coins
            .map((coin) =>
            CryptoItem(
                coin['uuid'],
                coin['name'],
                coin['symbol'],
                coin['iconUrl'],
                coin['price'],
                coin['marketCap']))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<CryptoItem>> getCoin(String uuid, RequestData requestData) async {
    requestData.uuids = [uuid];
    return getCoins(requestData);
  }
}
