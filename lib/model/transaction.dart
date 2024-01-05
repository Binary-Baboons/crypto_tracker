enum TransactionType {
  withdraw, deposit, fee
}

enum TransactionSource {
  manual, ledger, kraken
}

class Transaction {
  Transaction(this.dateTime, this.coinUuid, this.type, this.amount, this.priceAtTime);

  DateTime dateTime;
  String coinUuid;
  TransactionType type;
  double amount;
  double priceAtTime;
}