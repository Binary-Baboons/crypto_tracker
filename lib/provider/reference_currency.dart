import 'package:crypto_tracker/config/default_config.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final referenceCurrencyStateProvider = StateProvider<ReferenceCurrency>((ref) {
  return DefaultConfig.referenceCurrency;
});
