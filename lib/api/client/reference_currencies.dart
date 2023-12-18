import 'dart:convert';

import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../data/response_data.dart';

abstract class ReferenceCurrenciesApiClient {
  Future<ResponseData> getReferenceCurrencies();
}

class CoinRankingReferenceCurrenciesApiClient extends ReferenceCurrenciesApiClient {
  static const String baseUrl = "api.coinranking.com";
  static const String coinsApi = "v2/reference-currencies";
  static const String coinRankingApiKey = "COIN_RANKING_API_KEY";

  CoinRankingReferenceCurrenciesApiClient(this.client);

  BaseClient client;
  
  @override
  Future<ResponseData> getReferenceCurrencies() async {
    try {
      final uri = Uri.https(baseUrl, coinsApi);
      final response = await client.get(uri, headers: {
        "Content-Type": "application/json",
        "x-access-token": dotenv.env[coinRankingApiKey]!,
      });

      var body = json.decode(response.body);

      if (response.statusCode != 200) {
        String message = body['message'];
        return ResponseData(response.statusCode, [], message: message);
      }

      List<ReferenceCurrency> currencies = (body['data']['currencies'] as List)
          .map((currency) =>
          ReferenceCurrency(
              currency['uuid'],
              currency['type'],
              currency['iconUrl'],
              currency['name'],
              currency['symbol'],
              currency['sign']))
          .toList();

      return ResponseData(response.statusCode, currencies);
    } catch (e) {
      return ResponseData(500, [], message: "Internal application error");
    }
  }
}