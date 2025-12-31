import 'package:json_annotation/json_annotation.dart';

part 'account_asset_res.g.dart';

@JsonSerializable()
class AccountAssetRes {
  AccountAssetRes();

  late String totalAmount;
  late String totalAmountCurrency;
  late String totalAsset;
  late String totalAssetCurrency;
  late String totalTbayAsset;
  late String totalCardgoalAsset;
  late String merchantStatus;
  String? merchantRemark;
  
  factory AccountAssetRes.fromJson(Map<String,dynamic> json) => _$AccountAssetResFromJson(json);
  Map<String, dynamic> toJson() => _$AccountAssetResToJson(this);
}
