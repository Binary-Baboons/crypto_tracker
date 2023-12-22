class ReferenceCurrency {
  ReferenceCurrency(
      this.uuid, this.type, this.iconUrl, this.name, this.symbol, this.sign);

  String uuid;
  String? type;
  String? iconUrl;
  String? name;
  String? symbol;
  String? sign;

  String getSignSymbol() {
    return sign != null ? sign! : symbol!;
  }

  @override
  String toString() {
    return "$name (${getSignSymbol()})";
  }
}

extension Equals on ReferenceCurrency {
  bool equals(ReferenceCurrency currency) {
    if (identical(this, currency)) {
      return true;
    }

    return uuid == currency.uuid &&
        type == currency.type &&
        iconUrl == currency.iconUrl &&
        name == currency.name &&
        symbol == currency.symbol &&
        sign == currency.sign;
  }
}
