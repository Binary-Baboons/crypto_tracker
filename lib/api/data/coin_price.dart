class CoinPriceRequestData {
  CoinPriceRequestData(this.coinUuid, {dateTime}): dateTime = dateTime ?? DateTime.now();
  
  String coinUuid;
  DateTime dateTime;

  Map<String, String> prepareParams(String referenceCurrencyUuid) {
    return {
      'timestamp': (dateTime.millisecondsSinceEpoch / 1000).toString(),
      'referenceCurrencyUuid': referenceCurrencyUuid,
    };
  }
}