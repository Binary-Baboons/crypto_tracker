import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/database/coins.dart';
import 'package:crypto_tracker/provider/database.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:crypto_tracker/service/image.dart';
import 'package:crypto_tracker/service/reference_currency.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

final coinsServiceProvider = Provider<CoinsService>((ref) {
  CoinsApiClient coinsClient = ref.watch(coinsApiClientProvider);
  CoinsStore coinsDatabase = ref.watch(coinsStoreProvider);
  return CoinsService(coinsClient, coinsDatabase);
});

final referenceCurrenciesServiceProvider = Provider<ReferenceCurrenciesService>((ref) {
  ReferenceCurrenciesApiClient referenceCurrenciesService = ref.watch(referenceCurrenciesApiClientProvider);
  return ReferenceCurrenciesService(referenceCurrenciesService);
});

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});