import 'package:crypto_tracker/api/client/coins.dart';
import 'package:crypto_tracker/provider/ioclient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerB = Provider<CoinsApiClient>((ref) {
  final client = ref.watch(ioClientProvider);
  return CoinRankingCoinsApiClient(client);
});