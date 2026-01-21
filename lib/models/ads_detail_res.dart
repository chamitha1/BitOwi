import 'package:json_annotation/json_annotation.dart';
import "ads_display_time.dart";
part 'ads_detail_res.g.dart';

@JsonSerializable()
class AdsDetailRes {
  AdsDetailRes();

  late String id;
  late String tradeType;
  late String tradeCurrency;
  late String tradeCoin;
  late String premiumRate;
  late String totalCount;
  late String leftCount;
  late String protectPrice;
  late String truePrice;
  late String minTrade;
  late String maxTrade;
  late String payType;
  late String bankcardId;
  String? bankName;
  String? bankPic;
  late String leaveMessage;
  late String icon;
  late String count;
  late String tradeAmount;
  late String countMax;
  late String tradeAmountMax;
  late String userId;
  late String nickname;
  late String photo;
  List<AdsDisplayTime>? displayTime;

  factory AdsDetailRes.fromJson(Map<String, dynamic> json) =>
      _$AdsDetailResFromJson(json);
  Map<String, dynamic> toJson() => _$AdsDetailResToJson(this);
}
