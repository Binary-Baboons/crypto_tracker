import 'coin.dart';

class TransactionGrouping {
  TransactionGrouping(this.coinUuid, this.averagePrice, this.sumAmount);

  String coinUuid;
  double averagePrice;
  double sumAmount;
  Coin? coin;
  double? groupingValue;
  double? change;
  double? profitAndLoss;

  set setAndCalculateForCoin(Coin coin) {
    this.coin = coin;
    groupingValue = _calculateGroupingValue();
    change = _calculateChange();
    profitAndLoss = _calculateProfitAndLoss();
  }


  double _calculateGroupingValue() {
    return sumAmount * coin!.price;
  }

  double _calculateChange() {
   return ((coin!.price * sumAmount - averagePrice * sumAmount) / (averagePrice * sumAmount)) * 100;
  }

  double _calculateProfitAndLoss() {
    return (coin!.price * sumAmount) - (averagePrice * sumAmount);
  }
}