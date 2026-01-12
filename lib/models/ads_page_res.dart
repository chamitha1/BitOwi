import 'package:json_annotation/json_annotation.dart';

part 'ads_page_res.g.dart';

@JsonSerializable()
class AdsPageRes {
  final int? pageNum;
  final int? pageSize;
  final int? size;
  final int? total;
  final int? pages;
  final List<AdItem> list;

  AdsPageRes({
    this.pageNum,
    this.pageSize,
    this.size,
    this.total,
    this.pages,
    this.list = const [],
  });

  factory AdsPageRes.fromJson(Map<String, dynamic> json) =>
      _$AdsPageResFromJson(json);

  Map<String, dynamic> toJson() => _$AdsPageResToJson(this);
}

@JsonSerializable()
class AdItem {
  final String? id;
  final String? userId; 
  final String? nickname; 
  final String? photo;
  final String? tradeType; 
  final String? tradeCurrency; 
  final String? leftCount; 
  final String? tradeCoin; 
  final String? premiumRate;
  final String? truePrice;
  final String? minTrade; 
  final String? maxTrade; 
  final String? payType; 
  final String? bankName; 
  final String? bankcardNumber;
  final String? bankPic;
  final String? status; 
  final UserStatistics? userStatistics;

  AdItem({
    this.id,
    this.userId,
    this.nickname,
    this.photo,
    this.tradeType,
    this.tradeCurrency,
    this.leftCount,
    this.tradeCoin,
    this.premiumRate,
    this.truePrice,
    this.minTrade,
    this.maxTrade,
    this.payType,
    this.bankName,
    this.bankcardNumber,
    this.bankPic,
    this.status,
    this.userStatistics,
  });

  factory AdItem.fromJson(Map<String, dynamic> json) => _$AdItemFromJson(json);

  Map<String, dynamic> toJson() => _$AdItemToJson(this);
}

@JsonSerializable()
class UserStatistics {
  final int? orderCount;
  final int? orderFinishCount;
  final int? commentCount;
  final int? commentGoodCount;
  final int? confidenceCount;
  final String? totalTradeCount; // "0"
  final String? tradeCurrency;
  final String? isTrust; // null or "1" probably?
  final String? isAddBlackList;
  final String? betweenTradeTimes;
  final String? nickname;
  final String? photo;

  UserStatistics({
    this.orderCount,
    this.orderFinishCount,
    this.commentCount,
    this.commentGoodCount,
    this.confidenceCount,
    this.totalTradeCount,
    this.tradeCurrency,
    this.isTrust,
    this.isAddBlackList,
    this.betweenTradeTimes,
    this.nickname,
    this.photo,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$UserStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatisticsToJson(this);
}
