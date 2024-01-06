import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/provider/service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final referenceCurrenciesStateProvider = StateProvider<Future<List<ReferenceCurrency>>?>((ref) {
  Future<List<ReferenceCurrency>>? referenceCurrencies;

  var service = ref.read(referenceCurrenciesServiceProvider);
  referenceCurrencies = service.getReferenceCurrencies();
  return referenceCurrencies;
});

final selectedReferenceCurrencyStateProvider = StateProvider<ReferenceCurrency>((ref) {
  return DefaultConfig.referenceCurrency;
});
