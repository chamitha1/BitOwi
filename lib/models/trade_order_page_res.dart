import 'package:json_annotation/json_annotation.dart';

part 'trade_order_page_res.g.dart';

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
  final int? buyUser;
  final String? buyerNickname;
  final String? buyerPhoto;
  final int? sellUser;
  final String? sellerNickname;
  final String? sellerPhoto;
  final List<dynamic>? statusList;
  final String? id;
  final String? type;
  final String? tradeCurrency;
  final String? tradeCoin;
  final String? tradeAmount;
  final String? count;
  final String? number;
  final int? userId;
  final String? realName;
  final String? status;
  final String? createDatetime;

  TradeOrderItem({
    this.buyUser,
    this.buyerNickname,
    this.buyerPhoto,
    this.sellUser,
    this.sellerNickname,
    this.sellerPhoto,
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
  });

  factory TradeOrderItem.fromJson(Map<String, dynamic> json) =>
      _$TradeOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$TradeOrderItemToJson(this);
}
