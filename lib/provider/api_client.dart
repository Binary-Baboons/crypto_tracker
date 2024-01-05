import 'package:crypto_tracker/api/client/coins.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../api/client/reference_currencies.dart';

final ioClientProvider = Provider<BaseClient>((ref) {
  return IOClient();
});

final coinsApiClientProvider = Provider<CoinsApiClient>((ref) {
  final client = ref.watch(ioClientProvider);
  return CoinsApiClient(client);
});

final referenceCurrenciesApiClientProvider = Provider<ReferenceCurrenciesApiClient>((ref) {
  final client = ref.watch(ioClientProvider);
  return ReferenceCurrenciesApiClient(client);
});