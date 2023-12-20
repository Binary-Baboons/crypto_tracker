import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/provider/reference_currencies_api_client.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:crypto_tracker/service/reference_currency.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'coins_api_client.dart';

final coinsServiceProvider = Provider<CoinsService>((ref) {
  CoinsApiClient<Coin> coinsClient = ref.watch(coinsApiClientProvider);
  return CoinsService(coinsClient);
});

final referenceCurrenciesServiceProvider = Provider<ReferenceCurrenciesService>((ref) {
  ReferenceCurrenciesApiClient<ReferenceCurrency> referenceCurrenciesService = ref.watch(referenceCurrenciesApiClientProvider);
  return ReferenceCurrenciesService(referenceCurrenciesService);
});