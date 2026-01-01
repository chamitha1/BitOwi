import 'package:json_annotation/json_annotation.dart';

part 'account_detail_account_and_jour_res.g.dart';

@JsonSerializable()
class AccountDetailAccountAndJourRes {
  final String? currency;
  final String? totalAmount;
  final String? usableAmount; 
  final String? frozenAmount;
  final String? totalAmountUsdt;
  final String? totalAsset;
  final String? totalAssetCurrency;
  final String? icon;

  AccountDetailAccountAndJourRes({
    this.currency,
    this.totalAmount,
    this.usableAmount,
    this.frozenAmount,
    this.totalAmountUsdt,
    this.totalAsset,
    this.totalAssetCurrency,
    this.icon,
  });

  factory AccountDetailAccountAndJourRes.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailAccountAndJourResFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDetailAccountAndJourResToJson(this);
}
