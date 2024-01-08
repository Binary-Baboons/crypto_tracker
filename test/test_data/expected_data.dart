import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';

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
