import 'dart:io';

import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../api/client/coins_test.mocks.dart';

const _coins = "test/test_data/json/coins.json";
const _coinsError = "test/test_data/json/coins_error.json";
const _referenceCurrencies = "test/test_data/json/reference_currencies.json";
const _referenceCurrenciesError = "test/test_data/json/reference_currencies_error.json";

MockIOClient _setupMock(String data, int code) {
  var client = MockIOClient();
  when(client.get(any, headers: anyNamed("headers"))).thenAnswer((_) => Future.value(Response(data, code)));
  return client;
}

MockIOClient mockCoinsClientOk() {
  var data = File(_coins).readAsStringSync();
  return _setupMock(data, 200);
}

MockIOClient mockReferenceCurrenciesClientOk() {
  var data = File(_referenceCurrencies).readAsStringSync();
  return _setupMock(data, 200);
}

MockIOClient mockCoinsClientError() {
  var data = File(_coinsError).readAsStringSync();
  return _setupMock(data, 422);
}

MockIOClient mockReferenceCurrenciesClientError() {
  var data = File(_referenceCurrenciesError).readAsStringSync();
  return _setupMock(data, 422);
}