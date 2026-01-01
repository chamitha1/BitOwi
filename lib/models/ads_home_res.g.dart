// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_home_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsHomeRes _$AdsHomeResFromJson(Map<String, dynamic> json) => AdsHomeRes()
  ..orderCount = json['orderCount'] as num
  ..orderFinishCount = json['orderFinishCount'] as num
  ..commentCount = json['commentCount'] as num
  ..commentGoodCount = json['commentGoodCount'] as num
  ..confidenceCount = json['confidenceCount'] as num
  ..totalTradeCount = json['totalTradeCount'] as String
  ..tradeCurrency = json['tradeCurrency'] as String?
  ..isTrust = json['isTrust'] as String?
  ..isAddBlackList = json['isAddBlackList'] as String?
  ..betweenTradeTimes = json['betweenTradeTimes'] as String?
  ..nickname = json['nickname'] as String?
  ..photo = json['photo'] as String?;

Map<String, dynamic> _$AdsHomeResToJson(AdsHomeRes instance) =>
    <String, dynamic>{
      'orderCount': instance.orderCount,
      'orderFinishCount': instance.orderFinishCount,
      'commentCount': instance.commentCount,
      'commentGoodCount': instance.commentGoodCount,
      'confidenceCount': instance.confidenceCount,
      'totalTradeCount': instance.totalTradeCount,
      'tradeCurrency': instance.tradeCurrency,
      'isTrust': instance.isTrust,
      'isAddBlackList': instance.isAddBlackList,
      'betweenTradeTimes': instance.betweenTradeTimes,
      'nickname': instance.nickname,
      'photo': instance.photo,
    };
