enum TransactionType {
  withdraw, deposit, fee
}

enum TransactionSource {
  manual, ledger, kraken
}

class Transaction {
  Transaction(this.transactionId, this.dateTime, this.coinUuid, this.type, this.amount, this.priceAtTime);

  String transactionId;
  DateTime dateTime;
  String coinUuid;
  TransactionType type;
  double amount;
  double priceAtTime;
}