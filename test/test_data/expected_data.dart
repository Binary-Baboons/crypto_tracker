import 'dart:core';

import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';
import 'package:crypto_tracker/model/transaction.dart';
import 'package:crypto_tracker/model/transaction_grouping.dart';

List<Coin> apiCoins = [
  Coin("Qwsogvtv82FCd", 1, "Bitcoin", "BTC", null, 41937.86733374465, -0.64,
      820827859943.00, <double?>[]),
  Coin("razxDUgYGNAdQ", 2, "Ethereum", "ETH", null, 0.000584809755861, -1.58,
      270067151596.00, <double?>[]),
  Coin("HIVsRcGKkPFtW", 3, "Tether USD", "USDT", null, 1.0032980478762021, 0.00,
      91212341597.00, <double?>[]),
  Coin("uuid", 4, "meme coin", "MEMEC", null, 0.0032980478762021, 0, 0, <double?>[]),
];

List<Coin> serviceCoins = apiCoins.where((c) => c.isValidForDisplay()).toList();

List<ReferenceCurrency> expectedCurrencies = [
  ReferenceCurrency(
    "yhjMzLPhuIDl",
    "fiat",
    null,
    "US Dollar",
    "USD",
    "\$",
  ),
  ReferenceCurrency(
    "5k-_VTxqtCEI",
    "fiat",
    null,
    "Euro",
    "EUR",
    "e",
  ),
  ReferenceCurrency(
    "K4iOZMuz76cc",
    "fiat",
    null,
    "Malaysian Ringgit",
    "MYR",
    "RM",
  ),
];

List<Transaction> dbTransactions = [
  Transaction(DateTime.now(), serviceCoins[0].uuid, TransactionType.deposit, TransactionSource.manual, 1.6, 1000),
  Transaction(DateTime.now(), serviceCoins[0].uuid, TransactionType.deposit, TransactionSource.manual, 3.5, 200),
  Transaction(DateTime.now(), serviceCoins[0].uuid, TransactionType.withdraw, TransactionSource.manual, 1.3, 2000),
  Transaction(DateTime.now(), serviceCoins[0].uuid, TransactionType.fee, TransactionSource.manual, 0.1, 5),
];

// optional values will be overwritten in the service with the same values
List<TransactionGrouping> dbTransactionGroupings = [
  TransactionGrouping(serviceCoins[0].uuid, 10000, 12.2, change: 319.3786733374465, profitAndLoss: 389641.9814716847),
  TransactionGrouping(serviceCoins[1].uuid, 0.001, 1.5, change: -41.5190244139, profitAndLoss: -0.0006227853662085)
];