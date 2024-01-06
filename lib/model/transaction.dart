enum TransactionType { withdraw, deposit, fee }

enum TransactionSource { manual, ledger, kraken }

class Transaction {
  Transaction(
      this.dateTime, this.coinUuid, this.type, this.amount, this.priceForAmount,
      {transactionId})
      : transactionId = transactionId ??
            Object.hash(dateTime, coinUuid, type, amount, priceForAmount)
                .toString();

  String transactionId;
  DateTime dateTime;
  String coinUuid;
  TransactionType type;
  double amount;
  double priceForAmount;
}