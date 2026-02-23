// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_rule_detail_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawRuleDetailRes _$WithdrawRuleDetailResFromJson(
  Map<String, dynamic> json,
) => WithdrawRuleDetailRes(
  withdrawRule: json['withdrawRule'] as String?,
  withdrawFee: json['withdraw_fee'] as String?,
  minAmount: json['withdrawMin'] as String?,
  maxAmount: json['withdrawLimit'] as String?,
);

Map<String, dynamic> _$WithdrawRuleDetailResToJson(
  WithdrawRuleDetailRes instance,
) => <String, dynamic>{
  'withdrawRule': instance.withdrawRule,
  'withdraw_fee': instance.withdrawFee,
  'withdrawMin': instance.minAmount,
  'withdrawLimit': instance.maxAmount,
};
