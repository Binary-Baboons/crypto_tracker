import 'coin.dart';

class TransactionGrouping {
  TransactionGrouping(this.coinUuid, this.averagePrice, this.sumAmount, this.totalSpent);

  String coinUuid;
  double averagePrice;
  double sumAmount;
  double totalSpent;
  Coin? coin;
  double? groupingValue;
  double? change;
  double? profitAndLoss;
  List<TransactionSparkline>? transactionSparkline;

  set setAndCalculateForCoin(Coin coin) {
    this.coin = coin;
    groupingValue = _calculateGroupingValue();
    change = _calculateChange();
    profitAndLoss = _calculateProfitAndLoss();
    transactionSparkline = _calculateTransactionSparkline();
  }

  List<TransactionSparkline> _calculateTransactionSparkline() {
    if (coin == null) {
      return [];
    }

    List<TransactionSparkline> sparkline = [];
    int totalTimeIntervals = coin!.sparkline.length;
    DateTime sparklineEnd = DateTime.now();
    int sparklineStart = sparklineEnd.millisecondsSinceEpoch - Duration.millisecondsPerDay;
    int deltaInterval = (Duration.millisecondsPerDay / totalTimeIntervals).round();

    for (int i = 0; i < totalTimeIntervals; i++) {
      DateTime currentDeltaPeriod = DateTime.fromMillisecondsSinceEpoch(sparklineStart + deltaInterval * i);
      sparkline.add(TransactionSparkline(currentDeltaPeriod, coin!.sparkline[i] * sumAmount));
    }
    sparkline.add(TransactionSparkline(sparklineEnd, coin!.sparkline.last * sumAmount));
    return sparkline;
  }

  double _calculateGroupingValue() {
    if (coin == null) {
      return 0;
    }

    return sumAmount * coin!.price;
  }

  double _calculateProfitAndLoss() {
    if (coin == null) {
      return 0;
    }

    return (coin!.price * sumAmount) - (averagePrice * sumAmount);
  }

  double _calculateChange() {
    if (coin == null) {
      return 0;
    }

   return (_calculateProfitAndLoss() / (averagePrice * sumAmount)) * 100;
  }
}

class TransactionSparkline {
  TransactionSparkline(this.dateTime, this.value);

  final DateTime dateTime;
  final double value;
}