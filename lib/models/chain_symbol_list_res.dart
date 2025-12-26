class ChainSymbolListRes {
  String? symbol;
  String? chainSymbol;
  String? chainTag;
  String? icon;

  ChainSymbolListRes({
    this.symbol,
    this.chainSymbol,
    this.chainTag,
    this.icon,
  });

  factory ChainSymbolListRes.fromJson(Map<String, dynamic> json) {
    return ChainSymbolListRes(
      symbol: json['symbol'] as String?,
      chainSymbol: json['chainSymbol'] as String?,
      chainTag: json['chainTag'] as String?,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'chainSymbol': chainSymbol,
      'chainTag': chainTag,
      'icon': icon,
    };
  }
}
