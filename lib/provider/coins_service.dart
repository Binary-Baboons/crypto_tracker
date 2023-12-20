import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/service/coins.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'coins_api_client.dart';

final coinsServiceProvider = Provider<CoinsService>((ref) {
  CoinsApiClient<Coin> coinsClient = ref.watch(coinsApiClientProvider);
  return CoinsService(coinsClient);
});