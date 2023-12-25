import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../api/client/reference_currencies.dart';
import '../model/reference_currency.dart';

final ioClientProvider = Provider<IOClient>((ref) {
  return IOClient();
});

final coinsApiClientProvider = Provider<CoinsApiClient<Coin>>((ref) {
  final client = ref.watch(ioClientProvider);
  return CoinsApiClient(client);
});

final referenceCurrenciesApiClientProvider = Provider<ReferenceCurrenciesApiClient<ReferenceCurrency>>((ref) {
  final client = ref.watch(ioClientProvider);
  return ReferenceCurrenciesApiClient(client);
});