import 'package:crypto_tracker/api_service/request_data.dart';

import '../model/crypto_item.dart';

abstract class ApiService {
  Future<List<CryptoItem>> getCoins(RequestData requestData);
}