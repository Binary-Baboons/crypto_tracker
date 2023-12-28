import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';

const _coins = "test/test_data/json/coins.json";
const _coinsError = "test/test_data/json/coins_error.json";
const _referenceCurrencies = "test/test_data/json/reference_currencies.json";
const _referenceCurrenciesError = "test/test_data/json/reference_currencies_error.json";

BaseClient mockCoinsClientOk() {
  var data = File(_coins).readAsStringSync();
  return MockClient((request) async {return Response(data, 200);});
}

BaseClient mockReferenceCurrenciesClientOk() {
  var data = File(_referenceCurrencies).readAsStringSync();
  return MockClient((request) async {return Response(data, 200);});
}

BaseClient mockCoinsClientError() {
  var data = File(_coinsError).readAsStringSync();
  return MockClient((request) async {return Response(data, 422);});
}

BaseClient mockReferenceCurrenciesClientError() {
  var data = File(_referenceCurrenciesError).readAsStringSync();
  return MockClient((request) async {return Response(data, 422);});
}