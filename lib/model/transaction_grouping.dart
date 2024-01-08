import 'coin.dart';

class TransactionGrouping {
  TransactionGrouping(this.coinUuid, this.averagePrice, this.sumAmount, {this.coin, this.change, this.profitAndLoss});

  String coinUuid;
  double averagePrice;
  double sumAmount;
  Coin? coin;
  double? change;
  double? profitAndLoss;

  double getGroupingValue() {
    return sumAmount * coin!.price;
  }
}