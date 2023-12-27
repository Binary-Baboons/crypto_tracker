import 'dart:convert';

import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class ReferenceCurrenciesApiClient<T> {
  static const String baseUrl = "api.coinranking.com";
  static const String coinsApi = "v2/reference-currencies";
  static const String coinRankingApiKey = "COIN_RANKING_API_KEY";

  ReferenceCurrenciesApiClient(this.client);

  BaseClient client;

  Future<List<ReferenceCurrency>> getReferenceCurrencies() async {
      final uri = Uri.https(baseUrl, coinsApi);
      final response = await client.get(uri, headers: {
        "Content-Type": "application/json",
        "x-access-token": dotenv.env[coinRankingApiKey]!,
      });

      var body = json.decode(response.body);

      String? message = body['message'];
      if (response.statusCode != 200) {
        throw ClientException(message!);
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

      return currencies;
  }
}