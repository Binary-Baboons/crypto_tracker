import 'dart:developer';

import 'package:crypto_tracker/api/client/reference_currencies.dart';
import 'package:crypto_tracker/api/data/response_data.dart';
import 'package:crypto_tracker/model/reference_currency.dart';

import '../error/handler.dart';

class ReferenceCurrenciesService {
  ReferenceCurrenciesService(this.referenceCurrenciesApiClient);

  ReferenceCurrenciesApiClient<ReferenceCurrency> referenceCurrenciesApiClient;

  Future<(List<ReferenceCurrency>, String?)> getReferenceCurrencies() async {
    try {
      ResponseData<ReferenceCurrency> currenciesData =
      await referenceCurrenciesApiClient.getReferenceCurrencies();

      return (currenciesData.data, currenciesData.message);
    }
    catch (e) {
      return (<ReferenceCurrency>[], ErrorHandler.getUserFriendlyMessage(e));
    }
  }
}