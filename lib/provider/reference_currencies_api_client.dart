import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/provider/ioclient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final referenceCurrenciesApiClientProvider = Provider<ReferenceCurrenciesApiClient<ReferenceCurrency>>((ref) {
  final client = ref.watch(ioClientProvider);
  return ReferenceCurrenciesApiClient(client);
});