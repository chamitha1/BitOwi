// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_order_page_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeOrderPageRes _$TradeOrderPageResFromJson(Map<String, dynamic> json) =>
    TradeOrderPageRes(
      pageNum: (json['pageNum'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      pages: (json['pages'] as num?)?.toInt(),
      list:
          (json['list'] as List<dynamic>?)
              ?.map((e) => TradeOrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TradeOrderPageResToJson(TradeOrderPageRes instance) =>
    <String, dynamic>{
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
      'size': instance.size,
      'total': instance.total,
      'pages': instance.pages,
      'list': instance.list,
    };

TradeOrderItem _$TradeOrderItemFromJson(Map<String, dynamic> json) =>
    TradeOrderItem(
      buyUser: (json['buyUser'] as num?)?.toInt(),
      buyerNickname: json['buyerNickname'] as String?,
      buyerPhoto: json['buyerPhoto'] as String?,
      sellUser: (json['sellUser'] as num?)?.toInt(),
      sellerNickname: json['sellerNickname'] as String?,
      sellerPhoto: json['sellerPhoto'] as String?,
      statusList: json['statusList'] as List<dynamic>?,
      id: json['id'] as String?,
      type: json['type'] as String?,
      tradeCurrency: json['tradeCurrency'] as String?,
      tradeCoin: json['tradeCoin'] as String?,
      tradeAmount: json['tradeAmount'] as String?,
      count: json['count'] as String?,
      number: json['number'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      realName: json['realName'] as String?,
      status: json['status'] as String?,
      createDatetime: json['createDatetime'] as String?,
    );

Map<String, dynamic> _$TradeOrderItemToJson(TradeOrderItem instance) =>
    <String, dynamic>{
      'buyUser': instance.buyUser,
      'buyerNickname': instance.buyerNickname,
      'buyerPhoto': instance.buyerPhoto,
      'sellUser': instance.sellUser,
      'sellerNickname': instance.sellerNickname,
      'sellerPhoto': instance.sellerPhoto,
      'statusList': instance.statusList,
      'id': instance.id,
      'type': instance.type,
      'tradeCurrency': instance.tradeCurrency,
      'tradeCoin': instance.tradeCoin,
      'tradeAmount': instance.tradeAmount,
      'count': instance.count,
      'number': instance.number,
      'userId': instance.userId,
      'realName': instance.realName,
      'status': instance.status,
      'createDatetime': instance.createDatetime,
    };
