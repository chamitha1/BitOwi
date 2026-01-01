import 'package:json_annotation/json_annotation.dart';

part 'ads_home_res.g.dart';

@JsonSerializable()
class AdsHomeRes {
  AdsHomeRes();

  late num orderCount;
  late num orderFinishCount;
  late num commentCount;
  late num commentGoodCount;
  late num confidenceCount;
  late String totalTradeCount;
  String? tradeCurrency;
  String? isTrust;
  String? isAddBlackList;
  String? betweenTradeTimes;
  String? nickname;
  String? photo;
  
  factory AdsHomeRes.fromJson(Map<String,dynamic> json) => _$AdsHomeResFromJson(json);
  Map<String, dynamic> toJson() => _$AdsHomeResToJson(this);
}
