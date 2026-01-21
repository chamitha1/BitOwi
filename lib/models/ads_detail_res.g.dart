// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_detail_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsDetailRes _$AdsDetailResFromJson(Map<String, dynamic> json) => AdsDetailRes()
  ..id = json['id'] as String
  ..tradeType = json['tradeType'] as String
  ..tradeCurrency = json['tradeCurrency'] as String
  ..tradeCoin = json['tradeCoin'] as String
  ..premiumRate = json['premiumRate'] as String
  ..totalCount = json['totalCount'] as String
  ..leftCount = json['leftCount'] as String
  ..protectPrice = json['protectPrice'] as String
  ..truePrice = json['truePrice'] as String
  ..minTrade = json['minTrade'] as String
  ..maxTrade = json['maxTrade'] as String
  ..payType = json['payType'] as String
  ..bankcardId = json['bankcardId'] as String
  ..bankName = json['bankName'] as String?
  ..bankPic = json['bankPic'] as String?
  ..leaveMessage = json['leaveMessage'] as String
  ..icon = json['icon'] as String
  ..count = json['count'] as String
  ..tradeAmount = json['tradeAmount'] as String
  ..countMax = json['countMax'] as String
  ..tradeAmountMax = json['tradeAmountMax'] as String
  ..userId = json['userId'] as String
  ..nickname = json['nickname'] as String
  ..photo = json['photo'] as String
  ..displayTime = (json['displayTime'] as List<dynamic>?)
      ?.map((e) => AdsDisplayTime.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$AdsDetailResToJson(AdsDetailRes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tradeType': instance.tradeType,
      'tradeCurrency': instance.tradeCurrency,
      'tradeCoin': instance.tradeCoin,
      'premiumRate': instance.premiumRate,
      'totalCount': instance.totalCount,
      'leftCount': instance.leftCount,
      'protectPrice': instance.protectPrice,
      'truePrice': instance.truePrice,
      'minTrade': instance.minTrade,
      'maxTrade': instance.maxTrade,
      'payType': instance.payType,
      'bankcardId': instance.bankcardId,
      'bankName': instance.bankName,
      'bankPic': instance.bankPic,
      'leaveMessage': instance.leaveMessage,
      'icon': instance.icon,
      'count': instance.count,
      'tradeAmount': instance.tradeAmount,
      'countMax': instance.countMax,
      'tradeAmountMax': instance.tradeAmountMax,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'photo': instance.photo,
      'displayTime': instance.displayTime,
    };
