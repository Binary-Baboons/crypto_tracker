import 'package:crypto_tracker/model/coin.dart';
import 'package:crypto_tracker/model/reference_currency.dart';

List<Coin> expectedCoins = [
  Coin("Qwsogvtv82FCd", 1, "Bitcoin", "BTC", null, "\$41,937.87", "-0.64 %",
      "\$820,827,859,943.00", <String?>[]),
  Coin("razxDUgYGNAdQ", 2, "Ethereum", "ETH", null, "\$0.00058481", "-1.58 %",
      "\$270,067,151,596.00", <String?>[]),
  Coin("HIVsRcGKkPFtW", 3, "Tether USD", "USDT", null, "\$1.003", "0.00 %",
      "\$91,212,341,597.00", <String?>[]),
];

List<ReferenceCurrency> expectedCurrencies = [
  ReferenceCurrency(
    "yhjMzLPhuIDl",
    "fiat",
    "https://cdn.coinranking.com/kz6a7w6vF/usd.svg",
    "US Dollar",
    "USD",
    "\$",
  ),
  ReferenceCurrency(
    "5k-_VTxqtCEI",
    "fiat",
    "https://cdn.coinranking.com/fz3P5lsJY/eur.svg",
    "Euro",
    "EUR",
    "e",
  ),
  ReferenceCurrency(
    "K4iOZMuz76cc",
    "fiat",
    "https://cdn.coinranking.com/tDtpsWiy9/malaysian-ringgit.svg",
    "Malaysian Ringgit",
    "MYR",
    "RM",
  ),
];
