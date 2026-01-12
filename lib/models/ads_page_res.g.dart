// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_page_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsPageRes _$AdsPageResFromJson(Map<String, dynamic> json) => AdsPageRes(
  pageNum: (json['pageNum'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  pages: (json['pages'] as num?)?.toInt(),
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => AdItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AdsPageResToJson(AdsPageRes instance) =>
    <String, dynamic>{
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
      'size': instance.size,
      'total': instance.total,
      'pages': instance.pages,
      'list': instance.list,
    };

AdItem _$AdItemFromJson(Map<String, dynamic> json) => AdItem(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  nickname: json['nickname'] as String?,
  photo: json['photo'] as String?,
  tradeType: json['tradeType'] as String?,
  tradeCurrency: json['tradeCurrency'] as String?,
  leftCount: json['leftCount'] as String?,
  tradeCoin: json['tradeCoin'] as String?,
  premiumRate: json['premiumRate'] as String?,
  truePrice: json['truePrice'] as String?,
  minTrade: json['minTrade'] as String?,
  maxTrade: json['maxTrade'] as String?,
  payType: json['payType'] as String?,
  bankName: json['bankName'] as String?,
  bankcardNumber: json['bankcardNumber'] as String?,
  bankPic: json['bankPic'] as String?,
  status: json['status'] as String?,
  userStatistics: json['userStatistics'] == null
      ? null
      : UserStatistics.fromJson(json['userStatistics'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdItemToJson(AdItem instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'nickname': instance.nickname,
  'photo': instance.photo,
  'tradeType': instance.tradeType,
  'tradeCurrency': instance.tradeCurrency,
  'leftCount': instance.leftCount,
  'tradeCoin': instance.tradeCoin,
  'premiumRate': instance.premiumRate,
  'truePrice': instance.truePrice,
  'minTrade': instance.minTrade,
  'maxTrade': instance.maxTrade,
  'payType': instance.payType,
  'bankName': instance.bankName,
  'bankcardNumber': instance.bankcardNumber,
  'bankPic': instance.bankPic,
  'status': instance.status,
  'userStatistics': instance.userStatistics,
};

UserStatistics _$UserStatisticsFromJson(Map<String, dynamic> json) =>
    UserStatistics(
      orderCount: (json['orderCount'] as num?)?.toInt(),
      orderFinishCount: (json['orderFinishCount'] as num?)?.toInt(),
      commentCount: (json['commentCount'] as num?)?.toInt(),
      commentGoodCount: (json['commentGoodCount'] as num?)?.toInt(),
      confidenceCount: (json['confidenceCount'] as num?)?.toInt(),
      totalTradeCount: json['totalTradeCount'] as String?,
      tradeCurrency: json['tradeCurrency'] as String?,
      isTrust: json['isTrust'] as String?,
      isAddBlackList: json['isAddBlackList'] as String?,
      betweenTradeTimes: json['betweenTradeTimes'] as String?,
      nickname: json['nickname'] as String?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$UserStatisticsToJson(UserStatistics instance) =>
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
