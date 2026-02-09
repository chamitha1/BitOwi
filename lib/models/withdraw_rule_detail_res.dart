import 'package:json_annotation/json_annotation.dart';

part 'withdraw_rule_detail_res.g.dart';

@JsonSerializable()
class WithdrawRuleDetailRes {
  // final String? withdrawRule;
  // final String? withdrawFee;
  // final String? minAmount;
  // final String? maxAmount;

  @JsonKey(name: 'withdraw_rule')
  final String? withdrawRule;

  @JsonKey(name: 'withdraw_fee')
  final String? withdrawFee;

  @JsonKey(name: 'withdrawMin')
  final String? minAmount;

  @JsonKey(name: 'withdrawLimit')
  final String? maxAmount;

  WithdrawRuleDetailRes({
    this.withdrawRule,
    this.withdrawFee,
    this.minAmount,
    this.maxAmount,
  });

  factory WithdrawRuleDetailRes.fromJson(Map<String, dynamic> json) =>
      _$WithdrawRuleDetailResFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawRuleDetailResToJson(this);
}
