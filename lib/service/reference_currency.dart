import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/model/reference_currency.dart';

class ReferenceCurrenciesService {
  ReferenceCurrenciesService(this.referenceCurrenciesApiClient);

  ReferenceCurrenciesApiClient referenceCurrenciesApiClient;

  Future<List<ReferenceCurrency>> getReferenceCurrencies() async {
    return await referenceCurrenciesApiClient.getReferenceCurrencies();
  }
}
