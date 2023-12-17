import 'package:crypto_tracker/api/data/coins/request_data.dart';
import 'package:crypto_tracker/api/data/coins/response_data.dart';

abstract class ApiService {
  Future<CoinsResponseData> getCoins(CoinsRequestData requestData);
}