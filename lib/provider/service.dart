import 'package:crypto_tracker/provider/database.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:crypto_tracker/service/image.dart';
import 'package:crypto_tracker/service/reference_currency.dart';
import 'package:crypto_tracker/service/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

final coinsServiceProvider = Provider<CoinsService>((ref) {
  var coinsClient = ref.read(coinsApiClientProvider);
  var coinsStore = ref.read(coinsStoreProvider);
  return CoinsService(coinsClient, coinsStore);
});

final referenceCurrenciesServiceProvider = Provider<ReferenceCurrenciesService>((ref) {
  var referenceCurrenciesService = ref.read(referenceCurrenciesApiClientProvider);
  return ReferenceCurrenciesService(referenceCurrenciesService);
});

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

final transactionServiceProvider = Provider<TransactionService>((ref) {
  var transactionStore = ref.read(transactionStoreProvider);
  return TransactionService(transactionStore);
});