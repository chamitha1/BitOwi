import 'package:json_annotation/json_annotation.dart';

part 'trade_order_detail_res.g.dart';

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
class TradeOrderDetailRes {
  final String? id;
  final String? type; 
  
  @JsonKey(fromJson: _dynamicToInt)
  final int? status; 
  
  @JsonKey(fromJson: _dynamicToInt)
  final int? invalidDatetime;
  
  @JsonKey(fromJson: _dynamicToDouble)
  final double? tradeAmount;
  
  @JsonKey(fromJson: _dynamicToDouble)
  final double? count;
  
  @JsonKey(fromJson: _dynamicToDouble)
  final double? tradePrice;
  
  @JsonKey(fromJson: _dynamicToDouble)
  final double? fee;
  
  @JsonKey(fromJson: _dynamicToInt)
  final int? createDatetime;
  
  final String? tradeCurrency; 
  final String? tradeCoin; 
  
  final String? payType; 
  final String? bankName;
  final String? bankPic;
  final String? realName;
  final String? bankcardNumber;
  final String? leaveMessage;
  
  final String? buyUser;
  final String? sellUser;
  final String? buyerNickname;
  final String? buyerPhoto;
  final String? sellerNickname;
  final String? sellerPhoto;
  
  final String? sbStarLevel;
  final String? sbComment;
  final String? bsStarLevel;
  final String? bsComment;

  TradeOrderDetailRes({
    this.id,
    this.type,
    this.status,
    this.invalidDatetime,
    this.tradeAmount,
    this.count,
    this.tradePrice,
    this.fee,
    this.createDatetime,
    this.tradeCurrency,
    this.tradeCoin,
    this.payType,
    this.bankName,
    this.bankPic,
    this.realName,
    this.bankcardNumber,
    this.leaveMessage,
    this.buyUser,
    this.sellUser,
    this.buyerNickname,
    this.buyerPhoto,
    this.sellerNickname,
    this.sellerPhoto,
    this.sbStarLevel,
    this.sbComment,
    this.bsStarLevel,
    this.bsComment,
  });

  factory TradeOrderDetailRes.fromJson(Map<String, dynamic> json) =>
      _$TradeOrderDetailResFromJson(json);

  Map<String, dynamic> toJson() => _$TradeOrderDetailResToJson(this);
}
