class ReferenceCurrency {
  ReferenceCurrency(this.uuid, this.type, this.iconUrl, this.name, this.symbol,
      this.sign);

  String? uuid;
  String? type;
  String? iconUrl;
  String? name;
  String? symbol;
  String? sign;

  @override
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! ReferenceCurrency) {
      return false;
    }

    return uuid == other.uuid &&
        type == other.type &&
        name == other.name &&
        symbol == other.symbol &&
        iconUrl == other.iconUrl &&
        sign == other.sign;
  }

  @override
  int get hashCode => Object.hash(uuid.hashCode, type.hashCode, name.hashCode, symbol.hashCode, iconUrl.hashCode, sign.hashCode);
}
