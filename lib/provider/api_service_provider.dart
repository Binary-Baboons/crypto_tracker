import 'package:crypto_tracker/api/service/coin_ranking.dart';
import 'package:crypto_tracker/provider/ioclient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/service/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final client = ref.watch(ioClientProvider);
  return CoinRankingApiService(client);
});
