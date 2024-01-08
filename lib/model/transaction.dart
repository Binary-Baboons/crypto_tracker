enum TransactionType { deposit, withdraw, fee }

enum TransactionSource { manual, ledger, kraken }

class Transaction {
  Transaction(
      this.dateTime, this.coinUuid, this.type, this.source, this.amount, this.priceForAmount,
      {transactionId})
      : transactionId = transactionId ??
            Object.hash(dateTime, coinUuid, type, amount, priceForAmount)
                .toString();

  String transactionId;
  DateTime dateTime;
  String coinUuid;
  TransactionType type;
  TransactionSource source;
  double amount;
  double priceForAmount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Transaction) {
      return false;
    }
    Transaction transaction = other;

    return transactionId == transaction.transactionId &&
        dateTime == transaction.dateTime &&
        coinUuid == transaction.coinUuid &&
        type == transaction.type &&
        source == transaction.source &&
        amount == transaction.amount &&
        priceForAmount == transaction.priceForAmount;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, transactionId);

}