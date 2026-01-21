// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_order_detail_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeOrderDetailRes _$TradeOrderDetailResFromJson(Map<String, dynamic> json) =>
    TradeOrderDetailRes(
      id: json['id'] as String?,
      type: json['type'] as String?,
      status: _dynamicToInt(json['status']),
      invalidDatetime: _dynamicToInt(json['invalidDatetime']),
      tradeAmount: _dynamicToDouble(json['tradeAmount']),
      count: _dynamicToDouble(json['count']),
      tradePrice: _dynamicToDouble(json['tradePrice']),
      fee: _dynamicToDouble(json['fee']),
      createDatetime: _dynamicToInt(json['createDatetime']),
      tradeCurrency: json['tradeCurrency'] as String?,
      tradeCoin: json['tradeCoin'] as String?,
      payType: json['payType'] as String?,
      bankName: json['bankName'] as String?,
      bankPic: json['bankPic'] as String?,
      realName: json['realName'] as String?,
      bankcardNumber: json['bankcardNumber'] as String?,
      leaveMessage: json['leaveMessage'] as String?,
      buyUser: json['buyUser'] as String?,
      sellUser: json['sellUser'] as String?,
      buyerNickname: json['buyerNickname'] as String?,
      buyerPhoto: json['buyerPhoto'] as String?,
      sellerNickname: json['sellerNickname'] as String?,
      sellerPhoto: json['sellerPhoto'] as String?,
      sbStarLevel: json['sbStarLevel'] as String?,
      sbComment: json['sbComment'] as String?,
      bsStarLevel: json['bsStarLevel'] as String?,
      bsComment: json['bsComment'] as String?,
    );

Map<String, dynamic> _$TradeOrderDetailResToJson(
  TradeOrderDetailRes instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'status': instance.status,
  'invalidDatetime': instance.invalidDatetime,
  'tradeAmount': instance.tradeAmount,
  'count': instance.count,
  'tradePrice': instance.tradePrice,
  'fee': instance.fee,
  'createDatetime': instance.createDatetime,
  'tradeCurrency': instance.tradeCurrency,
  'tradeCoin': instance.tradeCoin,
  'payType': instance.payType,
  'bankName': instance.bankName,
  'bankPic': instance.bankPic,
  'realName': instance.realName,
  'bankcardNumber': instance.bankcardNumber,
  'leaveMessage': instance.leaveMessage,
  'buyUser': instance.buyUser,
  'sellUser': instance.sellUser,
  'buyerNickname': instance.buyerNickname,
  'buyerPhoto': instance.buyerPhoto,
  'sellerNickname': instance.sellerNickname,
  'sellerPhoto': instance.sellerPhoto,
  'sbStarLevel': instance.sbStarLevel,
  'sbComment': instance.sbComment,
  'bsStarLevel': instance.bsStarLevel,
  'bsComment': instance.bsComment,
};
