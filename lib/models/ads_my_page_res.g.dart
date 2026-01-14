// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_my_page_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsMyPageRes _$AdsMyPageResFromJson(Map<String, dynamic> json) => AdsMyPageRes()
  ..id = json['id'] as String
  ..nickname = json['nickname'] as String
  ..photo = json['photo'] as String
  ..tradeType = json['tradeType'] as String
  ..tradeCurrency = json['tradeCurrency'] as String
  ..tradeCoin = json['tradeCoin'] as String
  ..premiumRate = json['premiumRate'] as String
  ..truePrice = json['truePrice'] as String
  ..minTrade = json['minTrade'] as String
  ..maxTrade = json['maxTrade'] as String
  ..payType = json['payType'] as String
  ..userId = json['userId'] as String
  ..leftCount = json['leftCount'] as String
  ..status = json['status'] as String
  ..bankName = json['bankName'] as String?
  ..bankPic = json['bankPic'] as String?
  ..userStatistics = AdsHomeRes.fromJson(
    json['userStatistics'] as Map<String, dynamic>,
  );

Map<String, dynamic> _$AdsMyPageResToJson(AdsMyPageRes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'photo': instance.photo,
      'tradeType': instance.tradeType,
      'tradeCurrency': instance.tradeCurrency,
      'tradeCoin': instance.tradeCoin,
      'premiumRate': instance.premiumRate,
      'truePrice': instance.truePrice,
      'minTrade': instance.minTrade,
      'maxTrade': instance.maxTrade,
      'payType': instance.payType,
      'userId': instance.userId,
      'leftCount': instance.leftCount,
      'status': instance.status,
      'bankName': instance.bankName,
      'bankPic': instance.bankPic,
      'userStatistics': instance.userStatistics,
    };
