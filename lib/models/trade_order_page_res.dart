import 'package:json_annotation/json_annotation.dart';

part 'trade_order_page_res.g.dart';

int? _dynamicToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _dynamicToDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@JsonSerializable()
class TradeOrderPageRes {
  final int? pageNum;
  final int? pageSize;
  final int? size;
  final int? total;
  final int? pages;
  final List<TradeOrderItem> list;

  TradeOrderPageRes({
    this.pageNum,
    this.pageSize,
    this.size,
    this.total,
    this.pages,
    this.list = const [],
  });

  factory TradeOrderPageRes.fromJson(Map<String, dynamic> json) =>
      _$TradeOrderPageResFromJson(json);

  Map<String, dynamic> toJson() => _$TradeOrderPageResToJson(this);

  bool get isEnd => list.isEmpty || (pageNum ?? 0) >= (pages ?? 0);
}

@JsonSerializable()
class TradeOrderItem {
  @JsonKey(fromJson: _dynamicToInt)
  final int? buyUser;

  final String? buyerNickname;
  final String? buyerPhoto;

  @JsonKey(fromJson: _dynamicToInt)
  final int? sellUser;

  final String? sellerNickname;
  final String? sellerPhoto;
  
  @JsonKey(name: 'buyerMerchantStatus')
  final String? buyerIsMerchant;
  
  @JsonKey(name: 'sellerMerchantStatus')
  final String? sellerIsMerchant;

  final List<dynamic>? statusList;

  @JsonKey(fromJson: _dynamicToInt)
  final int? id;

  final String? type;
  final String? tradeCurrency;
  final String? tradeCoin;

  @JsonKey(fromJson: _dynamicToDouble)
  final double? tradeAmount;

  @JsonKey(fromJson: _dynamicToDouble)
  final double? count;

  @JsonKey(fromJson: _dynamicToInt)
  final int? number;

  @JsonKey(fromJson: _dynamicToInt)
  final int? userId;

  final String? realName;

  @JsonKey(fromJson: _dynamicToInt)
  final int? status;

  @JsonKey(fromJson: _dynamicToInt)
  final int? createDatetime;

  @JsonKey(fromJson: _dynamicToInt)
  final int? adsId;

  @JsonKey(fromJson: _dynamicToInt)
  int? unReadCount;

  TradeOrderItem({
    this.buyUser,
    this.buyerNickname,
    this.buyerPhoto,
    this.sellUser,
    this.sellerNickname,
    this.sellerPhoto,
    this.buyerIsMerchant,
    this.sellerIsMerchant,
    this.statusList,
    this.id,
    this.type,
    this.tradeCurrency,
    this.tradeCoin,
    this.tradeAmount,
    this.count,
    this.number,
    this.userId,
    this.realName,
    this.status,
    this.createDatetime,
    this.adsId,
    this.unReadCount,
  });

  factory TradeOrderItem.fromJson(Map<String, dynamic> json) =>
      _$TradeOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$TradeOrderItemToJson(this);
}
