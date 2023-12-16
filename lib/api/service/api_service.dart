import 'package:crypto_tracker/api/data/request_data.dart';

import '../../model/crypto_item.dart';

abstract class ApiService {
  Future<List<CryptoItem>> getCoins(RequestData requestData);

  Future<List<CryptoItem>> getCoin(String uuid, RequestData requestData);
}