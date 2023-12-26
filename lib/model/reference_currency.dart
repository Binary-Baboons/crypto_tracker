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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! ReferenceCurrency) {
      return false;
    }
    ReferenceCurrency currency = other;

    return uuid == currency.uuid &&
        type == currency.type &&
        iconUrl == currency.iconUrl &&
        name == currency.name &&
        symbol == currency.symbol &&
        sign == currency.sign;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, uuid.hashCode);

}
