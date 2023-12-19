import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/provider/ioclient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinsApiClientProvider = Provider<CoinsApiClient<Coin>>((ref) {
  final client = ref.watch(ioClientProvider);
  return CoinsApiClient(client);
});